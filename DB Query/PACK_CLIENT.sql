#Proc to add new client
DELIMITER //
CREATE PROCEDURE AddNewClient(
         IN clientFirstName VARCHAR(100),
		 IN clientLastName VARCHAR(100),
		 IN tinNumber VARCHAR(100),
		 IN email VARCHAR(100),
		 IN accountName VARCHAR(100),
		 IN clientCategory INT,
		 IN phoneNumber VARCHAR(20),
		 IN address VARCHAR(100),
		 IN state VARCHAR(50),
		 IN country VARCHAR(50),
		 IN customDaysToPay INT,
		 IN openingBalance DECIMAL(8,2),
		 IN userID INT
         )
BEGIN
DECLARE clientID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;		
call generateActionID('New client creation',actionID);

INSERT into client values (NULL,clientFirstName,clientLastName,email,accountName,clientCategory,phoneNumber,address,state,country,customDaysToPay,openingBalance,userID,actionID,null,tinNumber);		
SELECT MAX(client_id) into clientID from client;
if clientCategory=2 then
INSERT into client_transaction values(NULL,clientID,'Opening Balance',2,CURDATE(),0,openingBalance,0-openingBalance,null,null);
else
INSERT into client_transaction values(NULL,clientID,'Opening Balance',1,CURDATE(),openingBalance,0,openingBalance,null,null);
end if;
END//
DELIMITER ;

#Proc to update client
DELIMITER //
CREATE PROCEDURE updateClient(
         IN clientFirstName VARCHAR(100),
		 IN clientLastName VARCHAR(100),
		 IN tinNumber VARCHAR(100),
		 IN email VARCHAR(100),
		 IN accountName VARCHAR(100),
		 IN clientCategory INT,
		 IN phoneNumber VARCHAR(20),
		 IN address VARCHAR(100),
		 IN state VARCHAR(50),
		 IN country VARCHAR(50),
		 IN customDaysToPay INT,
		 IN openingBalance DECIMAL(8,2),
		 IN userID INT,
		 IN clientID INT
         )
BEGIN
UPDATE client 
SET 
    first_name = clientFirstName,
    last_name = clientLastName,
	tin_number = tinNumber,
    email = email,
    account_name = accountName,
    client_category = clientCategory,
    phone_number = phoneNumber,
    address = address,
    state = state,
    country = country,
    custom_days_pay = customDaysToPay,
    opening_balance = openingBalance
WHERE
    client_id = clientID
        AND user_id = userID;	

if clientCategory=1 then
	UPDATE client_transaction 
	SET 
		transaction_type_id = 1,
		debit_value = openingBalance,
		credit_value = 0
	WHERE
		client_id = clientID
			AND transaction_details = 'Opening Balance';
else
	UPDATE client_transaction 
	SET 
		transaction_type_id = 2,
		debit_value = 0,
		credit_value = openingBalance
	WHERE
		client_id = clientID
			AND transaction_details = 'Opening Balance';
end if;
END//
DELIMITER ;

#Proc to get all clients details
DELIMITER //
CREATE PROCEDURE getClientsDetails(
		 IN userID INT,
		 IN categoryID INT
         )
BEGIN
IF categoryID = -1 then
SELECT
    st.client_id,st.account_name,st.first_name,st.last_name,st.email,st.phone_number,st.country,
    st.state,st.address,st.CLIENT_CATEGORY,st.tin_number,SUM(st.debit_value) debit,SUM(st.credit_value) credit
