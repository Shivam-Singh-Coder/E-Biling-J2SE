create user ebiling identified by shiv
/

grant dba to ebiling
/

conn ebiling/shiv
/
set def off
/
CREATE TABLE CUSTOMERS (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    contact_number VARCHAR2(15),
    email VARCHAR2(100),
    address VARCHAR2(255),
    city VARCHAR2(50),
    country VARCHAR2(50),
    postal_code VARCHAR2(20)
);

-- Sequence for auto-incrementing customer_id
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate customer_id from sequence
CREATE OR REPLACE TRIGGER customer_trigger
BEFORE INSERT ON CUSTOMERS
FOR EACH ROW
BEGIN
    SELECT customer_seq.NEXTVAL INTO :NEW.customer_id FROM dual;
END;
/
CREATE TABLE INVOICES (
    invoice_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    invoice_date DATE DEFAULT SYSDATE,
    due_date DATE,
    total_amount NUMBER(12, 2) DEFAULT 0.00,
    status VARCHAR2(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);

-- Sequence for auto-incrementing invoice_id
CREATE SEQUENCE invoice_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate invoice_id from sequence
CREATE OR REPLACE TRIGGER invoice_trigger
BEFORE INSERT ON INVOICES
FOR EACH ROW
BEGIN
    SELECT invoice_seq.NEXTVAL INTO :NEW.invoice_id FROM dual;
END;
/
CREATE TABLE INVOICE_ITEMS (
    item_id NUMBER PRIMARY KEY,
    invoice_id NUMBER,
    product_name VARCHAR2(100),
    quantity NUMBER,
    unit_price NUMBER(12, 2),
    total_price NUMBER(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id)
);

-- Sequence for auto-incrementing item_id
CREATE SEQUENCE invoice_item_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate item_id from sequence
CREATE OR REPLACE TRIGGER invoice_item_trigger
BEFORE INSERT ON INVOICE_ITEMS
FOR EACH ROW
BEGIN
    SELECT invoice_item_seq.NEXTVAL INTO :NEW.item_id FROM dual;
END;
/
CREATE TABLE PAYMENTS (
    payment_id NUMBER PRIMARY KEY,
    invoice_id NUMBER,
    payment_date DATE DEFAULT SYSDATE,
    amount_paid NUMBER(12, 2),
    payment_method VARCHAR2(50),
    FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id)
);

-- Sequence for auto-incrementing payment_id
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate payment_id from sequence
CREATE OR REPLACE TRIGGER payment_trigger
BEFORE INSERT ON PAYMENTS
FOR EACH ROW
BEGIN
    SELECT payment_seq.NEXTVAL INTO :NEW.payment_id FROM dual;
END;
/
CREATE TABLE TAXES (
    tax_id NUMBER PRIMARY KEY,
    invoice_id NUMBER,
    tax_percentage NUMBER(5, 2),
    tax_amount NUMBER(12, 2),
    FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id)
);

-- Sequence for auto-incrementing tax_id
CREATE SEQUENCE tax_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate tax_id from sequence
CREATE OR REPLACE TRIGGER tax_trigger
BEFORE INSERT ON TAXES
FOR EACH ROW
BEGIN
    SELECT tax_seq.NEXTVAL INTO :NEW.tax_id FROM dual;
END;
/
CREATE TABLE DISCOUNTS (
    discount_id NUMBER PRIMARY KEY,
    invoice_id NUMBER,
    discount_percentage NUMBER(5, 2),
    discount_amount NUMBER(12, 2),
    FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id)
);

-- Sequence for auto-incrementing discount_id
CREATE SEQUENCE discount_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate discount_id from sequence
CREATE OR REPLACE TRIGGER discount_trigger
BEFORE INSERT ON DISCOUNTS
FOR EACH ROW
BEGIN
    SELECT discount_seq.NEXTVAL INTO :NEW.discount_id FROM dual;
END;
/
CREATE TABLE INVOICE_STATUS_HISTORY (
    history_id NUMBER PRIMARY KEY,
    invoice_id NUMBER,
    status VARCHAR2(20),
    change_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id)
);

-- Sequence for auto-incrementing history_id
CREATE SEQUENCE history_seq START WITH 1 INCREMENT BY 1;

-- Trigger to auto-populate history_id from sequence
CREATE OR REPLACE TRIGGER history_trigger
BEFORE INSERT ON INVOICE_STATUS_HISTORY
FOR EACH ROW
BEGIN
    SELECT history_seq.NEXTVAL INTO :NEW.history_id FROM dual;
END;
/
-- Inserting customer data
INSERT INTO CUSTOMERS (customer_name, contact_number, email, address, city, country, postal_code)
VALUES ('John Doe', '1234567890', 'john.doe@example.com', '123 Elm Street', 'Los Angeles', 'USA', '90001');

-- Inserting invoice data
INSERT INTO INVOICES (customer_id, due_date, total_amount, status)
VALUES (1, TO_DATE('2025-02-28', 'YYYY-MM-DD'), 1500.00, 'Pending');

-- Inserting invoice items
INSERT INTO INVOICE_ITEMS (invoice_id, product_name, quantity, unit_price)
VALUES (1, 'Laptop', 1, 1500.00);

-- Inserting payment data
INSERT INTO PAYMENTS (invoice_id, amount_paid, payment_method)
VALUES (1, 1500.00, 'Credit Card');

commit;
