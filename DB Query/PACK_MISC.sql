#Proc to generate action id for a action in application
DELIMITER //
CREATE PROCEDURE generateActionID(
         IN actionDetails VARCHAR(25),
		 OUT actionID int
         )
BEGIN
  
	INSERT INTO action_history values(NULL,actionDetails,CURDATE());
	SELECT MAX(action_id) into actionID FROM action_history;

END//
DELIMITER ;

