﻿/* Function  structure for function  `FN_CHECK_ITEM_IN_LIST` */

 DROP FUNCTION IF EXISTS `FN_CHECK_ITEM_IN_LIST` */;
DELIMITER $$

 CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_ITEM_IN_LIST`(_food mediumtext) RETURNS tinyint(4)
BEGIN
              DECLARE _next TEXT DEFAULT NULL ;
              DECLARE _nextlen INT DEFAULT NULL;
              DECLARE _value TEXT DEFAULT NULL;
         iteratorfood :
         LOOP    
            IF LENGTH(TRIM(_food)) = 0 OR _food IS NULL THEN
              LEAVE iteratorfood;
              END IF;
           SET _next = SUBSTRING_INDEX(_food,',',1);   
           IF EXISTS(SELECT food_name_type.`foodName` FROM food_name_type WHERE food_name_type.`foodName`=_next) THEN
           return true;
           SET _nextlen = LENGTH(_next);
           SET _value = TRIM(_next);
           SET _food = INSERT(_food,1,_nextlen + 1,'');
           else
           return false;
           end if;
           end loop; 
    END */$$
DELIMITER ;

/* Function  structure for function  `FN_CHECK_ITEM_LIST` */

 DROP FUNCTION IF EXISTS `FN_CHECK_ITEM_LIST` */;
DELIMITER $$

 CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_ITEM_LIST`(foodlist mediumtext) RETURNS tinyint(4)
BEGIN
           DECLARE temp INT;
           SET temp = (LENGTH(foodlist)-LENGTH(REPLACE(foodlist,',',''))) + 1; 
           IF (temp <= 5) THEN 
           return true;
           else
           return false;
           end if;
    END */$$
DELIMITER ;

/* Function  structure for function  `FN_CHECK_ORDERNO` */

 DROP FUNCTION IF EXISTS `FN_CHECK_ORDERNO` */;
DELIMITER $$

 CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_ORDERNO`(orderidpara int) RETURNS tinyint(4)
BEGIN
             IF NOT EXISTS(SELECT trans_restaurant.`orderNo` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidpara) THEN 
             return true;
             else
             return false;
             end if;
    END */$$
DELIMITER ;

/* Function  structure for function  `FN_CHECK_SEAT_AVAILABILITY` */
 FUNCTION IF EXISTS `FN_CHECK_SEAT_AVAILABILITY` */;
DELIMITER $$

 CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CHECK_SEAT_AVAILABILITY`(seatnopara int) RETURNS tinyint(4)
BEGIN
           IF (SELECT restaurant_seats.`status` FROM restaurant_seats WHERE restaurant_seats.`seatNo`=seatnopara) = "Not Occupied" THEN
           return true;
           else
           return false;
           end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `CheckDateTrans` */

 DROP PROCEDURE IF EXISTS  `CheckDateTrans` */;

DELIMITER $$