create database am00801;
use am00801;
commit;
	
CREATE TABLE user(
    user_id INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	PRIMARY KEY (user_id),
    first_name VARCHAR(100) NOT NULL, # type of insect
    last_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	user_password varchar(100) NOT null,
	account_name VARCHAR(100) NOT NULL,
	phone_number VARCHAR(20),
	address	VARCHAR(100) NOT NULL,
	state VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL
);

alter table user AUTO_INCREMENT=10000;
alter table user add (file_name VARCHAR(100));

CREATE TABLE action_history(
	action_id INT UNSIGNED AUTO_INCREMENT,
	PRIMARY KEY (action_id),
	action_details VARCHAR(100),
	action_date	VARCHAR(100)
);

alter table action_history AUTO_INCREMENT=1000000;
ALTER TABLE action_history
MODIFY COLUMN action_date  datetime NOT NULL ;

CREATE Table client(
	client_id INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	PRIMARY KEY (client_id),
    first_name VARCHAR(100) NOT NULL, # type of insect
    last_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	account_name VARCHAR(100) NOT NULL,
	client_category VARCHAR(100) NOT NULL,
	phone_number VARCHAR(20),
	address	VARCHAR(100) NOT NULL,
	state VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	custom_days_pay INT NOT NULL, 
	opening_balance DECIMAL(8,2),
	user_id INT UNSIGNED,
	FOREIGN KEY (user_id) REFERENCES user(user_id),
	create_action_id INT UNSIGNED,
	close_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id)
);

alter table client AUTO_INCREMENT=20000;
commit;

alter table client ADD tin_number VARCHAR(100);

##Create this entry on registration of the user.
INSERT into client values (NULL,'CASH','CASH','CASH','CASH',3,0,'CASH','CASH','CASH',0,200000,10000,1000000,null,'');
INSERT into client_transaction values(NULL,20011,'Opening Balance',1,CURDATE(),200000,0,200000,null);		

CREATE Table product(
	product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(product_id),
	product_name VARCHAR(100) NOT NULL,
	opening_balance VARCHAR(100) NOT NULL,
	cost_price VARCHAR(100) NOT NULL,
	product_category INT,
	user_id INT UNSIGNED,
	FOREIGN KEY (user_id) REFERENCES user(user_id),
	create_action_id INT UNSIGNED,
	close_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id)
);

alter table product AUTO_INCREMENT=30000;
alter table product add market_price VARCHAR(100);
alter table product add dealer_price VARCHAR(100);

CREATE TABLE price(
	price_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(price_id),
	product_id INT UNSIGNED NOT NULL,
	price_type INT UNSIGNED NOT NULL,
	price decimal(8,2),
	close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
); 
alter table price AUTO_INCREMENT=40000;

CREATE TABLE price_type(
	price_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(price_type_id),
	price_type VARCHAR(100)
);

INSERT INTO price_type values(null,"COST PRICE");
INSERT INTO price_type values(null,"SELLING PRICE");
INSERT INTO price_type values(null,"MARKET RETAIL PRICE");
INSERT INTO price_type values(null,"DEALER LIST PRICE");

commit;

CREATE TABLE product_stock(
	stock_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (stock_id),
	product_id INT UNSIGNED NOT NULL,
	detail VARCHAR(100),
	transaction_type_id INT UNSIGNED NOT NULL,
	transaction_date datetime NOT NULL,
	in_value decimal(8,2),
	out_value decimal(8,2),
	balance decimal(8,2),
	invoice_id INT UNSIGNED,
	foreign key (transaction_type_id) references transaction_type(transaction_type_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);
alter table product_stock AUTO_INCREMENT=50000;	
commit;

CREATE TABLE transaction_type(
	transaction_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (transaction_type_id),
	transaction_type VARCHAR(100) NOT NULL
);

CREATE TABLE client_transaction(
	transaction_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (transaction_id),
	client_id INT UNSIGNED NOT NULL,
	transaction_details VARCHAR(100) NOT NULL,
	transaction_type_id INT UNSIGNED NOT NULL,
	transaction_date datetime NOT NULL,
	debit_value decimal(8,2),
	credit_value decimal(8,2),
	balance decimal(8,2),
	invoice_id INT UNSIGNED,
	foreign key (transaction_type_id) references transaction_type(transaction_type_id),
	FOREIGN KEY (client_id) REFERENCES client(client_id)
);

alter table client_transaction AUTO_INCREMENT=60000;	
commit;

CREATE TABLE transaction_reference_type(
	reference_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (reference_type_id),
	reference_type VARCHAR(50) NOT NULL
);

INSERT into transaction_reference_type value(null,'INVOICE');
INSERT into transaction_reference_type value(null,'PAYMENT');
INSERT into transaction_reference_type value(null,'EXPENSE');

ALTER TABLE client_transaction
Change invoice_id reference_id INT UNSIGNED;

ALTER TABLE client_transaction
ADD reference_type_id INT UNSIGNED;

INSERT into transaction_type values(NULL,'DEBIT');
INSERT into transaction_type values(NULL,'CREDIT');

CREATE TABLE invoice_type(
	invoice_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(invoice_type_id),	
	invoice_type VARCHAR(100) NOT NULL
);

INSERT into invoice_type values(NULL,'PURCHASE');
INSERT into invoice_type values(NULL,'RETAIL');
INSERT into invoice_type values(NULL,'TAX');

CREATE TABLE invoice(
	invoice_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(invoice_id),
	client_id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED NOT NULL,
	client_tin VARCHAR(100),
	invoice_date datetime NOT NULL,
	invoice_number VARCHAR(100),
	invoice_type_id INT UNSIGNED NOT NULL,
	reference	VARCHAR(100),
	shipped_method VARCHAR(100),
	shipped_to VARCHAR(100),
	sub_total decimal(10,2),
	vat_total decimal(10,2),
	total decimal(10,2),
	foreign key (client_id) references client(client_id),
	foreign key (user_id) references user(user_id),
	foreign key (invoice_type_id) references invoice_type(invoice_type_id)
);

alter table invoice add (paid VARCHAR(5));
alter table invoice add (outstanding_amt decimal(10,2));


CREATE TABLE invoice_item(
	invoice_item_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(invoice_item_id),
	invoice_id INT UNSIGNED NOT NULL,
	product_id INT UNSIGNED NOT NULL,
	quantity INT UNSIGNED NOT NULL,
	price_without_vat decimal(10,2),
	vat_percent decimal(5,2),
	price_with_vate decimal(10,2),
	total decimal(10,2),
	foreign key (invoice_id) references invoice(invoice_id),
	foreign key (product_id) references product(product_id)
	
);

ALTER TABLE invoice_item
Change price_with_vate price_with_vat INT UNSIGNED;

CREATE TABLE payment(
	payment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(payment_id),
	client_id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED NOT NULL,
	amount_paid decimal(10,2),
	payment_date datetime NOT NULL,
	mop_id INT UNSIGNED NOT NULL,
	cash_details VARCHAR(100),
	bank_id INT UNSIGNED NOT NULL,
	cheque_number VARCHAR(100),
	foreign key (client_id) references client(client_id),
	foreign key (user_id) references user(user_id)
	
);

alter table payment AUTO_INCREMENT=70000;

CREATE TABLE paid_invoice(
	payment_id INT UNSIGNED NOT NULL,
	invoice_id INT UNSIGNED NOT NULL,
	foreign key (payment_id) references payment(payment_id),
	foreign key (invoice_id) references invoice(invoice_id)
	
);

alter table paid_invoice ADD (amount DECIMAL(10,2));

CREATE TABLE category(
	category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(category_id),
	category VARCHAR(100),
	user_id INT UNSIGNED NOT NULL,
	foreign key (user_id) references user(user_id),
	close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id)	
);

