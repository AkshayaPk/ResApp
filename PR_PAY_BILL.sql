DROP PROCEDURE IF EXISTS  `PR_PAY_BILL` */;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_PAY_BILL`(in i_orderno int,out errorMsg varchar(50))
BEGIN
            update `ORDER_ITEM_TRANSACTION` set PAYMENT_STATUS="PAID" where ORDER_NO=i_orderno and `PAYMENT_STATUS`='Pending';
            select concat("You total bill is" ,(select sum(ORDER_ITEM_PRICE) from `ORDER_ITEM_TRANSACTION` where `ORDER_NO`=i_orderno and `PAYMENT_STATUS`="PAID" group by ORDER_NO));
    END */$$
DELIMITER ;