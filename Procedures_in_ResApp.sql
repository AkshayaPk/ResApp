/* Procedure structure for procedure `PR_ADMIN_CHECK_FOOD` */

/*!50003 DROP PROCEDURE IF EXISTS  `PR_ADMIN_CHECK_FOOD` */;

DELIMITER $$

 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_ADMIN_CHECK_FOOD`()
BEGIN
            SELECT food_type.`foodCategory`,food_name_type.`foodName`,SUM(food_name_type.`quantity`) FROM food_type 
            JOIN food_name_type ON food_name_type.`foodCategoryid`=food_type.`id`  GROUP BY food_name_type.`foodName` order by food_name_type.`foodCategoryid` ; 
            
    END */$$
DELIMITER ;

/* Procedure structure for procedure `PR_CANCEL_ORDER` */

 DROP PROCEDURE IF EXISTS  `PR_CANCEL_ORDER` */;

DELIMITER $$

 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_CANCEL_ORDER`(IN orderidparameter INT,IN foodnamepara mediumtext)
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
               SET foodidvalue= (SELECT food_name_type.`id` FROM food_name_type join food_type on `food_name_type`.`foodCategoryid`=food_type.`id`  WHERE food_name_type.`foodName`=_next and curtime() between food_type.`fromTime` and food_type.`toTime`);
                   
          
#Checking if the orderNo exists in the transaction table.  
         IF EXISTS (SELECT trans_restaurant.`orderNo` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidparameter) THEN 
 
#Ensuring that the cancelled order is not cancelled again.                       
		IF NOT EXISTS(SELECT trans_restaurant.`status` FROM trans_restaurant JOIN food_name_type ON trans_restaurant.`foodId`=food_name_type.`id` WHERE trans_restaurant.`status`="Cancelled" AND trans_restaurant.`orderNo`=orderidparameter AND food_name_type.`foodName`=foodnamepara) THEN 
#updating the status in transaction table to "Cancelled" and updating the stock for the respective foodName.			
			UPDATE trans_restaurant SET trans_restaurant.`status`= "Cancelled" WHERE trans_restaurant.`orderNo`=orderidparameter AND `trans_restaurant`.`foodId` = foodidvalue;
			UPDATE food_name_type SET food_name_type.`quantity` = food_name_type.`quantity` + (SELECT trans_restaurant.`quantityFood` FROM trans_restaurant WHERE trans_restaurant.`orderNo`=orderidparameter AND trans_restaurant.`foodId`= foodidvalue) WHERE food_name_type.`id`=foodidvalue ;
			
			UPDATE bill_order SET bill_order.`billstatus`="Cancelled Order" WHERE bill_order.`orderNo`=orderidparameter AND `bill_order`.`foodId`=foodidvalue;
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

/* Procedure structure for procedure `PR_CHECK_SERVICE` */

 DROP PROCEDURE IF EXISTS  `PR_CHECK_SERVICE` */;

DELIMITER $$

 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_CHECK_SERVICE`(out errMsg varchar(50))
BEGIN
         
    if (curtime() between (select time(toTime) from `food_type` where food_type.`id`=1) and (select time(fromTime) from food_type where food_type.`id`=2)) then
      
       
       set errMsg="No service";
   elseif (CURTIME() BETWEEN (SELECT TIME(toTime) FROM `food_type` WHERE food_type.`id`=2) AND (SELECT TIME(fromTime) FROM food_type WHERE food_type.`id`=3))  then 
       
       set errMsg="No service";
       
    elseif (curtime() > (select time(toTime) from food_type where food_type.`id`=3)) then
    
       set errMsg="No service";
       
           ELSEIF (CURTIME() > (SELECT TIME(toTime) FROM food_type WHERE food_type.`id`=4)) THEN
    
       SET errMsg="No service";
     end if;         
    END */$$
DELIMITER ;

/* Procedure structure for procedure `PR_ORDERFOOD` */

 DROP PROCEDURE IF EXISTS  `PR_ORDERFOOD` */;

DELIMITER $$

 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_ORDERFOOD`(IN _food MEDIUMTEXT,IN _quan MEDIUMTEXT,IN orderidpara INT,IN seatnopara INT,out errMsg varchar(100))
