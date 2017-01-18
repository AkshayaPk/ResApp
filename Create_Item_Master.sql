ITEM MASTER :

DROP TABLE IF EXISTS `item_master`;

CREATE TABLE `item_master` (
  `ID` int(11) NOT NULL,
  `ITEM_NAME` varchar(100) NOT NULL,
  `ITEM_CATEGORY_CODE` int(11) NOT NULL,
  `ITEM_OPENING_STOCK` int(11) NOT NULL,
  `ITEM_STOCK_ON_HAND` int(11) NOT NULL,
  `ITEM_CLOSING_STOCK` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_category` (`ITEM_CATEGORY_CODE`),
  CONSTRAINT `fk_category` FOREIGN KEY (`ITEM_CATEGORY_CODE`) REFERENCES `category_master` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `item_master` */

insert  into `item_master`(`ID`,`ITEM_NAME`,`ITEM_CATEGORY_CODE`,`ITEM_OPENING_STOCK`,`ITEM_STOCK_ON_HAND`,`ITEM_CLOSING_STOCK`) values (1,'Idly',1,100,100,100),(2,'Dosa',1,100,100,100),(3,'Poori',1,100,100,100),(4,'Pongal',1,100,100,100),(5,'Vada',1,100,100,100),(6,'Sambar Vada',1,100,100,100),(7,'Coffee',1,100,95,100),(8,'Tea',1,100,100,100),(9,'North Indian Thali',2,75,75,75),(10,'South Indian Meals',2,75,75,75),(11,'Variety Rice',2,75,75,75),(12,'Tea',3,200,200,200),(13,'Coffee',3,200,200,200),(14,'Snacks',3,200,200,200),(15,'Chappathi',4,100,100,100),(16,'Sambar Rice',4,100,100,100);