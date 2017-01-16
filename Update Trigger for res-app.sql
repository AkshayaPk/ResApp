DELIMITER $$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `restaurant`.`after_food_update` AFTER UPDATE
    ON `restaurant`.`food_type`
    FOR EACH ROW BEGIN
      
      DECLARE dateVar DATE;
      SET dateVar=CURDATE();
      
      IF (dateVar + INTERVAL 1 DAY) THEN
      
      UPDATE `food_name_type` SET `food_name_type`.`quantity` = 100 WHERE `food_name_type`.`foodCategoryid`=1;
      UPDATE `food_name_type` SET `food_name_type`.`quantity` = 75 WHERE `food_name_type`.`foodCategoryid`=2;
      UPDATE `food_name_type` SET `food_name_type`.`quantity` = 200 WHERE `food_name_type`.`foodCategoryid`=3;
      UPDATE `food_name_type` SET `food_name_type`.`quantity` = 100 WHERE `food_name_type`.`foodCategoryid`=4;
      
      END IF;
      
        
        
    END$$

DELIMITER ;