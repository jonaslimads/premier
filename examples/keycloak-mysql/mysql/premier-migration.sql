-- ------------------------------------
-- -------------- EVENTS --------------
-- ------------------------------------

CREATE TABLE `order_event` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version MEDIUMINT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_id, sequence),
    KEY (aggregate_id)
);

CREATE TABLE `order_event_pending_replay` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    CONSTRAINT PRIMARY KEY (aggregate_id),
    CONSTRAINT FOREIGN KEY (aggregate_id, sequence) REFERENCES order_event (aggregate_id, sequence)
);

CREATE TABLE `product_event` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version MEDIUMINT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_id, sequence),
    KEY (aggregate_id)
);

CREATE TABLE `product_event_pending_replay` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    CONSTRAINT PRIMARY KEY (aggregate_id),
    CONSTRAINT FOREIGN KEY (aggregate_id, sequence) REFERENCES product_event (aggregate_id, sequence)
);

CREATE TABLE `vendor_event` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    event_type TEXT NOT NULL,
    event_version MEDIUMINT NOT NULL,
    payload JSON NOT NULL,
    metadata JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (aggregate_id, sequence),
    KEY (aggregate_id)
);

CREATE TABLE `vendor_event_pending_replay` (
    aggregate_id BIGINT UNSIGNED NOT NULL,
    sequence BIGINT CHECK (sequence >= 0),
    CONSTRAINT PRIMARY KEY (aggregate_id),
    CONSTRAINT FOREIGN KEY (aggregate_id, sequence) REFERENCES vendor_event (aggregate_id, sequence)
);

CREATE TABLE `vendor_product` (
    vendor_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT PRIMARY KEY (vendor_id, product_id),
    CONSTRAINT FOREIGN KEY (vendor_id) REFERENCES vendor_event (aggregate_id),
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES product_event (aggregate_id)
);


DELIMITER //

CREATE FUNCTION `CONVERT_VERSION_TO_INT`(`version` TEXT) RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
	DECLARE parts INT;
	DECLARE major TEXT;
	DECLARE minor TEXT;
	DECLARE patch TEXT;

	SET parts = LENGTH(version) - LENGTH(REPLACE(version, '.', ''));
	SET major = SUBSTRING_INDEX(SUBSTRING_INDEX(version, '.', 1), '.', -1);
	SET minor = SUBSTRING_INDEX(SUBSTRING_INDEX(version, '.', 2), '.', -1);
	SET patch = SUBSTRING_INDEX(SUBSTRING_INDEX(version, '.', 3), '.', -1);

	IF parts = 2 THEN
		RETURN major * 10000 + minor * 100 + patch;
	ELSEIF parts = 1 THEN
		RETURN major * 10000 + minor * 100;
	ELSE
		RETURN major * 10000;
    END IF;
END//


CREATE FUNCTION `CONVERT_VERSION_TO_TEXT`(`version` INT) RETURNS TEXT
DETERMINISTIC
BEGIN
	DECLARE major TEXT;
	DECLARE minor TEXT;
	DECLARE patch TEXT;

	IF version < 99 THEN
		RETURN CONCAT(version, '');
	ELSEIF version < 9999 THEN
		SET major = version DIV 100;
		SET minor = version - major * 100;
		RETURN CONCAT(major, '.', minor);
	ELSE
		SET major = version DIV 10000;
		SET minor = (version - major * 10000) DIV 100;
		SET patch = version - major * 10000 - minor * 100;
		RETURN CONCAT(major, '.', minor, '.', patch);
	END IF;
END//


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


-- ---------------------------------------------
-- -------------- GLOBAL SEQUENCE --------------
-- ---------------------------------------------

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


-- -----------------------------------------
-- -------------- VIEW TABLES --------------
-- -----------------------------------------

CREATE TABLE vendor_product_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (view_id)
);

CREATE TABLE product_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (view_id)
);

-- -----------------------------------
-- -------------- TEST  --------------
-- -----------------------------------

CREATE TABLE events (
    aggregate_type varchar(255)                 NOT NULL,
    aggregate_id   varchar(255)                 NOT NULL,
    sequence       bigint CHECK (sequence >= 0) NOT NULL,
    event_type     text                         NOT NULL,
    event_version  text                         NOT NULL,
    payload        json                         NOT NULL,
    metadata       json                         NOT NULL,
    CONSTRAINT events_pk PRIMARY KEY (aggregate_type, aggregate_id, sequence)
);

CREATE TABLE snapshots (
    aggregate_type   varchar(255)                         NOT NULL,
    aggregate_id     varchar(255)                         NOT NULL,
    last_sequence    bigint CHECK (last_sequence >= 0)    NOT NULL,
    current_snapshot bigint CHECK (current_snapshot >= 0) NOT NULL,
    payload          json                                 NOT NULL,
    CONSTRAINT snapshots_pk PRIMARY KEY (aggregate_type, aggregate_id)
);

CREATE TABLE test_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    CONSTRAINT PRIMARY KEY (view_id)
);
