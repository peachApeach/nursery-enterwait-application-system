-- 어린이집 테이블
CREATE TABLE `nursery` (
    `nursery_id` varchar(15) ,
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

-- 어린이집 입소 아동 테이블
CREATE TABLE `nur_child` (
    `nur_chd_id` int  NOT NULL ,
    `nursery_id` varchar(15)  NOT NULL ,
    `child_name` varchar(20)  NOT NULL ,
    `child_birthday` varchar(10)  NOT NULL ,
    `parent_name` int  NOT NULL ,
    `parent_tel` varchar(15)  NOT NULL ,
    `parent_address` varchar(50)  NOT NULL ,
    `parent_postcode` int  NOT NULL ,
    `parent_email` varchar(50)  NOT NULL ,
    `crt_date` timestamp  NOT NULL ,
    `chg_date` timestamp  NOT NULL ,

    PRIMARY KEY (
        `nur_chd_id`
    )
);

-- ALTER TABLE `nur_child` ADD CONSTRAINT `nursery_id` FOREIGN KEY(`nursery_id`)
-- REFERENCES `nursery` (`nursery_id`);

-- 어린이집 데이터 등록
INSERT INTO nursery (nursery_id, nursery_password, nursery_name, nursery_tel, postal_code, address, email, capacity, crt_date, chg_date)
VALUES (`nursery001`, `password001`, `가나다 어린이집`, `010-1234-5678`, 12345, `부산시 해운대구 반여동`, `admin@ganada.com`, 50, now(), now());

-- 어린이집 입소 아동 등록
INSERT INTO nur_child
VALUES (1,`nursery001`, `어피치`, `2020-01-01`, `라이언`, `010-0000-0000`, `서울시 관악구 신림동`, 11111, `pandayh7@gmail.com`, now(), now())
INSERT INTO nur_child
VALUES (2,`nursery001`, `죠르디`, `2020-02-02`, `앙몬드`, `010-1111-2222`, `서울시 관악구 남현동`, 22222, `pandayh7@gmail.com`, now(), now())