nameproc:
BEGIN
    
    #Declaration of variables required to split a series of values separated by commos and variables required for category and id of food.
          DECLARE _next TEXT DEFAULT NULL ;
          
          DECLARE _q TEXT DEFAULT NULL;
          DECLARE _qnext INT DEFAULT NULL;
          DECLARE _nextlen INT DEFAULT NULL;
          
          DECLARE _value TEXT DEFAULT NULL;
          DECLARE _val TEXT DEFAULT NULL;
          DECLARE foodidvalueoffood INT;
          DECLARE timenow TIME;
          DECLARE foodCategories INT;
          DECLARE price INT;
          DECLARE totalprice INT;
  
  SET timenow=TIME(NOW());
  
              
 select `FN_CHECK_ITEM_LIST`(_food) into @CheckItemVar;
    if (@CheckItemVar = true) then   
 select FN_CHECK_ORDERNO(orderidpara) into @Message;           
         if (@Message = true) then
         
 iterator :
         LOOP    
            IF LENGTH(TRIM(_food)) = 0 OR _food IS NULL THEN
              LEAVE iterator;
              END IF;
              
 
   select FN_CHECK_SEAT_AVAILABILITY(seatnopara) into @SeatVar;
   if (@SeatVar = true) then                 
               
                 SET _next = SUBSTRING_INDEX(_food,',',1);
                 SET _q=SUBSTRING_INDEX(_quan,',',1);
   
      SELECT food_name_type.`foodCategoryid` INTO foodCategories FROM food_name_type JOIN food_type ON `food_name_type`.`foodCategoryid` = food_type.`id` WHERE food_name_type.`foodName`= _next AND CURTIME() BETWEEN food_type.`fromTime` AND food_type.`toTime`;
      SELECT `food_name_type`.`priceOfFood` INTO price FROM `food_name_type` JOIN food_type ON `food_name_type`.`foodCategoryid`=food_type.`id` WHERE `food_name_type`.`foodName`=_next AND CURTIME() BETWEEN food_type.`fromTime` AND food_type.`toTime`;         
      SET totalprice = ( price * _q ) ; 
       
 select `FN_CHECK_ITEM_IN_LIST`(_food) into @ItemVar;
 if (@ItemVar = true) then 
 
  IF ((SELECT food_name_type.`quantity` FROM `food_name_type` WHERE `food_name_type`.`quantity` AND `food_name_type`.`foodName`=_next) > _q) THEN
           
  IF timenow BETWEEN (SELECT TIME(fromTime) FROM food_type WHERE food_type.`id`=foodCategories) AND (SELECT TIME(toTime) FROM food_type WHERE food_type.`id`=foodCategories) THEN             
              
       SELECT food_name_type.`id` INTO foodidvalueoffood FROM food_name_type JOIN food_type ON food_name_type.`foodCategoryid` = food_type.`id` WHERE food_name_type.`foodName`=_next AND CURTIME() BETWEEN food_type.`fromTime` AND food_type.`toTime`;
                                    
                  START TRANSACTION;
                  SET autocommit=0;
                  
                  UPDATE restaurant_seats SET restaurant_seats.`status`="Seat Occupied" WHERE restaurant_seats.`seatNo`=seatnopara;
                  UPDATE food_name_type SET food_name_type.`quantity`=food_name_type.`quantity`- _q WHERE food_name_type.`id`=foodidvalueoffood;
                  
                  INSERT INTO trans_restaurant(orderNo,seatNo,foodId,quantityFood,trans_restaurant.`status`,timeoforder) VALUES(orderidpara,seatnopara,foodidvalueoffood,CAST(_q AS UNSIGNED),"Ordered",NOW());
                  INSERT INTO bill_order(orderNo,bill_order.`totalprice`,bill_order.`foodId`,bill_order.`billstatus`) VALUES (orderidpara,totalprice,foodidvalueoffood,'Pending');
               
                  UPDATE restaurant_seats SET restaurant_seats.`status`="Not Occupied" WHERE restaurant_seats.`seatNo`=seatnopara;
                  
                  COMMIT;
                   
             
                  ELSE
                                      set errMsg= "Select Food from proper category";
                   END IF;  
                   
                                 
                   ELSE
                                     SET errMsg= "Quantity for the food is not available";
 
                   END IF; 
          
                    
                   ELSE
                                       SET errMsg= "Food not in list";
 
                   END IF;   
                   
                   ELSE
                                       SET errMsg= "Seat already occupied";
 
                   END IF;                   
                   
                
                 SET _nextlen = LENGTH(_next);
                 SET _qnext = LENGTH(_q);
                 SET _value = TRIM(_next);
                 SET _val= TRIM(_q);
                 SET _food = INSERT(_food,1,_nextlen + 1,'');
                 SET _quan = INSERT(_quan,1,_qnext + 1,'');
                 
                 
   END LOOP;
            else
                  SET errMsg= "OrderNo already exists";
                 
            end if;         
               
               ELSE
                SET errMsg= "Can order only 5 items in one order";
               END IF;     
              
            
    END */$$
DELIMITER ;

/* Procedure structure for procedure `PR_PAY_BILL` */

 DROP PROCEDURE IF EXISTS  `PR_PAY_BILL` */;

DELIMITER $$
 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_PAY_BILL`(in ordernopara int,out errorMsg varchar(50))
BEGIN
    
 UPDATE `bill_order` SET `bill_order`.`billstatus`="PAID" WHERE `bill_order`.`orderNo`=ordernopara AND `bill_order`.`billstatus`='Pending';
            SELECT CONCAT("You total bill is" ,(SELECT SUM(`bill_order`.`totalprice`) FROM `bill_order` WHERE `bill_order`.`orderNo`=ordernopara AND `bill_order`.`billstatus`="PAID" GROUP BY `bill_order`.`orderNo`));
    END */$$
DELIMITER ;

/* Procedure structure for procedure `PR_VIEW_BILL` */

/*!50003 DROP PROCEDURE IF EXISTS  `PR_VIEW_BILL` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_VIEW_BILL`(in i_ordernopara int)
BEGIN
             select `bill_order`.`orderNo` , sum(bill_order.`totalprice`) from bill_order where bill_order.`statusorder`= 'Delivered' and `bill_order`.`orderNo`=i_ordernopara
             group by bill_order.`orderNo` ; 
              
    END */$$
DELIMITER ;
