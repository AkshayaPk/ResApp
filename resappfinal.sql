/*
SQLyog Trial v12.2.4 (64 bit)
MySQL - 5.6.10 : Database - restaurant
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`restaurant` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `restaurant`;

/*Table structure for table `food_name_type` */

DROP TABLE IF EXISTS `food_name_type`;

CREATE TABLE `food_name_type` (
  `id` bigint(20) NOT NULL,
  `foodCategoryid` bigint(20) NOT NULL,
  `quantity` int(50) NOT NULL,
  `foodName` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkfoodcat` (`foodCategoryid`),
  CONSTRAINT `fkfoodcat` FOREIGN KEY (`foodCategoryid`) REFERENCES `food_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `food_name_type` */

insert  into `food_name_type`(`id`,`foodCategoryid`,`quantity`,`foodName`) values 
(1,1,100,'Idly'),
(2,1,93,'Vada'),
(3,1,94,'Dosa'),
(4,1,100,'Poori'),
(5,1,100,'Pongal'),
(6,1,100,'Breakfast Coffee'),
(7,1,100,'Breakfast Tea'),
(8,2,75,'South Indian Meals'),
(9,2,75,'North Indian Thali'),
(10,2,75,'Variety Rice '),
(11,3,200,'Refreshment Coffee'),
(12,3,200,'Refreshment Tea'),
(13,3,200,'Snacks'),
(14,4,100,'Fried Rice'),
(15,4,100,'Chappathi'),
(16,4,100,'Chat Items'),
(17,1,100,'Vadacurry');

/*Table structure for table `food_type` */

DROP TABLE IF EXISTS `food_type`;

CREATE TABLE `food_type` (
  `id` bigint(20) NOT NULL,
  `foodCategory` varchar(100) NOT NULL,
  `fromTime` timestamp NULL DEFAULT NULL,
  `toTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `food_type` */

insert  into `food_type`(`id`,`foodCategory`,`fromTime`,`toTime`) values 
(1,'Breakfast','2016-12-25 08:00:00','2016-12-25 11:00:00'),
(2,'Lunch','2016-12-25 11:15:00','2016-12-25 15:00:00'),
(3,'Refreshments','2016-12-25 15:15:00','2016-12-25 23:00:00'),
(4,'Dinner','2016-12-25 19:00:00','2016-12-25 23:00:00');

/*Table structure for table `restaurant_seats` */

DROP TABLE IF EXISTS `restaurant_seats`;

CREATE TABLE `restaurant_seats` (
  `id` bigint(20) NOT NULL,
  `seatNo` bigint(20) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `restaurant_seats` */

insert  into `restaurant_seats`(`id`,`seatNo`,`status`) values 
(1,1,'Not Occupied'),
(2,2,'Not Occupied'),
(3,3,'Not Occupied'),
(4,4,'Not Occupied'),
(5,5,'Not Occupied'),
(6,6,'Not Occupied'),
(7,7,'Not Occupied'),
(8,8,'Not Occupied'),
(9,9,'Not Occupied'),
(10,10,'Not Occupied');

/*Table structure for table `seed_foodnametype` */

DROP TABLE IF EXISTS `seed_foodnametype`;

CREATE TABLE `seed_foodnametype` (
  `id` bigint(20) NOT NULL,
  `foodCategory` bigint(20) NOT NULL,
  `foodName` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkfood` (`foodCategory`),
  CONSTRAINT `fkfood` FOREIGN KEY (`foodCategory`) REFERENCES `food_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `seed_foodnametype` */

insert  into `seed_foodnametype`(`id`,`foodCategory`,`foodName`) values 
(1,1,'Idly'),
(2,1,'Vada'),
(3,1,'Dosa'),
(4,1,'Poori'),
(5,1,'Pongal'),
(6,1,'Breakfast Coffee'),
(7,1,'Breakfast Tea'),
(8,2,'South Indian Meals'),
(9,2,'North Indian Thali'),
(10,2,'Variety Rice'),
(11,3,'Refreshment Coffee'),
(12,3,'Refreshment Tea'),
(13,3,'Snacks'),
(14,4,'Fried Rice'),
(15,4,'Chappathi'),
(16,4,'Chat Items'),
(17,1,'Vadacurry');

/*Table structure for table `trans_restaurant` */

DROP TABLE IF EXISTS `trans_restaurant`;

CREATE TABLE `trans_restaurant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `orderNo` bigint(20) NOT NULL,
  `seatNo` bigint(20) NOT NULL,
  `foodId` bigint(20) NOT NULL,
  `quantityFood` bigint(30) NOT NULL,
  `status` varchar(100) NOT NULL,
  `timeoforder` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkseat` (`seatNo`),
  KEY `fkfoodid` (`foodId`),
  CONSTRAINT `fkfoodid` FOREIGN KEY (`foodId`) REFERENCES `food_name_type` (`id`),
  CONSTRAINT `fkseat` FOREIGN KEY (`seatNo`) REFERENCES `restaurant_seats` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

/*Data for the table `trans_restaurant` */

insert  into `trans_restaurant`(`id`,`orderNo`,`seatNo`,`foodId`,`quantityFood`,`status`,`timeoforder`) values 
(21,4,7,2,7,'Ordered','2017-01-12 09:15:11'),
(22,4,7,3,6,'Ordered','2017-01-12 09:15:12');

/* Trigger structure for table `seed_foodnametype` */

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

/* Trigger structure for table `seed_foodnametype` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `food_after_delete` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `food_after_delete` AFTER DELETE ON `seed_foodnametype` FOR EACH ROW BEGIN
  delete from food_name_type where food_name_type.`id`=old.id;
END */$$


DELIMITER ;

/* Procedure structure for procedure `AdminCheckFood` */

/*!50003 DROP PROCEDURE IF EXISTS  `AdminCheckFood` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminCheckFood`()
BEGIN
            SELECT food_type.`foodCategory`,food_name_type.`foodName`,SUM(food_name_type.`quantity`) FROM food_type 
            JOIN food_name_type ON food_name_type.`foodCategoryid`=food_type.`id`  GROUP BY food_name_type.`foodName` order by food_name_type.`foodCategoryid` ; 
            
    END */$$
DELIMITER ;

/* Procedure structure for procedure `cancelOrder` */

/*!50003 DROP PROCEDURE IF EXISTS  `cancelOrder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelOrder`(in orderidparameter int,in foodnamepara varchar(50))
BEGIN
#Declaring the variables required for id of food and setting the id respectively.
       declare foodidvalue int;
       set foodidvalue= (SELECT food_name_type.`id` FROM food_name_type WHERE food_name_type.`foodName`=foodnamepara);
                            
          
#Checking if the orderNo exists in the transaction table.  
         if exists (select trans_restaurant.`orderNo` from trans_restaurant where trans_restaurant.`orderNo`=orderidparameter) then 
 
#Ensuring that the cancelled order is not cancelled again.                       
		if not exists(select trans_restaurant.`status` from trans_restaurant join food_name_type on trans_restaurant.`foodId`=food_name_type.`id` where trans_restaurant.`status`="Cancelled" and trans_restaurant.`orderNo`=orderidparameter and food_name_type.`foodName`=foodnamepara) then 
#updating the status in transaction table to "Cancelled" and updating the stock for the respective foodName.			
			update trans_restaurant set trans_restaurant.`status`= "Cancelled" where trans_restaurant.`orderNo`=orderidparameter and `trans_restaurant`.`foodId` = foodidvalue;
			update food_name_type set food_name_type.`quantity` = food_name_type.`quantity` + (select trans_restaurant.`quantityFood` from trans_restaurant where trans_restaurant.`orderNo`=orderidparameter and trans_restaurant.`foodId`= foodidvalue) where food_name_type.`id`=foodidvalue ;
#Printing that the order is already cancelled.			
                       ELSE
                        
                       SELECT "Order ALready Cancelled" ;
                             
                       END IF;   
#Printing that the orderid does not exist.                     
                       else
                        
                       select "order ID does not exist" ;
                       end if;         
          
    END */$$
DELIMITER ;

/* Procedure structure for procedure `cancelOrderForItems` */

/*!50003 DROP PROCEDURE IF EXISTS  `cancelOrderForItems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelOrderForItems`(IN orderidparameter INT,IN foodnamepara mediumtext)
BEGIN
#Declaring the variables required for id of food and setting the id respectively.
       DECLARE _next TEXT DEFAULT NULL ;
       DECLARE foodidvalue INT;
       DECLARE _nextlen INT DEFAULT NULL;
       DECLARE _value TEXT DEFAULT NULL;
        
        iterator :
         LOOP    
            IF LENGTH(TRIM(foodnamepara)) = 0 OR foodnamepara IS NULL THEN
              LEAVE iterator;
              END IF;  
               SET _next = SUBSTRING_INDEX(foodnamepara,',',1);
               SET foodidvalue= (SELECT food_name_type.`id` FROM food_name_type WHERE food_name_type.`foodName`=_next);
                   
          
#Checking if the orderNo exists in the transaction table.  
         IF EXISTS (SELECT trans_restaurant.`orderNo` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidparameter) THEN 
 
#Ensuring that the cancelled order is not cancelled again.                       
		IF NOT EXISTS(SELECT trans_restaurant.`status` FROM trans_restaurant JOIN food_name_type ON trans_restaurant.`foodId`=food_name_type.`id` WHERE trans_restaurant.`status`="Cancelled" AND trans_restaurant.`orderNo`=orderidparameter AND food_name_type.`foodName`=foodnamepara) THEN 
#updating the status in transaction table to "Cancelled" and updating the stock for the respective foodName.			
			UPDATE trans_restaurant SET trans_restaurant.`status`= "Cancelled" WHERE trans_restaurant.`orderNo`=orderidparameter AND `trans_restaurant`.`foodId` = foodidvalue;
			UPDATE food_name_type SET food_name_type.`quantity` = food_name_type.`quantity` + (SELECT trans_restaurant.`quantityFood` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidparameter AND trans_restaurant.`foodId`= foodidvalue) WHERE food_name_type.`id`=foodidvalue ;
#Printing that the order is already cancelled.			
                       ELSE
                        
                       SELECT "Order ALready Cancelled" ;
                             
                       END IF;   
#Printing that the orderid does not exist.                     
                       ELSE
                        
                       SELECT "order ID does not exist" ;
                       END IF;    
                       
                        SET _nextlen = LENGTH(_next);
                        SET _value = TRIM(_next);
                        SET foodnamepara = INSERT(foodnamepara,1,_nextlen + 1,'');
     
           END LOOP;
                     
          
    END */$$
DELIMITER ;

/* Procedure structure for procedure `CheckDateTrans` */

/*!50003 DROP PROCEDURE IF EXISTS  `CheckDateTrans` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckDateTrans`()
BEGIN
        
        select * from trans_restaurant where trans_restaurant.`timeoforder` > curdate();      
        
    END */$$
DELIMITER ;

/* Procedure structure for procedure `orderfood` */

/*!50003 DROP PROCEDURE IF EXISTS  `orderfood` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `orderfood`(in orderno bigint,in seatnopara bigint,in foodName varchar(100),in quantity bigint)
begin
declare foodCategories varchar(100);
declare foodid int;
declare timenow time;
declare maxlimitoforder int;
select restaurant_seats.`maxOrder` into maxlimitoforder from restaurant_seats where seatNo=seatnopara;
select seed_foodnametype.`id` into foodid from seed_foodnametype where seed_foodnametype.`foodName`=foodName;
         SELECT seed_foodNameType.`foodCategory` INTO foodCategories FROM seed_foodNameType WHERE seed_foodNameType.`foodName`=foodName;
         set timenow=TIME(NOW());
         
IF ((SELECT COUNT(foodId) FROM trans_restaurant WHERE trans_restaurant.`orderNo` = orderno) < maxlimitoforder) THEN
   if EXISTS(SELECT seed_foodNameType.`foodName` FROM seed_foodNameType WHERE seed_foodNameType.`foodName`=foodName) THEN 
       
       if timenow between (select time(fromTime) from foodType where foodType.`id`=foodCategories) and (select time(toTime) from foodType where foodType.`id`=foodCategories) then
             
			update foodType set foodType.`quantity`=foodType.`quantity` - quantity where foodType.`id`=foodCategories;
			insert into trans_restaurant (orderNo,seatNo,foodId,quantityFood,trans_restaurant.`status`) values (orderno,seatnopara,foodid,quantity,"Ordered");
			update restaurant_seats set restaurant_seats.`status`='Seat Occupied' where restaurant_seats.`seatNo`=seatnopara;
	else
		select "Select Food from proper Category" ;
	end if;
else
	select "Food not in list" ;
end if;
		ELSE
			SELECT CONCAT("No more orders can be done for seat number ", seatnopara);
		END IF;
end */$$
DELIMITER ;

/* Procedure structure for procedure `toinsert` */

/*!50003 DROP PROCEDURE IF EXISTS  `toinsert` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `toinsert`(in _food mediumtext,in _quan mediumtext,in orderidpara int,in seatnopara int)
BEGIN
    
    #Declaration of variables required to split a series of values separated by commos and variables required for category and id of food.
          DECLARE _next TEXT DEFAULT NULL ;
          declare _q text default null;
          declare _qnext int default null;
          DECLARE _nextlen INT DEFAULT NULL;
          DECLARE _value TEXT DEFAULT NULL;
          declare _val text default null;
          declare foodidvalueoffood int;
          DECLARE timenow TIME;
          DECLARE foodCategories int;
         
  #Initializing time to current time.
          SET timenow=TIME(NOW());
  #Checking if order number is already present in transaction table.
   IF NOT EXISTS(SELECT trans_restaurant.`orderNo` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidpara) THEN 
         
  #Checking if there is value passed to _food parameter of the procedure.      
         iterator :
         loop    
            IF LENGTH(TRIM(_food)) = 0 OR _food IS NULL THEN
              LEAVE iterator;
              END IF;
              
  #Checking if the seat is not occupied.
   if (select restaurant_seats.`status` from restaurant_seats where restaurant_seats.`seatNo`=seatnopara) = "Not Occupied" then
                 
                 
  #Splitting the _food & _quan for every food and quantity entered in the procedure.            
                 SET _next = SUBSTRING_INDEX(_food,',',1);
                 SET _q=SUBSTRING_INDEX(_quan,',',1);
   
  #Selecting the foodid and foodcategory into two variables declared above.              
                 select food_name_type.`id` into foodidvalueoffood from food_name_type where food_name_type.`foodName`=_next;
                 SELECT food_name_type.`foodCategoryid` INTO foodCategories FROM food_name_type WHERE food_name_type.`foodName`=_next;
               
  #Checking if the foodname exists in the food list.      
          IF EXISTS(SELECT food_name_type.`foodName` FROM food_name_type WHERE food_name_type.`foodName`=_next) THEN  
  #Checking if the time of service is between the food categories.   
              IF timenow BETWEEN (SELECT TIME(fromTime) FROM food_type WHERE food_type.`id`=foodCategories) AND (SELECT TIME(toTime) FROM food_type WHERE food_type.`id`=foodCategories) THEN
                  start transaction;
                  set autocommit=0;
                  
  #Updating the seat status to  "seat occupied" and updating the stock respectively for every food.
                  UPDATE restaurant_seats SET restaurant_seats.`status`="Seat Occupied" WHERE restaurant_seats.`seatNo`=seatnopara;
                  UPDATE food_name_type SET food_name_type.`quantity`=food_name_type.`quantity`- _q WHERE food_name_type.`id`=foodidvalueoffood;
 
  #Inserting the food details into transaction table.                   
                  INSERT INTO trans_restaurant(orderNo,seatNo,foodId,quantityFood,trans_restaurant.`status`,timeoforder) VALUES(orderidpara,seatnopara,foodidvalueoffood,CAST(_q AS UNSIGNED),"Ordered",now());
   
  #Once order completed updating the status of the seat to "Not Occupied".             
                  update restaurant_seats set restaurant_seats.`status`="Not Occupied" where restaurant_seats.`seatNo`=seatnopara;
                  commit;
                   
  #Please order food from proper category for the respective time.                
                  else
                                      SELECT "Order food from proper category";
                   end if;  
                   
  #Please order food in list.                                  
                   ELSE
                                      SELECT "Food Not in list";
 
                   END IF; 
  #Please select seat which is not occupied.            
                    
                   ELSE
                                      SELECT "Seat Already Occupied";
 
                   END IF;                   
                   
  #Calculating the length of the foodName entered as a parameter in the stored procedure and replacing the first foodName with blank spaces to read the next foodName.              
                
                 SET _nextlen = LENGTH(_next);
                 set _qnext = length(_q);
                 SET _value = TRIM(_next);
                 set _val= trim(_q);
                 SET _food = INSERT(_food,1,_nextlen + 1,'');
                 SET _quan = INSERT(_quan,1,_qnext + 1,'');
                 
                 
             end loop;
             
  #Print order cannot be done for the same orderNo           
               ELSE
                                      SELECT "Same order number cannot be done";
 
               END IF; 
               
  #Checking if the count of food in one order is > 5 distinct items.           
                IF ((SELECT COUNT(distinct(foodId)) FROM trans_restaurant WHERE trans_restaurant.`orderNo` = orderidpara) <= 5 ) THEN                 
                       select "Order Accepted" ;     
                   ELSE
                        
                        select "You can order only 5 items in one order" ;
  
  #Deleting the records from transaction table.                    
                        delete from trans_restaurant where trans_restaurant.`orderNo`=orderidpara;
                      
                   END IF;  
              
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
