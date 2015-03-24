create database am00802;
use am00802;
commit;
	
##Create this entry on registration of the user.
INSERT into client values (NULL,'CASH','CASH','CASH','CASH',3,0,'CASH','CASH','CASH',0,20000,10000,1000000,null,'');
INSERT into client_transaction values(NULL,20004,'Opening Balance',1,CURDATE(),20000,0,20000,null,null);		

##Create this entry on registration of the user.
INSERT INTO invoice_number values(null,2,'2000-01-01',0,10000);
INSERT INTO invoice_number values(null,3,'2000-01-01',0,10000);
INSERT INTO invoice_number_audit values(null,1,2,'2000-01-01',0,10000,null,1000000);
INSERT INTO invoice_number_audit values(null,2,3,'2000-01-01',0,10000,null,1000000);





