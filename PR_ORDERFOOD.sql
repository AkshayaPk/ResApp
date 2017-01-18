DROP PROCEDURE IF EXISTS  `PR_ORDERFOOD` */;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_ORDERFOOD`(IN _food MEDIUMTEXT,IN _quan MEDIUMTEXT,IN i_orderid INT,IN i_seatno INT)
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
  
              
 SELECT `FN_CHECK_NUMBER_ITEMS`(_food) INTO @CheckItemVar;
    IF (@CheckItemVar = TRUE) THEN   
 SELECT FN_CHECK_ORDERNO(i_orderid) INTO @Message;           
         IF (@Message = TRUE) THEN
         
    insert into `ORDER_TRANSACTION` (ORDER_NO,ORDER_DATE,ORDER_TIME,ORDER_SEAT_NO) values (i_orderid,CURDATE(),CURTIME(),i_seatno);         
         
 iterator :
         LOOP    
            IF LENGTH(TRIM(_food)) = 0 OR _food IS NULL THEN
              LEAVE iterator;
              END IF;
              
 
   SELECT FN_CHECK_SEAT_AVAILABILITY(i_seatno) INTO @SeatVar;
   IF (@SeatVar = TRUE) THEN                 
               
                 SET _next = SUBSTRING_INDEX(_food,',',1);
                 SET _q=SUBSTRING_INDEX(_quan,',',1);
   
      
      SELECT `ITEM_MASTER`.`ID` INTO foodidvalueoffood FROM `ITEM_MASTER` JOIN `CATEGORY_MASTER` ON `ITEM_MASTER`.`ITEM_CATEGORY_CODE` = `CATEGORY_MASTER`.`ID` WHERE `ITEM_MASTER`.`ITEM_NAME`=_next AND CURTIME() BETWEEN `CATEGORY_MASTER`.`START_TIME` AND `CATEGORY_MASTER`.`END_TIME`;
      SELECT `ITEM_MASTER`.`ITEM_CATEGORY_CODE` INTO foodCategories FROM `ITEM_MASTER` JOIN `CATEGORY_MASTER` ON `ITEM_MASTER`.`ITEM_CATEGORY_CODE` = `CATEGORY_MASTER`.`ID` WHERE `ITEM_MASTER`.`ITEM_NAME`= _next AND CURTIME() BETWEEN `CATEGORY_MASTER`.`START_TIME` AND `CATEGORY_MASTER`.`END_TIME`;
      SELECT `ITEM_PRICE`.`PRICE` INTO price FROM `ITEM_PRICE`  WHERE `ITEM_PRICE`.`ITEM_NAME`=_next ;         
      SET totalprice = ( price * _q ) ; 
     
 
  IF ((SELECT `ITEM_MASTER`.`ITEM_STOCK_ON_HAND` FROM `ITEM_MASTER` join `CATEGORY_MASTER` on `ITEM_MASTER`.`ITEM_CATEGORY_CODE`=`CATEGORY_MASTER`.`ID` WHERE `ITEM_MASTER`.`ITEM_NAME`=_next and curtime() between `CATEGORY_MASTER`.`START_TIME` and `CATEGORY_MASTER`.`END_TIME`) > _q) THEN
  IF timenow BETWEEN (SELECT `CATEGORY_MASTER`.`START_TIME` FROM `CATEGORY_MASTER` WHERE `CATEGORY_MASTER`.`ID`=foodCategories) AND (SELECT `CATEGORY_MASTER`.`END_TIME` FROM `CATEGORY_MASTER` WHERE `CATEGORY_MASTER`.`ID`=foodCategories) THEN  
                                    
                  START TRANSACTION;
                  SET autocommit=0;
                  
                  UPDATE `SEAT_MASTER` SET `SEAT_MASTER`.`SEAT_STATUS`="Seat Occupied" WHERE `SEAT_MASTER`.`SEAT_NO`=i_seatno;
                  UPDATE `ITEM_MASTER` SET `ITEM_MASTER`.`ITEM_STOCK_ON_HAND`=`ITEM_MASTER`.`ITEM_STOCK_ON_HAND`- _q WHERE `ITEM_MASTER`.`ID`=foodidvalueoffood;
                  
                  
                  insert into `ORDER_ITEM_TRANSACTION` (ORDER_NO,ITEM_ID,ORDER_QTY,ORDER_ITEM_PRICE,PAYMENT_STATUS) values (i_orderid,foodidvalueoffood,CAST(_q AS UNSIGNED),totalprice,'PENDING');
                  select "order accepted";
                  UPDATE SEAT_MASTER SET `SEAT_MASTER`.`SEAT_STATUS`="Not Occupied" WHERE `SEAT_MASTER`.`SEAT_NO`=i_seatno;
                  
                  COMMIT;
                   
             
                  ELSE
                                      Select  "Select food from proper category";
                                      
                                     
                                      
                   END IF;  
                   
                                 
                   ELSE
                                     Select "quantity not available";
 
                   END IF; 
          
                    
                    
                   
                   ELSE
                                       Select "Seat already occupied";
 
                   END IF;                   
                   
                
                 SET _nextlen = LENGTH(_next);
                 SET _qnext = LENGTH(_q);
                 SET _value = TRIM(_next);
                 SET _val= TRIM(_q);
                 SET _food = INSERT(_food,1,_nextlen + 1,'');
                 SET _quan = INSERT(_quan,1,_qnext + 1,'');
                 
                 
   END LOOP;
            ELSE
                  Select "OrderNo already exists";
                 
            END IF;         
               
               ELSE
                Select "Can order only 5 items in one order";
               END IF;     
              
            
    END */$$
DELIMITER ;