from
    (SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
    FROM
        client c, client_transaction ct, client_category cc
    WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
            #AND cc.category in ('Sundry Debtor' , 'Sundry Creditor')
            AND ct.reference_type_id is null UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,c.address,
		cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
     FROM
        client c, client_transaction ct, client_category cc,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
            #AND cc.category in ('Sundry Debtor' , 'Sundry Creditor')
            AND ct.reference_type_id = trt.reference_type_id
			AND trt.reference_type = 'PAYMENT' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
	 FROM
        client c, client_transaction ct, client_category cc, invoice i,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
            #AND cc.category in ('Sundry Debtor' , 'Sundry Creditor')
            AND ct.reference_type_id = trt.reference_type_id
            AND ct.reference_id = i.invoice_id
            AND i.close_action_id is null
			AND trt.reference_type = 'INVOICE' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
	 FROM
        client c, client_transaction ct, client_category cc, expense e,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
            #AND cc.category in ('Sundry Debtor' , 'Sundry Creditor')
            AND ct.reference_type_id = trt.reference_type_id
            AND ct.reference_id = e.expense_id
            AND e.close_action_id is null
			AND trt.reference_type = 'EXPENSE' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,c.address,
		cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
     FROM
        client c, client_transaction ct, client_category cc,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
            #AND cc.category in ('Sundry Debtor' , 'Sundry Creditor')
            AND ct.reference_type_id = trt.reference_type_id
			AND trt.reference_type = 'RECEIPT') st
GROUP BY st.client_id
ORDER BY st.account_name;
else
SELECT
    st.client_id,st.account_name,st.first_name,st.last_name,st.email,st.phone_number,st.country,
    st.state,st.address,st.CLIENT_CATEGORY,st.tin_number,SUM(st.debit_value) debit,SUM(st.credit_value) credit
from
    (SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
    FROM
        client c, client_transaction ct,client_category cc
    WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
			AND cc.category_id = categoryID
            AND ct.reference_type_id is null UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,c.address,
		cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
     FROM
        client c, client_transaction ct,client_category cc,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
			AND cc.category_id = categoryID
            AND ct.reference_type_id = trt.reference_type_id
			AND trt.reference_type = 'PAYMENT' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
	 FROM
        client c, client_transaction ct,client_category cc, invoice i,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
			AND cc.category_id = categoryID
            AND ct.reference_type_id = trt.reference_type_id
            AND ct.reference_id = i.invoice_id
            AND i.close_action_id is null
			AND trt.reference_type = 'INVOICE' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,
		c.address,cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
	 FROM
        client c, client_transaction ct,client_category cc, expense e,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
			AND cc.category_id = categoryID
            AND ct.reference_type_id = trt.reference_type_id
            AND ct.reference_id = e.expense_id
            AND e.close_action_id is null
			AND trt.reference_type = 'EXPENSE' UNION ALL 
	 SELECT 
        c.client_id,c.account_name,c.first_name,c.last_name,c.email,c.phone_number,c.country,c.state,c.address,
		cc.category AS CLIENT_CATEGORY,c.tin_number,ct.transaction_details,ct.debit_value,ct.credit_value
     FROM
        client c, client_transaction ct,client_category cc,transaction_reference_type trt
     WHERE
        c.user_id = userID
            AND c.close_action_id is null
            AND c.client_id = ct.client_id
            AND c.client_category = cc.category_id
			AND cc.category_id = categoryID
            AND ct.reference_type_id = trt.reference_type_id
			AND trt.reference_type = 'RECEIPT') st
GROUP BY st.client_id
ORDER BY st.account_name;
end if;
END//
DELIMITER ;

#Proc to get client name only
DELIMITER //
CREATE PROCEDURE getClientName(
		 IN userID INT,
		 IN clientID INT
         )
BEGIN
SELECT 
    account_name
from
    client
where
    user_id = userID
        and client_id = clientID;
END//
DELIMITER ;

#Proc to get client's transaction
DELIMITER //
CREATE PROCEDURE getClientTransactions(
		 IN userID INT,
		 IN clientID INT,
		 IN startdate VARCHAR(100),
		 IN enddate VARCHAR(100)
         )
