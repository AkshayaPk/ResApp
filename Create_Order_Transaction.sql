ORDER TRANSACTION :

DROP TABLE IF EXISTS `order_transaction`;

CREATE TABLE `order_transaction` (
  `ORDER_NO` int(11) NOT NULL,
  `ORDER_DATE` date NOT NULL,
  `ORDER_TIME` time NOT NULL,
  `ORDER_SEAT_NO` int(11) NOT NULL,
  PRIMARY KEY (`ORDER_NO`),
  KEY `fk_order_seat` (`ORDER_SEAT_NO`),
  CONSTRAINT `fk_order_seat` FOREIGN KEY (`ORDER_SEAT_NO`) REFERENCES `seat_master` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;