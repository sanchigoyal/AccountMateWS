#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE savePayment(
         IN clientID INT,
		 IN amountPaid DECIMAL(10,2),
		 IN mop INT,
		 IN cashDetails VARCHAR(100),
		 IN bankID INT,
		 IN chequeNumber VARCHAR(100),
		 IN userID INT,
		 IN paymentDate VARCHAR(100),
		 IN billWise VARCHAR(5)
         )
BEGIN
DECLARE paymentID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE cashID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;
call generateActionID('Save Payment',actionID);
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'PAYMENT';
INSERT into payment values(NULL,clientID,userID,amountPaid,paymentDate,mop,cashDetails,bankID,chequeNumber,billWise,null,actionID);		
SELECT MAX(payment_id) into paymentID from payment where client_id=clientID and user_id =userID and close_action_id is null;
INSERT into client_transaction values(NULL,clientID,'PAYMENT',1,paymentDate,amountPaid,0,0,paymentID,referenceTypeID);
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
	INSERT into client_transaction values(NULL,cashID,'PAYMENT',2,paymentDate,0,amountPaid,0,paymentID,referenceTypeID);
ELSE
	INSERT into client_transaction values(NULL,bankID,'PAYMENT',2,paymentDate,0,amountPaid,0,paymentID,referenceTypeID);
END IF;

SELECT MAX(payment_id) payment_id from payment where client_id=clientID and user_id =userID and close_action_id is null;
END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveInvoiceWisePayment(
         IN paymentID INT,
		 IN invoiceID INT,
	     IN amountOutstanding DECIMAL(10,2),
		 IN paidFull VARCHAR(5)
         )
BEGIN
DECLARE existingAmount DECIMAL(10,2) DEFAULT 0;
SELECT outstanding_amt INTO existingAmount from invoice where invoice_id =invoiceID;
INSERT into paid_invoice values(paymentID,invoiceID,existingAmount-amountOutstanding);

UPDATE invoice set outstanding_amt = amountOutstanding,paid =paidFull
where invoice_id = invoiceID;

END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE getPaymentDetails(
         IN paymentID INT,
		 IN userID INT)
BEGIN
	SELECT p1.payment_id,p1.payment_date,p1.amount_paid,p1.client_name,p1.mop,
	p1.billWise,p1.cash_details,p1.cheque_number,bank.account_name bank_name from 
	(SELECT p.payment_id,p.payment_date,p.amount_paid,c.account_name client_name,mop.mop,
	p.billWise,p.cash_details,p.cheque_number,p.bank_id
	from 
	payment p,
	client c,
	mode_of_payment mop
	where p.payment_id = paymentID
	and p.user_id =userID
	and p.close_action_id is null
	and p.client_id =c.client_id
	and c.close_action_id is null
	and p.mop_id = mop.mop_id)p1
		 LEFT OUTER JOIN
	(select client_id,account_name from client
	 where close_action_id is null and user_id =userID and client_category=4)bank
	ON p1.bank_id = bank.client_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getPaymentInvoicesDetails(
         IN paymentID INT,
		 IN userID INT)
BEGIN
	select i.invoice_id ,i.invoice_number,i.sub_total,i.vat_total,i.total,pi.amount paid_amount from 
	paid_invoice pi,
	invoice i 
	where pi.payment_id =paymentID
	and pi.invoice_id =i.invoice_id
	and i.close_action_id is null;
	END//
DELIMITER ;
