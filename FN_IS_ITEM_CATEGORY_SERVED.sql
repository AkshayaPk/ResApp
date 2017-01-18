DROP FUNCTION IF EXISTS `FN_IS_ITEM_CATEGORY_SERVED` */;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_IS_ITEM_CATEGORY_SERVED`(foodname varchar(100)) RETURNS varchar(50) CHARSET utf8
BEGIN
    declare foodcategory int;
         SELECT `ITEM_MASTER`.`ITEM_CATEGORY_CODE` INTO foodCategory FROM `ITEM_MASTER` JOIN `CATEGORY_MASTER` ON `ITEM_MASTER`.`ITEM_CATEGORY_CODE` = `CATEGORY_MASTER`.`ID` WHERE `ITEM_MASTER`.`ITEM_NAME`= foodname;
         if (curtime() between (SELECT `CATEGORY_MASTER`.`START_TIME` FROM `CATEGORY_MASTER` WHERE `CATEGORY_MASTER`.`ID`=foodCategory) and (SELECT `CATEGORY_MASTER`.`END_TIME` FROM `CATEGORY_MASTER` WHERE `CATEGORY_MASTER`.`ID`=foodCategory)) then
         return "we serve this item now";
         else
         return "we do not serve this item now";
         end if;
    END */$$
DELIMITER ;