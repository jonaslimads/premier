-- ------------------------------------
-- -------------- EVENTS --------------
-- ------------------------------------
CREATE TABLE `order_event` (
    aggregate_id varchar(255) NOT NULL,
    sequence bigint CHECK (sequence >= 0) NOT NULL,
    event_type text NOT NULL,
    event_version text NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    PRIMARY KEY (aggregate_id, sequence)
);

CREATE INDEX order_event_aggregate_idx ON order_event (aggregate_id);

CREATE TABLE `platform_event` (
    aggregate_id varchar(255) NOT NULL,
    sequence bigint CHECK (sequence >= 0) NOT NULL,
    event_type text NOT NULL,
    event_version text NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    PRIMARY KEY (aggregate_id, sequence)
);

CREATE INDEX platform_event_aggregate_idx ON platform_event (aggregate_id);

CREATE TABLE `product_event` (
    aggregate_id varchar(255) NOT NULL,
    sequence bigint CHECK (sequence >= 0) NOT NULL,
    event_type text NOT NULL,
    event_version text NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    PRIMARY KEY (aggregate_id, sequence)
);

CREATE INDEX product_event_aggregate_idx ON product_event (aggregate_id);

CREATE TABLE `vendor_event` (
    aggregate_id varchar(255) NOT NULL,
    sequence bigint CHECK (sequence >= 0) NOT NULL,
    event_type text NOT NULL,
    event_version text NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    PRIMARY KEY (aggregate_id, sequence)
);

CREATE INDEX vendor_event_aggregate_idx ON vendor_event (aggregate_id);

CREATE TABLE `vendor_product` (
    vendor_id varchar(255) NOT NULL,
    product_id varchar(255) NOT NULL,
    -- FOREIGN KEY (vendor_id) REFERENCES vendor_event (aggregate_id),
    -- FOREIGN KEY (product_id) REFERENCES product_event (aggregate_id),
    PRIMARY KEY (vendor_id, product_id)
);

-- -----------------------------------------
-- -------------- VIEW TABLES --------------
-- -----------------------------------------
CREATE TABLE platform_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    PRIMARY KEY (view_id)
);

CREATE TABLE vendor_product_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    PRIMARY KEY (view_id)
);

CREATE TABLE product_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    PRIMARY KEY (view_id)
);

-- -----------------------------------
-- -------------- TEST  --------------
-- -----------------------------------
CREATE TABLE events (
    aggregate_type varchar(255) NOT NULL,
    aggregate_id varchar(255) NOT NULL,
    sequence bigint CHECK (sequence >= 0) NOT NULL,
    event_type text NOT NULL,
    event_version text NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    PRIMARY KEY (aggregate_type, aggregate_id, sequence)
);

CREATE TABLE snapshots (
    aggregate_type varchar(255) NOT NULL,
    aggregate_id varchar(255) NOT NULL,
    last_sequence bigint CHECK (last_sequence >= 0) NOT NULL,
    current_snapshot bigint CHECK (current_snapshot >= 0) NOT NULL,
    payload json NOT NULL,
    PRIMARY KEY (aggregate_type, aggregate_id)
);

CREATE TABLE test_view (
    view_id VARCHAR(255) NOT NULL,
    version BIGINT CHECK (version >= 0),
    payload JSON NOT NULL,
    PRIMARY KEY (view_id)
);