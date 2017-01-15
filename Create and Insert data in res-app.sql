Restaurant Application in Mysql

CREATE TRIGGER :


DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `after_food_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `after_food_insert` AFTER INSERT ON `seed_foodnametype` FOR EACH ROW BEGIN 
DECLARE i INT;
DECLARE foodid INT;
DECLARE foodcat INT;
DECLARE foodn varchar(50);
DECLARE emp_cursor CURSOR FOR SELECT id,foodCategory,foodName FROM seed_foodnametype WHERE id=new.id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET i=1;
OPEN emp_cursor;
get_details:LOOP
FETCH emp_cursor INTO foodid,foodcat,foodn;
IF i=1 THEN
LEAVE get_details;
END IF;
if ((select seed_foodnametype.`foodCategory` from seed_foodnametype where id=new.id) = 1) then
INSERT INTO food_name_type (id,foodCategoryid,quantity,foodName)  VALUES(new.id,foodcat,100,foodn);
elseif ((SELECT seed_foodnametype.`foodCategory` FROM seed_foodnametype where id=new.id) = 2) then
INSERT INTO food_name_type (id,foodCategoryid,quantity,foodName)  VALUES(new.id,foodcat,75,foodn);
elseif ((SELECT seed_foodnametype.`foodCategory` FROM seed_foodnametype where id=new.id) = 3) then 
INSERT INTO food_name_type (id,foodCategoryid,quantity,foodName)  VALUES(new.id,foodcat,200,foodn);
elseif ((SELECT seed_foodnametype.`foodCategory` FROM seed_foodnametype where id=new.id) = 4) then
INSERT INTO food_name_type (id,foodCategoryid,quantity,foodName)  VALUES(new.id,foodcat,75,foodn);
end if;
END LOOP get_details;
CLOSE emp_cursor;
END */$$


DELIMITER ;











DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `food_after_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `food_after_delete` AFTER DELETE ON `seed_foodnametype` FOR EACH ROW BEGIN
  delete from food_name_type where food_name_type.`id`=old.id;
END */$$


DELIMITER ;