CREATE TABLE client_category(
	category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(category_id),
	category VARCHAR(100)
);

INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Sundry Debtor');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Sundry Creditor');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'CASH');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Bank');


CREATE TABLE INVOICE_NUMBER(
	invoice_number_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(invoice_number_id),
	invoice_type_id INT UNSIGNED NOT NULL,
	latest_invoice_date datetime NOT NULL,
	latest_invoice_number INT UNSIGNED,
	user_id INT UNSIGNED NOT NULL,
	FOREIGN KEY (invoice_type_id) REFERENCES invoice_type(invoice_type_id),
	FOREIGN KEY (user_id) REFERENCES user(user_id)
);


CREATE TABLE INVOICE_NUMBER_AUDIT(
	invoice_number_audit_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(invoice_number_audit_id),
	invoice_number_id INT UNSIGNED,
	invoice_type_id INT UNSIGNED NOT NULL,
	invoice_date datetime NOT NULL,
	invoice_number INT UNSIGNED,
	user_id INT UNSIGNED NOT NULL,
	FOREIGN KEY (invoice_number_id) REFERENCES invoice_number(invoice_number_id),
	FOREIGN KEY (invoice_type_id) REFERENCES invoice_type(invoice_type_id),
	FOREIGN KEY (user_id) REFERENCES user(user_id),
	close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id)	
);

##Create this entry on registration of the user.
INSERT INTO invoice_number values(null,2,'2000-01-01',0,10000);
INSERT INTO invoice_number values(null,3,'2000-01-01',0,10000);
INSERT INTO invoice_number_audit values(null,1,2,'2000-01-01',0,10000,null,1000000);
INSERT INTO invoice_number_audit values(null,2,3,'2000-01-01',0,10000,null,1000000);


CREATE TABLE MODE_OF_PAYMENT(
	mop_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(mop_id),
	mop VARCHAR(100)
);

INSERT INTO MODE_OF_PAYMENT values(null,'Cash');
INSERT INTO MODE_OF_PAYMENT values(null,'Cheque');

alter table invoice add (close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id));

CREATE TABLE EXPENSE_CATEGORY(
	category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(category_id),
	category VARCHAR(100)
);


INSERT INTO EXPENSE_CATEGORY VALUES(null,'Rent and Salaries');
INSERT INTO EXPENSE_CATEGORY VALUES(null,'General & Admin');
INSERT INTO EXPENSE_CATEGORY VALUES(null,'Financial Expenses');

CREATE TABLE EXPENSE(
	expense_id INT UNSIGNED NOT NULL auto_increment,
	PRIMARY KEY(expense_id),
	expense_category_id INT UNSIGNED,
	FOREIGN KEY(expense_category_id) REFERENCES expense_category(category_id),
	description VARCHAR(100),
	amount decimal(10,2),
	mop_id INT UNSIGNED,
	FOREIGN KEY(mop_id) REFERENCES mode_of_payment(mop_id),
	bank_id INT UNSIGNED,
	chequeNumber VARCHAR(100),
	expense_date datetime NOT NULL,
	user_id INT UNSIGNED,
	FOREIGN KEY(user_id) REFERENCES user(user_id),
	close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id)
);

alter table expense AUTO_INCREMENT=80000;

ALTER TABLE payment
ADD (billWise VARCHAR(5),close_action_id INT UNSIGNED,
	create_action_id INT UNSIGNED,
	FOREIGN KEY (close_action_id) REFERENCES action_history(action_id),
	FOREIGN KEY (create_action_id) REFERENCES action_history(action_id) );