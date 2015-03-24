#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveReceipt(
         IN clientID INT,
		 IN amountPaid DECIMAL(10,2),
		 IN mop INT,
		 IN cashDetails VARCHAR(100),
		 IN bankID INT,
		 IN chequeNumber VARCHAR(100),
		 IN userID INT,
		 IN receiptDate VARCHAR(100),
		 IN billWise VARCHAR(5)
         )
BEGIN
DECLARE receiptID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE cashID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;
call generateActionID('Save Receipt',actionID);
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'RECEIPT';
INSERT into receipt values(NULL,clientID,userID,amountPaid,receiptDate,mop,cashDetails,bankID,chequeNumber,billWise,null,actionID);		
SELECT MAX(receipt_id) into receiptID from receipt where client_id=clientID and user_id =userID and close_action_id is null;
INSERT into client_transaction values(NULL,clientID,'RECEIPT',2,receiptDate,0,amountPaid,0,receiptID,referenceTypeID);
##Deduct the amount from either bank or from cash
IF mop = 1 THEN #CASH transaction
	SELECT 
		c.client_id into cashID
	FROM
		client c,
		client_category cc
	WHERE
		c.user_id = userID
			and cc.category_id = c.client_category
			and cc.category = 'CASH';
	INSERT into client_transaction values(NULL,cashID,'RECEIPT',1,receiptDate,amountPaid,0,0,receiptID,referenceTypeID);
ELSE
	INSERT into client_transaction values(NULL,bankID,'RECEIPT',1,receiptDate,amountPaid,0,0,receiptID,referenceTypeID);
END IF;

SELECT MAX(receipt_id) receipt_id from receipt where client_id=clientID and user_id =userID and close_action_id is null;
END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveInvoiceWiseReceipt(
         IN receiptID INT,
		 IN invoiceID INT,
	     IN amountOutstanding DECIMAL(10,2),
		 IN paidFull VARCHAR(5)
         )
BEGIN
DECLARE existingAmount DECIMAL(10,2) DEFAULT 0;
SELECT outstanding_amt INTO existingAmount from invoice where invoice_id =invoiceID;
INSERT into receipt_invoice values(receiptID,invoiceID,existingAmount-amountOutstanding);

UPDATE invoice set outstanding_amt = amountOutstanding,paid =paidFull
where invoice_id = invoiceID;

END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE getReceiptDetails(
         IN receiptID INT,
		 IN userID INT)
BEGIN
	SELECT r1.receipt_id,r1.receipt_date,r1.amount_paid,r1.client_name,r1.mop,
	r1.billWise,r1.cash_details,r1.cheque_number,bank.account_name bank_name from 
	(SELECT r.receipt_id,r.receipt_date,r.amount_paid,c.account_name client_name,mop.mop,
	r.billWise,r.cash_details,r.cheque_number,r.bank_id
	from 
	receipt r,
	client c,
	mode_of_payment mop
	where r.receipt_id = receiptID
	and r.user_id =userID
	and r.close_action_id is null
	and r.client_id =c.client_id
	and c.close_action_id is null
	and r.mop_id = mop.mop_id)r1
		 LEFT OUTER JOIN
	(select client_id,account_name from client
	 where close_action_id is null and user_id =userID and client_category=4)bank
	ON r1.bank_id = bank.client_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getReceiptInvoicesDetails(
         IN receiptID INT,
		 IN userID INT)
BEGIN
	select i.invoice_id ,i.invoice_number,i.sub_total,i.vat_total,i.total,ri.amount receipt_amount from 
	receipt_invoice ri,
	invoice i 
	where ri.payment_id =receiptID
	and ri.invoice_id =i.invoice_id
	and i.close_action_id is null;
	END//
DELIMITER ;
