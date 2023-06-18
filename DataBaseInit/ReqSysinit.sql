-- 어린이 아이디 
CREATE TABLE `child` (
  `chd_id` int NOT NULL ,
  `child_name` varchar(20) NOT NULL ,
  `child_birthday` varchar(10) NOT NULL ,
  `user_id` int(15) NOT NULL ,
  `crt_date` timestamp NOT NULL ,
  `chg_date` timestamp NOT NULL ,

  PRIMARY KEY (
     `chd_id`
  )
);

-- 학부모 아이디
CREATE TABLE `user` (
  `user_id` varchar(15) NOT NULL ,
  `user_password` varchar(20) NOT NULL , 
  `user_name` varchar(15) NOT NULL ,
  `user_brithday` varchar(10) NOT NULL ,
  `user_postal_code` int NOT NULL ,
  `user_address` varchar(50) NOT NULL ,
  `crt_date` timestamp NOT NULL ,
  `chg_date` timestamp NOT NULL ,

  PRIMARY KEY (
     `user_id`
  )
);

-- 어린이집 입소 시스템 
CREATE TABLE `nursery` (
  `nursery_id` varchar(15) NOT NULL ,
  `nursery_password` varchar(20) NOT NULL ,
  `nursery_name` varchar(20) NOT NULL , 
  `nursery_tel` varchar(15) NOT NULL ,
  `postal_code` int NOT NULL ,
  `address` varchar(50) NOT NULL ,
  `email` varchar(50) NOT NULL ,
  `capacity` int NOT NULL ,
  `crt_date` timestamp NOT NULL ,
  `chg_date` timestamp NOT NULL ,

  PRIMARY KEY (
     `nursery_id`
  )
);

-- 어린이 아이디 등록
INSERT INTO child (chd_id, child_name, child_birthday, user_id, crt_date, chg_date)
VALUES (1, '어피치', '2020-01-01', 1, now(), now());

-- 학부모 아이디
INSERT INTO user (user_id, user_password, user_name, user_brithday, user_postal_code, user_address, crt_date, chg_date)
VALUES ('user01', 'password02', '아마존', '1980-06-06', 11111, '서울시 관악구 신림동', now(), now());

-- 어린이집 입소 시스템
INSERT INTO nursery (nursery_id, nursery_password, nursery_name, nursery_tel, postal_code, address, email, capacity, crt_date, chg_date)
VALUES ('nursery001', 'password001', '가나다 어린이집', '010-1234-5678', 12345, '부산시 해운대구 반여동', 'admin@ganada.com', 50, now(), now());
