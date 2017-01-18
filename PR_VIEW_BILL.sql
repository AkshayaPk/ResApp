 DROP PROCEDURE IF EXISTS  `PR_VIEW_BILL` */;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_VIEW_BILL`(in i_orderno int)
BEGIN
             select sum(`ORDER_ITEM_PRICE`) from `ORDER_ITEM_TRANSACTION` where PAYMENT_STATUS= 'Pending' and ORDER_NO=i_orderno
             group by ORDER_NO ; 
              
    END */$$
DELIMITER ;