DELIMITER $$

USE `restaurant`$$

DROP PROCEDURE IF EXISTS `PR_DISPLAY_MENU`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_DISPLAY_MENU`()
BEGIN
        SELECT `food_name_type`.`foodName`,`food_name_type`.`foodCategoryid`,`food_name_type`.`priceOfFood` FROM `food_name_type`;
    END$$

DELIMITER ;
