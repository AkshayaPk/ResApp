DROP TABLE IF EXISTS `seat_master`;

CREATE TABLE `seat_master` (
  `ID` int(11) NOT NULL,
  `SEAT_NO` int(11) NOT NULL,
  `SEAT_STATUS` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `seat_master` */

insert  into `seat_master`(`ID`,`SEAT_NO`,`SEAT_STATUS`) values (1,1,'Not Occupied'),(2,2,'Not Occupied'),(3,3,'Not Occupied'),(4,4,'Not Occupied'),(5,5,'Not Occupied'),(6,6,'Not Occupied'),(7,7,'Not Occupied'),(8,8,'Not Occupied'),(9,9,'Not Occupied'),(10,10,'Not Occupied');