FUNCTIONS :

 DROP FUNCTION IF EXISTS `FN_CHECK_ITEM_IN_LIST` */;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_ITEM_IN_LIST`(i_food MEDIUMTEXT) RETURNS tinyint(4)
BEGIN
              DECLARE _next TEXT DEFAULT NULL ;
              DECLARE _nextlen INT DEFAULT NULL;
              DECLARE _value TEXT DEFAULT NULL;
         iteratorfood :
         LOOP    
            IF LENGTH(TRIM(i_food)) = 0 OR i_food IS NULL THEN
              LEAVE iteratorfood;
              END IF;
           SET _next = SUBSTRING_INDEX(i_food,',',1);   
           IF EXISTS(SELECT `ITEM_MASTER`.`ITEM_NAME`  FROM `ITEM_MASTER` WHERE `ITEM_NAME`=_next) THEN
           RETURN TRUE;
           SET _nextlen = LENGTH(_next);
           SET _value = TRIM(_next);
           SET i_food = INSERT(i_food,1,_nextlen + 1,'');
           ELSE
           RETURN FALSE;
           END IF;
           END LOOP; 
    END */$$
DELIMITER ;