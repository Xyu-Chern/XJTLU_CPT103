SET FOREIGN_KEY_CHECKS = 0;
drop table if exists staff;
drop table if exists booking;
drop table if exists guest;
drop table if exists registered_member;
drop table if exists rooms;
drop table if exists roomtypes;
drop table if exists chefdishes;
drop table if exists chefworkdays;
drop table if exists chef;
drop table if exists dishes;
drop table if exists mealdishes;
drop table if exists mealreservations;
SET FOREIGN_KEY_CHECKS = 1;

create table staff (
    id int primary key,
    password_md5 char(32) not null,
    tel int not null
);

create table guest (
    passport_id varchar(30) primary key,
    email varchar(80) unique,
	tel int not null,
	fullname varchar(255) not null,
	
	-- username and password can be empty if the user has not registered an account
	username varchar(40),
	password_md5 char(32)
);

create table roomtypes (
    roomtype varchar(50) primary key,
    description text
);

create table rooms (
    floorlvl int not null,
    roomno int not null,
    constraint roomspk primary key (floorlvl, roomno),
    
    roomtype varchar(50) not null,
    constraint fk_rooms_roomtypes foreign key (roomtype) references roomtypes (roomtype)
);

create table booking (
    id int primary key,
	
    floorlvl int, -- can be null, may not decided
    roomno int, -- same
    constraint fk_booking_room foreign key (floorlvl, roomno) references rooms (floorlvl, roomno),

    -- this is needed because room type must be provided when booking.
    -- other fields like roomno and floor can be decided when the guest arrives
    roomtype varchar(255) not null, -- must be decided when booking
	constraint fk_booking_roomtype foreign key (roomtype) references roomtypes (roomtype),

    startdate date not null,
    enddate date not null,
	
    passport_id varchar(255) not null, -- who lives in this room
    constraint fk_booking_guest foreign key (passport_id) references guest (passport_id),
    
    -- for this design, we assume that all registered users will have their passport registered
    booker_passport varchar(255), -- who booked this room
    constraint fk_booking_booker foreign key (passport_id) references guest (passport_id)
);

create table chef ( 
	chefid varchar(255) primary key,
	chef_name varchar(255)
);
create table dishes ( dishname varchar(255) primary key );

create table chefdishes (
	chefid varchar(255),
    dishname varchar(255),
    constraint cheffk foreign key (chefid) references chef (chefid),
    constraint dishfk foreign key (dishname) references dishes (dishname)
);

create table chefworkdays (
    chefid varchar(255),
    dayofweek int check (dayofweek < 7 AND dayofweek > 0), -- 1 ~ 7 can be used with mysql function dayofweek("2017-06-15")
	constraint chefwdfk foreign key (chefid) references chef (chefid)
);

create table mealreservations (
    reservationid int primary key,
    floorlvl int not null,
    roomno int not null,
    deliverytime datetime,
	constraint roomfk foreign key (floorlvl, roomno) references rooms (floorlvl, roomno)
);

create table mealdishes (
    reservationid int not null,
    dishname varchar(255) not null,
    dishquantity int not null,
    constraint reservationfk foreign key 
    	(reservationid) references mealreservations (reservationid),
    constraint dishnamefk foreign key 
    	(dishname) references dishes (dishname)
);