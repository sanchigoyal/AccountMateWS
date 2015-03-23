#Proc to get expense category
DELIMITER //
CREATE PROCEDURE getExpenseCategories()
BEGIN
SELECT category_id, category from expense_category;
END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE saveExpense(
         IN expenseCategoryID INT,
		 IN description VARCHAR(100),
		 IN amount DECIMAL(10,2),
		 IN mopID INT,
		 IN bankID INT,
		 IN chequeNumber VARCHAR(100),
		 IN expenseDate VARCHAR(100),
		 IN userID INT
         )
BEGIN
DECLARE expenseID INT DEFAULT 0;
DECLARE cashID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE cashClientID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;
call generateActionID('Save Expense',actionID);

INSERT into expense values(NULL,expenseCategoryID,description,amount,mopID,bankID,chequeNumber,expenseDate,userID,null,actionID);
SELECT max(expense_id) into expenseID from expense where user_id = userID and close_action_id is null;
SELECT mop_id into cashID from mode_of_payment where mop='Cash'; 
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'EXPENSE';
IF mopID = cashID then
	# Do cash transaction
	SELECT 
		c.client_id
	into cashClientID from
		client c,
		client_category cc
	where
		c.user_id = userID
			and c.account_name = 'CASH'
			and c.client_category = cc.category_id
			and cc.category = 'CASH'
			and close_action_id is null;
	INSERT into client_transaction values(NULL,cashClientID,'EXPENSE',2,expenseDate,0,amount,0,expenseID,referenceTypeID);
ELSE
	INSERT into client_transaction values(NULL,bankID,'EXPENSE',2,expenseDate,0,amount,0,expenseID,referenceTypeID);
end if;
END//
DELIMITER ;

#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE getExpensesDetails(
         IN userID INT,
		 IN startdate VARCHAR(100),
		 IN enddate VARCHAR(100)
         )
BEGIN
	SELECT e.expense_id, ec.category_id,ec.category,e.description,e.amount,mop.mop_id,mop.mop,
	e.bank_id,'' BANK_NAME,e.chequeNumber CHEQUE_NUMBER ,e.expense_date FROM
	expense e,
	expense_category ec,
	mode_of_payment mop
	where
	e.user_id =userID
	and e.expense_category_id = ec.category_id
	and e.mop_id = mop.mop_id
	and mop.mop ='Cash'
	and expense_date between startdate and enddate
	and close_action_id is null
	UNION all
	SELECT e.expense_id, ec.category_id,ec.category,e.description,e.amount,mop.mop_id,mop.mop,
	e.bank_id,c.account_name BANK_NAME,e.chequeNumber CHEQUE_NUMBER ,e.expense_date FROM
	expense e,
	expense_category ec,
	mode_of_payment mop,
	client c
	where
	e.user_id =userID
	and e.expense_category_id = ec.category_id
	and e.mop_id = mop.mop_id
	and mop.mop ='Cheque'
	and expense_date between startdate and enddate
	and e.close_action_id is null
	and c.client_id = e.bank_id
	and c.close_action_id is null
	order by expense_date,expense_id;
END//
DELIMITER ;

#Proc to delete a expense
DELIMITER //
CREATE PROCEDURE deleteExpense(
		 IN userID INT,
		 IN expenseID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('Expense Delete',actionID);

UPDATE expense 
set 
    close_action_id = actionID
where
    expense_id = expenseID
        and user_id = userID
		and close_action_id is null;

END//
DELIMITER ;

#Proc to delete a expense
DELIMITER //
CREATE PROCEDURE getExpenseDetails(
		 IN expenseID INT,
		 IN userID INT
         )
BEGIN
SELECT e1.expense_id,e1.category_id,e1.category,e1.description,e1.amount,
		e1.mop_id,e1.mop,e1.bank_id,e1.CHEQUE_NUMBER,e1.expense_date,bank.account_name bank_name
	FROM
	(SELECT 
		e.expense_id,
		e.expense_category_id as category_id,
		ec.category,
		e.description,
		e.amount,
		e.mop_id,
		mop.mop,
		e.bank_id,
		e.chequeNumber CHEQUE_NUMBER,
		e.expense_date
	from
		expense e,
		expense_category ec,
		mode_of_payment mop
	WHERE
		e.user_id = userID
			and e.expense_id = expenseID
			and e.close_action_id is null
			and e.expense_category_id = ec.category_id
			and e.mop_id = mop.mop_id)e1
		LEFT OUTER JOIN
	(select client_id,account_name from client
	 where close_action_id is null and user_id =userID 
	and client_category=4)bank
	ON e1.bank_id = bank.client_id;
END//
DELIMITER ;


#Proc to save an puchase invoice
DELIMITER //
CREATE PROCEDURE updateExpense(
		 IN expenseID INT,
         IN expenseCategoryID INT,
		 IN description VARCHAR(100),
		 IN amount DECIMAL(10,2),
		 IN mopID INT,
		 IN bankID INT,
		 IN chequeNumber VARCHAR(100),
		 IN expenseDate VARCHAR(100),
		 IN userID INT
         )
BEGIN

DECLARE expenseIDNew INT DEFAULT 0;
DECLARE cashID INT DEFAULT 0;
DECLARE referenceTypeID INT DEFAULT 0;
DECLARE cashClientID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;
call generateActionID('Update Expense',actionID);

UPDATE expense 
set 
    close_action_id = actionID
where
    expense_id = expenseID
        and user_id = userID
		and close_action_id is null;

INSERT into expense values(NULL,expenseCategoryID,description,amount,mopID,bankID,chequeNumber,expenseDate,userID,null,actionID);
SELECT max(expense_id) into expenseID from expense where user_id = userID and close_action_id is null;
SELECT mop_id into cashID from mode_of_payment where mop='Cash'; 
SELECT reference_type_id into referenceTypeID from transaction_reference_type where reference_type = 'EXPENSE';
IF mopID = cashID then
	# Do cash transaction
	SELECT 
		c.client_id
	into cashClientID from
		client c,
		client_category cc
	where
		c.user_id = userID
			and c.account_name = 'CASH'
			and c.client_category = cc.category_id
			and cc.category = 'CASH'
			and close_action_id is null;
	INSERT into client_transaction values(NULL,cashClientID,'EXPENSE',2,expenseDate,0,amount,0,expenseID,referenceTypeID);
ELSE
	INSERT into client_transaction values(NULL,bankID,'EXPENSE',2,expenseDate,0,amount,0,expenseID,referenceTypeID);
end if;
END//
DELIMITER ;