BEGIN
SELECT st.* FROM  
(SELECT 
	0 AS transaction_id, 0 AS client_id,'Previous Balance' AS detail,0 AS transaction_type_id,
	'1000-01-01' AS transaction_date,0.00 AS debit_value,
	COALESCE(sum(ct.credit_value)-sum(ct.debit_value),0) AS credit_value,0.00 AS balance,0 AS reference_id,
	null AS reference_type,null AS reference_number
	FROM 
		client_transaction ct,
		client c
	WHERE
		c.user_id =userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null
		and ct.transaction_date between '1000-01-01' and DATE_SUB(startdate,INTERVAL 1 DAY)
UNION ALL
SELECT ct.transaction_id, ct.client_id,ct.transaction_details AS detail,ct.transaction_type_id,ct.transaction_date,
		ct.debit_value,ct.credit_value,ct.balance,ct.reference_id,null AS reference_type,null AS reference_number
	FROM client_transaction ct,
		client c
	WHERE
		c.user_id = userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null	
		and ct.transaction_date between startdate and enddate
		and ct.transaction_details = 'Opening Balance'
UNION ALL
SELECT ct.transaction_id, ct.client_id,ct.transaction_details AS detail,ct.transaction_type_id,ct.transaction_date,
		ct.debit_value,ct.credit_value,ct.balance,ct.reference_id,trt.reference_type
		,i.invoice_number AS reference_number
	FROM client_transaction ct,
		client c,
		transaction_reference_type trt,
		invoice i
	WHERE
		c.user_id = userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null	
		and ct.transaction_date between startdate and enddate
		and ct.reference_type_id = trt.reference_type_id
		and trt.reference_type = 'INVOICE'
		and i.user_id = userID
		and i.invoice_id = ct.reference_id
		and i.close_action_id is null
UNION ALL
SELECT ct.transaction_id, ct.client_id,ct.transaction_details AS detail,ct.transaction_type_id,ct.transaction_date,
		ct.debit_value,ct.credit_value,ct.balance,ct.reference_id,trt.reference_type
		,ct.reference_id AS reference_number
	FROM client_transaction ct,
		client c,
		transaction_reference_type trt
	WHERE
		c.user_id = userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null	
		and ct.transaction_date between startdate and enddate
		and ct.reference_type_id = trt.reference_type_id
		and trt.reference_type = 'PAYMENT'
UNION ALL
SELECT ct.transaction_id, ct.client_id,ct.transaction_details AS detail,ct.transaction_type_id,ct.transaction_date,
		ct.debit_value,ct.credit_value,ct.balance,ct.reference_id,trt.reference_type
		,ct.reference_id AS reference_number
	FROM client_transaction ct,
		client c,
		transaction_reference_type trt,
		expense e
	WHERE
		c.user_id = userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null	
		and ct.transaction_date between startdate and enddate
		and ct.reference_type_id = trt.reference_type_id
		and trt.reference_type = 'EXPENSE'
		and e.user_id = userID
		and e.expense_id = ct.reference_id
		and e.close_action_id is null
UNION ALL
SELECT ct.transaction_id, ct.client_id,ct.transaction_details AS detail,ct.transaction_type_id,ct.transaction_date,
		ct.debit_value,ct.credit_value,ct.balance,ct.reference_id,trt.reference_type
		,ct.reference_id AS reference_number
	FROM client_transaction ct,
		client c,
		transaction_reference_type trt
	WHERE
		c.user_id = userID
		and c.client_id =clientID
		and ct.client_id = c.client_id
		and c.close_action_id is null	
		and ct.transaction_date between startdate and enddate
		and ct.reference_type_id = trt.reference_type_id
		and trt.reference_type = 'RECEIPT')st
ORDER BY st.transaction_date,reference_number;
END//
DELIMITER ;

#Proc to delete a client
DELIMITER //
CREATE PROCEDURE deleteClient(
		 IN userID INT,
		 IN clientID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('Client Deletion',actionID);

UPDATE client 
set 
    close_action_id = actionID
where
    client_id = clientID
        and user_id = userID
		and close_action_id is null;

END//
DELIMITER ;

#Proc to get client details
DELIMITER //
CREATE PROCEDURE getClientDetails(
		 IN userID INT,
		 IN clientID INT
         )
BEGIN
SELECT 
    *
from
    client
where
    user_id = userID
        and client_id = clientID;
END//
DELIMITER ;
commit;

DELIMITER //
CREATE PROCEDURE getClientCategories()
begin
	SELECT * from client_category;
	#where category in ('Sundry Debtor','Sundry Creditor');
END//
DELIMITER ;

