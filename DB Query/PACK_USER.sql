#Proc to add new user
DELIMITER //
CREATE PROCEDURE registerUser(
         IN firstName VARCHAR(100),
		 IN lastName VARCHAR(100),
		 IN email VARCHAR(100),
		 IN userPassword VARCHAR(100),
		 IN accountName VARCHAR(100),
		 IN phoneNumber VARCHAR(100),
		 IN address VARCHAR(100),
		 IN state VARCHAR(10),
		 IN country VARCHAR(10),
		 IN isValidProfilePic INT
		)
BEGIN

DECLARE userID INT DEFAULT 0;
insert into user values(NULL,firstName,lastName,email,userPassword,accountName,phoneNumber,address,state,country,NULL);
SELECT MAX(user_id) into userID from user;
if isValidProfilePic = 1 then
	Update user
	set file_name = CONCAT(userID,'.png')
	where user_id =userID;
else
	Update user
	set file_name = 'default.png'
	where user_id =userID;
end if;
SELECT file_name from user where user_id=userID;
END//
DELIMITER ;