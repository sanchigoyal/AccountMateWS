#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE savePurchaseInvoice(
         IN clientID INT,
		 IN clientTIN VARCHAR(100),
		 IN invoiceDate VARCHAR(100),
		 IN invoiceNumber VARCHAR(100),
		 IN reference VARCHAR(100),
		 IN shippedMethod VARCHAR(100),
		 IN shippedTo VARCHAR(100),
		 IN subTotal DECIMAL(10,2),
		 IN vatTotal DECIMAL(10,2),
		 IN total DECIMAL(10,2),
		 IN userID INT,
		 IN customDaysToPay INT
         )
BEGIN
DECLARE invoiceID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;
call generateActionID('Save Purchase Invoice',actionID);
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'INVOICE';
INSERT into invoice values(NULL,clientID,userID,clientTIN,invoiceDate,invoiceNumber,1,reference,shippedMethod,shippedTo,subTotal,vatTotal,total,'N',total,null,actionID,customDaysToPay);		
SELECT MAX(invoice_id) into invoiceID from invoice where client_id=clientID and user_id =userID;
INSERT into client_transaction values(NULL,clientID,'PURCHASE',2,invoiceDate,0,total,0,invoiceID,referenceTypeID);

SELECT MAX(invoice_id) invoice_id from invoice where client_id=clientID and user_id =userID;

END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE savePurchaseItemDetails(
         IN productID INT,
		 IN invoiceID INT,
		 IN quantity INT,
		 IN priceWithOutVat DECIMAL(10,2),
		 IN vatPercent DECIMAL(10,2),
		 IN priceWithVat DECIMAL(10,2),
		 IN total DECIMAL(10,2),
		 IN invoiceDate VARCHAR(100),
		 IN clientID INT,
		 IN updateCP BOOLEAN
         )
BEGIN
DECLARE actionID INT DEFAULT 0;	
DECLARE clientName VARCHAR(100);	
call generateActionID('Update Cost Price',actionID);
INSERT into invoice_item values(NULL,invoiceID,productID,quantity,priceWithOutVat,vatPercent,priceWithVat,total);
SELECT account_name into clientName from client where client_id=clientID;		
INSERT into product_stock values(null,productID,clientName,1,invoiceDate,quantity,0,0,invoiceID);

IF updateCP THEN
	UPDATE price 
	SET close_action_id = actionID
	WHERE product_id = productID
	AND price_type= 1;
	INSERT into price values(null,productID,1,priceWithVat,null,actionID);
END IF;
END//
DELIMITER ;

#Proc to get invoice details
DELIMITER //
CREATE PROCEDURE getInvoiceDetails(
         IN userID INT,
		 IN invoiceID INT
         )
BEGIN
select c.client_id,c.account_name,c.tin_number,
		i.invoice_date,i.invoice_number,it.invoice_type,
		i.reference,i.shipped_method,i.shipped_to,
		i.sub_total,i.vat_total,i.total,i.outstanding_amt,
		if(i.close_action_id is null,'ACTIVE','DELETED') INVOICE_STATUS,
		if(i.custom_days_to_pay != 0,i.custom_days_to_pay,c.custom_days_pay) CUSTOM_DAYS_TO_PAY,
		i.paid PAYMENT_STATUS,
		DATEDIFF(CURDATE(),i.invoice_date) DATE_DIFF
from invoice i ,client c,invoice_type it
where it.invoice_type_id = i.invoice_type_id
and c.client_id = i.client_id
and i.invoice_id =invoiceID
and i.user_id = userID;
END//
DELIMITER ;

#Proc to get item details
DELIMITER //
CREATE PROCEDURE getInvoiceItems(
         IN userID INT,
		 IN invoiceID INT
         )
BEGIN
select p.product_name , it.*
from product p ,invoice_item it,invoice i
where it.invoice_id= i.invoice_id
and i.invoice_id =invoiceID
and i.user_id =userID
and p.product_id = it.product_id;
END//
DELIMITER ;


#Proc to get invoices details
DELIMITER //
CREATE PROCEDURE getInvoicesDetails(
         IN userID INT,
		 IN startdate VARCHAR(100),
		 IN enddate VARCHAR(100),
		 IN invoiceType INT
         )
BEGIN
if invoiceType = 1 then 
	select i.invoice_id,c.account_name,i.client_tin AS TIN_NUMBER,
			i.invoice_date,i.invoice_number,it.invoice_type,
			i.reference,i.shipped_method,i.shipped_to,
			i.sub_total,i.vat_total,i.total,i.paid,i.outstanding_amt,
			if(i.close_action_id is null,'ACTIVE','DELETED') INVOICE_STATUS,
			if(i.custom_days_to_pay != 0,i.custom_days_to_pay,c.custom_days_pay) CUSTOM_DAYS_TO_PAY,
			i.paid PAYMENT_STATUS,
			DATEDIFF(CURDATE(),i.invoice_date) DATE_DIFF
	from invoice i ,client c,invoice_type it
	where i.user_id = userID
	and it.invoice_type_id = invoiceType
	and i.invoice_type_id =it.invoice_type_id
	and c.client_id = i.client_id
	and i.invoice_date between startdate and enddate;
