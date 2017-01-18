DROP PROCEDURE IF EXISTS  `PR_CANCEL_ORDER` */;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_CANCEL_ORDER`(IN i_orderid INT,IN i_foodname MEDIUMTEXT)
BEGIN
#Declaring the variables required for id of food and setting the id respectively.
       DECLARE _next TEXT DEFAULT NULL ;
       DECLARE foodidvalue INT;
       DECLARE _nextlen INT DEFAULT NULL;
       DECLARE _value TEXT DEFAULT NULL;
        
        iterator :
         LOOP    
            IF LENGTH(TRIM(i_foodname)) = 0 OR i_foodname IS NULL THEN
              LEAVE iterator;
              END IF;  
               SET _next = SUBSTRING_INDEX(i_foodname,',',1);
               SET foodidvalue= (SELECT `ITEM_MASTER`.`ID` FROM `ITEM_MASTER` JOIN `CATEGORY_MASTER` ON `ITEM_MASTER`.`ITEM_CATEGORY_CODE`=`CATEGORY_MASTER`.`ID`  WHERE `ITEM_MASTER`.`ITEM_NAME`=_next AND CURTIME() BETWEEN `CATEGORY_MASTER`.`START_TIME` AND `CATEGORY_MASTER`.`END_TIME`);
                   
          
#Checking if the orderNo exists in the transaction table.  
         IF EXISTS (SELECT `ORDER_TRANSACTION`.`ORDER_NO` FROM `ORDER_TRANSACTION` WHERE ORDER_NO=i_orderid) THEN 
 
#Ensuring that the cancelled order is not cancelled again.                       
		IF NOT EXISTS(SELECT `ORDER_ITEM_TRANSACTION`.`PAYMENT_STATUS` FROM `ORDER_ITEM_TRANSACTION` JOIN `ITEM_MASTER` ON `ORDER_ITEM_TRANSACTION`.`ITEM_ID`=`ITEM_MASTER`.`ID` WHERE `ORDER_ITEM_TRANSACTION`.`PAYMENT_STATUS`="Cancelled" AND `ORDER_ITEM_TRANSACTION`.`ORDER_NO`=i_orderid AND `ORDER_ITEM_TRANSACTION`.`ITEM_ID`=foodidvalue) THEN 
#updating the status in transaction table to "Cancelled" and updating the stock for the respective foodName.			
			UPDATE `ORDER_ITEM_TRANSACTION` SET `PAYMENT_STATUS`= "Cancelled" WHERE ORDER_NO=i_orderid AND ITEM_ID = foodidvalue;
			UPDATE `ITEM_MASTER` set  `ITEM_STOCK_ON_HAND` = `ITEM_STOCK_ON_HAND` + (SELECT `ORDER_ITEM_TRANSACTION`.`ORDER_QTY` FROM `ORDER_ITEM_TRANSACTION` WHERE ORDER_NO=i_orderid AND ITEM_ID= foodidvalue) WHERE `ITEM_MASTER`.`ID`=foodidvalue ;
			
			
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
                        SET i_foodname = INSERT(i_foodname,1,_nextlen + 1,'');
     
           END LOOP;
                     
          
    END */$$
DELIMITER ;