######Static Data Entry########

INSERT INTO price_type values(null,'COST PRICE');
INSERT INTO price_type values(null,'SELLING PRICE');
INSERT INTO price_type values(null,'MARKET RETAIL PRICE');
INSERT INTO price_type values(null,'DEALER LIST PRICE');

INSERT into transaction_reference_type value(null,'INVOICE');
INSERT into transaction_reference_type value(null,'PAYMENT');
INSERT into transaction_reference_type value(null,'EXPENSE');
INSERT into transaction_reference_type value(null,'RECEIPT');

INSERT into transaction_type values(NULL,'DEBIT');
INSERT into transaction_type values(NULL,'CREDIT');

INSERT into invoice_type values(NULL,'PURCHASE');
INSERT into invoice_type values(NULL,'RETAIL');
INSERT into invoice_type values(NULL,'TAX');

INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Sundry Debtor');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Sundry Creditor');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'CASH');
INSERT INTO CLIENT_CATEGORY VALUES(NULL,'Bank');

INSERT INTO MODE_OF_PAYMENT values(null,'Cash');
INSERT INTO MODE_OF_PAYMENT values(null,'Cheque');

INSERT INTO EXPENSE_CATEGORY VALUES(null,'Rent and Salaries');
INSERT INTO EXPENSE_CATEGORY VALUES(null,'General & Admin');
INSERT INTO EXPENSE_CATEGORY VALUES(null,'Financial Expenses');