else
	select i.invoice_id,c.account_name,i.client_tin AS TIN_NUMBER,
			i.invoice_date,i.invoice_number,it.invoice_type,
			i.reference,i.shipped_method,i.shipped_to,
			i.sub_total,i.vat_total,i.total,i.paid,i.outstanding_amt,
			if(i.close_action_id is null,'ACTIVE','DELETED') INVOICE_STATUS,
			if(i.custom_days_to_pay != 0,i.custom_days_to_pay,c.custom_days_pay) CUSTOM_DAYS_TO_PAY,
			i.paid PAYMENT_STATUS,
			DATEDIFF(CURDATE(),i.invoice_date) DATE_DIFF
	from invoice i ,client c,invoice_type it
	where i.user_id = userID
	and it.invoice_type_id <> 1
	and i.invoice_type_id =it.invoice_type_id
	and c.client_id = i.client_id
	and i.invoice_date between startdate and enddate;
end if;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getCashBalance(
		 IN userID INT
         )
BEGIN
select 
    (SUM(ct.debit_value) - SUM(ct.credit_value)) AS BALANCE
from
    client_transaction ct,
    client c
where
    c.user_id = userID
        and c.client_category = 3
        and c.close_action_id is null
        and ct.client_id = c.client_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getUnpaidInvoiceList(
		 IN userID INT,
		 IN clientID INT,
		 IN invoiceTypeID INT
         )
BEGIN
if invoiceTypeID =1 then 
	select 
		invoice_id, invoice_number
	from
		invoice
	where 
			invoice_type_id = 1 and paid = 'N'
			and client_id = clientID
			and user_id = userID
			and close_action_id is null;
else
	select 
		invoice_id, invoice_number
	from
		invoice
	where 
			invoice_type_id <> 1 and paid = 'N'
			and client_id = clientID
			and user_id = userID
			and close_action_id is null;
end if;
END//
DELIMITER ;


#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveSalesInvoice(
         IN clientID INT,
		 IN clientTIN VARCHAR(100),
		 IN invoiceDate VARCHAR(100),
		 IN invoiceTypeID INT,
		 IN reference VARCHAR(100),
		 IN shippedMethod VARCHAR(100),
		 IN shippedTo VARCHAR(100),
		 IN subTotal DECIMAL(10,2),
		 IN vatTotal DECIMAL(10,2),
		 IN total DECIMAL(10,2),
		 IN userID INT,
		 IN customDaysToPay INT
         )
BEGIN
DECLARE invoiceID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE invoiceNumber INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;		
call generateActionID('New Sales Invoice',actionID);
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'INVOICE';
SELECT 
    (latest_invoice_number + 1)
into invoiceNumber from
    invoice_number
where
    user_id = userID
        and invoice_type_id = invoiceTypeID;
INSERT into invoice values(NULL,clientID,userID,clientTIN,invoiceDate,invoiceNumber,invoiceTypeID,reference,shippedMethod,shippedTo,subTotal,vatTotal,total,'N',total,null,actionID,customDaysToPay);		
SELECT MAX(invoice_id) into invoiceID from invoice where client_id=clientID and user_id =userID;
INSERT into client_transaction values(NULL,clientID,'SALES',1,invoiceDate,total,0,0,invoiceID,referenceTypeID);
UPDATE invoice_number_audit 
SET 
    close_action_id = actionID
where
    close_action_id is null
        and user_id = userID
        and invoice_type_id = invoiceTypeID;
UPDATE invoice_number 
SET 
    latest_invoice_number = invoiceNumber,
    latest_invoice_date = invoiceDate
WHERE
    user_id = userID
        and invoice_type_id = invoiceTypeID;

INSERT INTO invoice_number_audit 
		(select 
				null,
				invoice_number_id,
				invoice_type_id,
				latest_invoice_date,
				latest_invoice_number,
				user_id,
				null,
				actionID 
		from invoice_number 
		where user_id =userID 
		and invoice_type_id = invoiceTypeID);
SELECT 
    MAX(invoice_id) invoice_id, invoiceNumber AS invoice_number
from
    invoice
where
    client_id = clientID
        and user_id = userID;
END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveSalesItemDetails(
         IN productID INT,
		 IN invoiceID INT,
		 IN quantity INT,
		 IN priceWithOutVat DECIMAL(10,2),
		 IN vatPercent DECIMAL(10,2),
		 IN priceWithVat DECIMAL(10,2),
		 IN total DECIMAL(10,2),
		 IN invoiceDate VARCHAR(100),
		 IN clientID INT
         )
BEGIN
DECLARE clientName VARCHAR(100);	
INSERT into invoice_item values(NULL,invoiceID,productID,quantity,priceWithOutVat,vatPercent,priceWithVat,total);
SELECT account_name into clientName from client where client_id=clientID;		
INSERT into product_stock values(null,productID,clientName,2,invoiceDate,0,quantity,0,invoiceID);
END//
DELIMITER ;


#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE getLatestBillingDate(
		IN userID INT)
BEGIN
select 
    invoice_type_id, latest_invoice_date AS invoice_date
from
    invoice_number
where
    user_id = userID;
END//
DELIMITER ;


#Proc to delete a invoice
DELIMITER //
CREATE PROCEDURE deleteInvoice(
		 IN userID INT,
		 IN invoiceID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('Invoice Delete',actionID);

UPDATE invoice 
set 
    close_action_id = actionID
where
    invoice_id = invoiceID
        and user_id = userID
		and close_action_id is null;

END//
DELIMITER ;

