ORDER ITEM TRANSACTION :
DROP TABLE IF EXISTS `order_item_transaction`;

CREATE TABLE `order_item_transaction` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ORDER_NO` int(11) NOT NULL,
  `ITEM_ID` int(11) NOT NULL,
  `ORDER_QTY` int(11) NOT NULL,
  `ORDER_ITEM_PRICE` int(11) NOT NULL,
  `PAYMENT_STATUS` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_item` (`ITEM_ID`),
  KEY `fk_order` (`ORDER_NO`),
  CONSTRAINT `fk_item` FOREIGN KEY (`ITEM_ID`) REFERENCES `item_master` (`ID`),
  CONSTRAINT `fk_order` FOREIGN KEY (`ORDER_NO`) REFERENCES `order_transaction` (`ORDER_NO`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;