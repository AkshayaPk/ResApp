ITEM PRICE :

DROP TABLE IF EXISTS `item_price`;

CREATE TABLE `item_price` (
  `ID` int(11) NOT NULL,
  `ITEM_NAME` varchar(100) NOT NULL,
  `PRICE` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `item_price` */

insert  into `item_price`(`ID`,`ITEM_NAME`,`PRICE`) values (1,'Idly',5),(2,'Dosa',5),(3,'Poori',5),(4,'Pongal',5),(5,'Vada',5),(6,'Sambar Vada',5),(7,'Coffee',5),(8,'Tea',5),(9,'North Indian Thali',10),(10,'South Indian Meals',10),(11,'Variety rice',10),(12,'Snacks',6),(13,'Chappathi',10),(14,'Sambar Rice',10);