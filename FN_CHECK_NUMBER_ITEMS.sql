 DROP FUNCTION IF EXISTS `FN_CHECK_NUMBER_ITEMS` */;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_NUMBER_ITEMS`(foodlist MEDIUMTEXT) RETURNS tinyint(4)
BEGIN
DECLARE temp INT;
           SET temp = (LENGTH(foodlist)-LENGTH(REPLACE(foodlist,',',''))) + 1; 
           IF (temp <= 5) THEN 
           RETURN TRUE;
           ELSE
           RETURN FALSE;
           END IF;
    END */$$
DELIMITER ;