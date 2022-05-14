--------------------------
------ EVENT TABLES ------
--------------------------

CREATE TABLE `order_event` (
    aggregate_type TINYINT NOT NULL,
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version TEXT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_type, aggregate_id, sequence),
    KEY (aggregate_id)
);

CREATE TABLE `product_event` (
    aggregate_type TINYINT NOT NULL,
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version TEXT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_type, aggregate_id, sequence),
    KEY (aggregate_id)
);

CREATE TABLE `vendor_event` (
    aggregate_type TINYINT NOT NULL,
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version TEXT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_type, aggregate_id, sequence),
    KEY (aggregate_id)
);


DELIMITER //

CREATE FUNCTION `GET_RANDOM_ORDER_EVENT_AGGREGATE_ID`(`range_start` BIGINT UNSIGNED, `range_end` BIGINT UNSIGNED) RETURNS BIGINT(20) UNSIGNED
READS SQL DATA
BEGIN
    DECLARE rnd BIGINT UNSIGNED;
    DECLARE i BIGINT UNSIGNED;

    IF range_start is null OR range_start < 1 THEN
        SET range_start = 1000000000;
    END IF;
    IF range_end is null OR range_end < 1 THEN
        SET range_end   = 4294967295; -- 2^32 - 1
    END IF; 

    SET i = 0;

    r: REPEAT
        SET rnd = FLOOR(range_start + RAND() * (range_end - range_start));
        UNTIL NOT EXISTS( SELECT 1 FROM `order_event` WHERE aggregate_id = rnd )
    END REPEAT r;

    RETURN rnd;
END//

CREATE FUNCTION `GET_RANDOM_PRODUCT_EVENT_AGGREGATE_ID`(`range_start` BIGINT UNSIGNED, `range_end` BIGINT UNSIGNED) RETURNS BIGINT(20) UNSIGNED
READS SQL DATA
BEGIN
    DECLARE rnd BIGINT UNSIGNED;
    DECLARE i BIGINT UNSIGNED;

    IF range_start is null OR range_start < 1 THEN
        SET range_start = 1000000000;
    END IF;
    IF range_end is null OR range_end < 1 THEN
        SET range_end   = 4294967295; -- 2^32 - 1
    END IF; 

    SET i = 0;

    r: REPEAT
        SET rnd = FLOOR(range_start + RAND() * (range_end - range_start));
        UNTIL NOT EXISTS( SELECT 1 FROM `product_event` WHERE aggregate_id = rnd )
    END REPEAT r;

    RETURN rnd;
END//

CREATE FUNCTION `GET_RANDOM_VENDOR_EVENT_AGGREGATE_ID`(`range_start` BIGINT UNSIGNED, `range_end` BIGINT UNSIGNED) RETURNS BIGINT(20) UNSIGNED
READS SQL DATA
BEGIN
    DECLARE rnd BIGINT UNSIGNED;
    DECLARE i BIGINT UNSIGNED;

    IF range_start is null OR range_start < 1 THEN
        SET range_start = 1000000000;
    END IF;
    IF range_end is null OR range_end < 1 THEN
        SET range_end   = 4294967295; -- 2^32 - 1
    END IF; 

    SET i = 0;

    r: REPEAT
        SET rnd = FLOOR(range_start + RAND() * (range_end - range_start));
        UNTIL NOT EXISTS( SELECT 1 FROM `vendor_event` WHERE aggregate_id = rnd )
    END REPEAT r;

    RETURN rnd;
END//

DELIMITER ;


-----------------------------------
------ GLOBAL SEQUENCE TABLE ------
-----------------------------------

CREATE TABLE `global_sequence` (
    node_id VARCHAR(255) NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    CONSTRAINT PRIMARY KEY (node_id)
);

INSERT INTO
    `global_sequence`
VALUES
    ('1', 1);

DELIMITER //

CREATE TRIGGER `UPDATE_GLOBAL_SEQUENCE_ON_ORDER_EVENT`
BEFORE INSERT
ON `order_event` FOR EACH ROW
BEGIN
    DECLARE global_sequence BIGINT UNSIGNED;
    
    SELECT sequence INTO global_sequence FROM global_sequence WHERE node_id = '1' FOR UPDATE;
    UPDATE global_sequence SET sequence = sequence + 1 WHERE node_id = '1';

    SET NEW.metadata = JSON_SET(NEW.metadata, '$.s', CAST(global_sequence AS CHAR));
END//

CREATE TRIGGER `UPDATE_GLOBAL_SEQUENCE_ON_PRODUCT_EVENT`
BEFORE INSERT
ON `product_event` FOR EACH ROW
BEGIN
    DECLARE global_sequence BIGINT UNSIGNED;
    
    SELECT sequence INTO global_sequence FROM global_sequence WHERE node_id = '1' FOR UPDATE;
    UPDATE global_sequence SET sequence = sequence + 1 WHERE node_id = '1';

    SET NEW.metadata = JSON_SET(NEW.metadata, '$.s', CAST(global_sequence AS CHAR));
END//

CREATE TRIGGER `UPDATE_GLOBAL_SEQUENCE_ON_VENDOR_EVENT`
BEFORE INSERT
ON `vendor_event` FOR EACH ROW
BEGIN
    DECLARE global_sequence BIGINT UNSIGNED;
    
    SELECT sequence INTO global_sequence FROM global_sequence WHERE node_id = '1' FOR UPDATE;
    UPDATE global_sequence SET sequence = sequence + 1 WHERE node_id = '1';

    SET NEW.metadata = JSON_SET(NEW.metadata, '$.s', CAST(global_sequence AS CHAR));
END//

DELIMITER ;


-------------------------
------ VIEW TABLES ------
-------------------------

CREATE TABLE vendor_product_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (view_id)
);
