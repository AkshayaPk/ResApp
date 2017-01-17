DELIMITER $$

USE `restaurant`$$

DROP FUNCTION IF EXISTS `FN_GET_PRICE_OF_FOOD`$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_GET_PRICE_OF_FOOD`(foodnamepara VARCHAR(50)) RETURNS INT(11)
BEGIN
    DECLARE price INT;
         SELECT `food_name_type`.`priceOfFood` INTO price FROM `food_name_type` WHERE `food_name_type`.`foodName`=foodnamepara limit 1;
         RETURN price;
    END$$

DELIMITER ;
