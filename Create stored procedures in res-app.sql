Restaurant Application in mysql
CREATE PROCEDURE : 
1) Checking the food and quantity for the day.
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminCheckFood`()
BEGIN
            SELECT food_type.`foodCategory`,food_name_type.`foodName`,SUM(food_name_type.`quantity`) FROM food_type 
            JOIN food_name_type ON food_name_type.`foodCategoryid`=food_type.`id`  GROUP BY food_name_type.`foodName` order by food_name_type.`foodCategoryid` ; 
            
    END */$$
DELIMITER ;

2) Cancelling the order 
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
               SET foodidvalue= (SELECT food_name_type.`id` FROM food_name_type join food_type on `food_name_type`.`foodCategoryid`=food_type.`id`  WHERE food_name_type.`foodName`=_next and curtime() between food_type.`fromTime` and food_type.`toTime`);
                   
          
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






3) Checking the orders for the particular day

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckDateTrans`()
BEGIN
        
        select * from trans_restaurant where trans_restaurant.`timeoforder` > curdate();      
        
    END */$$
DELIMITER ;













4) Procedure to order food.	

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `toinsert`(in _food mediumtext,in _quan mediumtext,in orderidpara int,in seatnopara int)
nameproc:
BEGIN
    
    #Declaration of variables required to split a series of values separated by commos and variables required for category and id of food.
          DECLARE _next TEXT DEFAULT NULL ;
          DECLARE _nextitem TEXT DEFAULT NULL ;
          declare _q text default null;
          declare _qnext int default null;
          DECLARE _nextlen INT DEFAULT NULL;
          DECLARE _nextlen1 INT DEFAULT NULL;
          DECLARE _value TEXT DEFAULT NULL;
          declare _val text default null;
          declare foodidvalueoffood int;
          DECLARE timenow TIME;
          DECLARE foodCategories int;
         # declare foodfood int;
         declare temp int;
         
       
         
  #Initializing time to current time.
          SET timenow=TIME(NOW());
       
            
              
            set temp = (length(_food)-length(replace(_food,',',''))) + 1;
       
  
  
  
  if (temp <= 5) then  
      
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
                 
                if ((select food_name_type.`quantity` from `food_name_type` where `food_name_type`.`quantity` and `food_name_type`.`foodName`=_next) > _q) then
  #Splitting the _food & _quan for every food and quantity entered in the procedure.            
                 SET _next = SUBSTRING_INDEX(_food,',',1);
                 SET _q=SUBSTRING_INDEX(_quan,',',1);
   
  #Selecting the foodid and foodcategory into two variables declared above.              
      SELECT food_name_type.`foodCategoryid` into foodCategories FROM food_name_type JOIN food_type ON `food_name_type`.`foodCategoryid` = food_type.`id` WHERE food_name_type.`foodName`= _next AND CURTIME() BETWEEN food_type.`fromTime` AND food_type.`toTime`;
               
  #Checking if the foodname exists in the food list.      
          IF EXISTS(SELECT food_name_type.`foodName` FROM food_name_type WHERE food_name_type.`foodName`=_next) THEN  
  #Checking if the time of service is between the food categories.   
              IF timenow BETWEEN (SELECT TIME(fromTime) FROM food_type WHERE food_type.`id`=foodCategories) AND (SELECT TIME(toTime) FROM food_type WHERE food_type.`id`=foodCategories) THEN
       SELECT food_name_type.`id` INTO foodidvalueoffood FROM food_name_type join food_type on food_name_type.`foodCategoryid` = food_type.`id` WHERE food_name_type.`foodName`=_next and curtime() between food_type.`fromTime` and food_type.`toTime`;
                                    
                                    
                 
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
                                      SELECT "Quantity for the food is not available";
 
                   END IF;   
                   
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
                 
                 
             END LOOP;
             
  #Print order cannot be done for the same orderNo           
               ELSE
                                      SELECT "Same order number cannot be done";
 
               END IF; 
               else
               select "You can order only 5 items in one order";
               end if;
               
  #Checking if the count of food in one order is > 5 distinct items.           
              
            
    END */$$
DELIMITER ;
