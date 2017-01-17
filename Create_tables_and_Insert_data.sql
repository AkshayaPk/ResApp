DROP TABLE IF EXISTS `bill_order`;

CREATE TABLE `bill_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `orderNo` int(11) NOT NULL,
  `totalprice` int(11) NOT NULL,
  `foodId` bigint(20) NOT NULL,
  `billstatus` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_foodid` (`foodId`),
  CONSTRAINT `fk_foodid` FOREIGN KEY (`foodId`) REFERENCES `food_name_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

/*Data for the table `bill_order` */

insert  into `bill_order`(`id`,`orderNo`,`totalprice`,`foodId`,`billstatus`) values (21,1,12,9,'Cancelled Order'),(22,2,12,9,'PAID');

/*Table structure for table `food_name_type` */

DROP TABLE IF EXISTS `food_name_type`;

CREATE TABLE `food_name_type` (
  `id` bigint(20) NOT NULL,
  `foodCategoryid` bigint(20) NOT NULL,
  `quantity` int(50) NOT NULL,
  `foodName` varchar(50) NOT NULL,
  `priceOfFood` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkfoodcat` (`foodCategoryid`),
  CONSTRAINT `fkfoodcat` FOREIGN KEY (`foodCategoryid`) REFERENCES `food_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `food_name_type` */

insert  into `food_name_type`(`id`,`foodCategoryid`,`quantity`,`foodName`,`priceOfFood`) values (1,1,100,'Idly',5),(2,1,100,'Vada',5),(3,1,100,'Dosa',5),(4,1,100,'Poori',5),(5,1,100,'Pongal',5),(6,1,100,'Coffee',5),(7,1,100,'Tea',5),(8,2,75,'South Indian Meals',6),(9,2,71,'North Indian Thali',6),(10,2,75,'Variety Rice ',6),(11,3,200,'Coffee',6),(12,3,200,'Tea',6),(13,3,200,'Snacks',6),(14,4,100,'Fried Rice',8),(15,4,100,'Chappathi',8),(16,4,100,'Chat Items',8),(17,1,100,'Vadacurry',5),(18,1,100,'Sambar Vada',5);

/*Table structure for table `food_type` */

DROP TABLE IF EXISTS `food_type`;

CREATE TABLE `food_type` (
  `id` bigint(20) NOT NULL,
  `foodCategory` varchar(100) NOT NULL,
  `fromTime` timestamp NULL DEFAULT NULL,
  `toTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `food_type` */

insert  into `food_type`(`id`,`foodCategory`,`fromTime`,`toTime`) values (1,'Breakfast','2016-12-25 08:00:00','2016-12-25 11:00:00'),(2,'Lunch','2016-12-25 11:15:00','2016-12-25 15:00:00'),(3,'Refreshments','2016-12-25 15:15:00','2016-12-25 23:00:00'),(4,'Dinner','2016-12-25 19:00:00','2016-12-25 23:00:00');

/*Table structure for table `restaurant_seats` */

DROP TABLE IF EXISTS `restaurant_seats`;

CREATE TABLE `restaurant_seats` (
  `id` bigint(20) NOT NULL,
  `seatNo` bigint(20) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `restaurant_seats` */

insert  into `restaurant_seats`(`id`,`seatNo`,`status`) values (1,1,'Not Occupied'),(2,2,'Not Occupied'),(3,3,'Not Occupied'),(4,4,'Not Occupied'),(5,5,'Not Occupied'),(6,6,'Not Occupied'),(7,7,'Not Occupied'),(8,8,'Not Occupied'),(9,9,'Not Occupied'),(10,10,'Not Occupied');

/*Table structure for table `seed_foodnametype` */

DROP TABLE IF EXISTS `seed_foodnametype`;

CREATE TABLE `seed_foodnametype` (
  `id` bigint(20) NOT NULL,
  `foodCategory` bigint(20) NOT NULL,
  `foodName` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fkuq` (`foodName`),
  KEY `fkfood123` (`foodCategory`),
  CONSTRAINT `fkfood123` FOREIGN KEY (`foodCategory`) REFERENCES `food_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `seed_foodnametype` */

insert  into `seed_foodnametype`(`id`,`foodCategory`,`foodName`) values (1,1,'Idly'),(2,1,'Vada'),(3,1,'Dosa'),(4,1,'Poori'),(5,1,'Pongal'),(6,1,'Breakfast Coffee'),(7,1,'Breakfast Tea'),(8,2,'South Indian Meals'),(9,2,'North Indian Thali'),(10,2,'Variety Rice'),(11,3,'Refreshment Coffee'),(12,3,'Refreshment Tea'),(13,3,'Snacks'),(14,4,'Fried Rice'),(15,4,'Chappathi'),(16,4,'Chat Items'),(17,1,'Vadacurry'),(18,1,'Sambar Vada');

/*Table structure for table `trans_restaurant` */

DROP TABLE IF EXISTS `trans_restaurant`;

CREATE TABLE `trans_restaurant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `orderNo` bigint(20) NOT NULL,
  `seatNo` bigint(20) NOT NULL,
  `foodId` bigint(20) NOT NULL,
  `quantityFood` bigint(30) NOT NULL,
  `status` varchar(100) NOT NULL,
  `timeoforder` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkseat` (`seatNo`),
  KEY `fkfoodid` (`foodId`),
  CONSTRAINT `fkfoodid` FOREIGN KEY (`foodId`) REFERENCES `food_name_type` (`id`),
  CONSTRAINT `fkseat` FOREIGN KEY (`seatNo`) REFERENCES `restaurant_seats` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `trans_restaurant` */

insert  into `trans_restaurant`(`id`,`orderNo`,`seatNo`,`foodId`,`quantityFood`,`status`,`timeoforder`) values (2,1,3,9,2,'Cancelled','2016-12-25 11:47:10'),(3,2,3,9,2,'Ordered','2016-12-25 11:53:05');
