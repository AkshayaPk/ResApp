RESAPP TABLES : 

CATEGORY MASTER TABLE : 

DROP TABLE IF EXISTS `category_master`;

CREATE TABLE `category_master` (
  `ID` int(11) NOT NULL,
  `CATEGORY_DESCRIPTION` varchar(100) NOT NULL,
  `START_TIME` time NOT NULL,
  `END_TIME` time NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `category_master` */

insert  into `category_master`(`ID`,`CATEGORY_DESCRIPTION`,`START_TIME`,`END_TIME`) values (1,'BREAKFAST','08:00:00','11:00:00'),(2,'LUNCH','11:15:00','15:00:00'),(3,'REFRESHMENTS','15:15:00','23:00:00'),(4,'DINNER','19:00:00','23:00:00');