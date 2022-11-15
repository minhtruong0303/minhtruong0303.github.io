use fifo
CREATE TABLE movement
(
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    warehouse   VARCHAR(100),
    sku         VARCHAR(100),
    quantity    INT,
    balance     INT,
    created_at  DATETIME
);

CREATE TABLE document
(
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    type        TEXT
);

CREATE TABLE customer
(
    id      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    contact VARCHAR(100)
);

INSERT INTO movement (document_id, sku, warehouse, quantity, balance, created_at)
VALUES (1, 'iPhone', 'HK', 10, 10, '2021-1-1'),
       (1, 'iPod', 'HK', 3, 3, '2021-1-1'),
       (2, 'iPod', 'HK', -1, 2, '2021-1-2'),
       (3, 'iPod', 'HK', -2, 0, '2021-1-3'),
       (4, 'iPod', 'HK', 5, 5, '2021-2-1'),
       (5, 'iMac', 'US', 5, 5, '2021-2-1'),
       (5, 'iPhone', 'US', 2, 2, '2021-2-1'),
       (6, 'iMac', 'HK', 5, 5, '2021-2-2'),
       (7, 'iPod', 'HK', -4, 1, '2021-2-8'),
       (8, 'iMac', 'HK', -1, 4, '2021-2-9'),
       (9, 'iPhone', 'US', -1, 1, '2021-2-17'),
       (10, 'iMac', 'HK', 1, 5, '2021-3-2'),
       (11, 'iMac', 'HK', -1, 4, '2021-3-8'),
       (11, 'iPod', 'HK', -1, 0, '2021-3-8'),
       (12, 'iMac', 'US', 5, 10, '2021-3-10');

INSERT INTO document (id, customer_id, type)
VALUES (1, NULL, "purchase"),
       (2, 1, 'sales_order'),
       (3, 2, 'sales_order'),
       (4, NULL, 'purchase'),
       (5, NULL, 'purchase'),
       (6, NULL, 'purchase'),
       (7, 3, 'sales_order'),
       (8, 1, 'sales_order'),
       (9, 4, 'sales_order'),
       (10, NULL, 'purchase'),
       (11, NULL, 'sales_order'),
       (12, NULL, 'purchase'),
       (13, NULL, 'purchase');

INSERT INTO customer (id, contact)
VALUES (1, 'boris0407@gmail.com'),
       (2, 'candywong@gmail.com'),
       (3, 'flora2002@gmail.com'),
       (4, 'glory@gmail.com'),
       (5, 'himsonfong@gmail.com');

/*Question 1: Customer Leaderboard
Rank customers by quantity they purchased.
Include the customer's email address *(shown as "guest" if not provided)* and quantity they purchased in the report */
select case when C.contact is null then 'Guest' else C.contact end as
                                                                      contact,
       count(D.id)                                                 as sold
from document D
         left join Customer C on D.customer_id = C.id
group by C.contact
             --- or
select IF(C.contact is null, 'Guest', C.contact) as contact,
       count(D.id)
                                                 as sold
from document D
         left join Customer C on D.customer_id = C.id
group by C.contact
/* Question 2: Inventory Snapshot
Write a SQL query to return `HK` warehouse's stock of any given time.
Define a variable for the time so user can change it easily. For example: `SET @date = '2021-4-1 00:00:00' */


set @date = '2021-04-01';
select *
from (select warehouse, sku, balance, created_at
      from movement
      where warehouse = 'HK'
        and sku = 'iPhone'
        and created_at <= @date
      order by created_at desc
      limit 1) A
union
select *
from (select warehouse, sku, balance, created_at
      from movement
      where warehouse = 'HK'
        and sku = 'iPod'
        and created_at <= @date
      order by created_at desc
      limit 1) B
union
select *
from (select warehouse, sku, balance, created_at
      from movement
      where warehouse = 'HK'
        and sku = 'iMac'
        and created_at <= @date
      order by created_at desc
      limit 1) C
/*Question 3 : FIFO Analytics
Show the age of the available stocks of a given time, and group the quantity by age "0-30 days", "31-60 days", "61 - 90 days" and "90 days+".
· Age of an stock means the number of day after it enters the warehouse.
· Stocks in a warehouse comes and goes.When deducting stock please follow the "First In First Out" rule, meaning oldest stock will be deducted first.*/
select *
from (select sku,balance as stock,
             if(inventory_age <= 30, quantity, 0)                        as 'Age 0 - 30',
             if(inventory_age > 30 and inventory_age <= 60, quantity, 0) as 'Age 31 - 60',
             if(inventory_age > 60 and inventory_age <= 90, quantity, 0) as 'Age 61 - 90',
             if(inventory_age > 90, quantity, 0)                         as 'Age 90+'

      from (select sku, quantity, balance, datediff( created_at, '2021-04-01') as inventory_age, created_at
            from movement
            where warehouse = 'HK'
              and sku = 'iMac'
              and created_at <= '2021-04-01') A
      order by created_at
      limit 1) iMac
Union
select *
from (select  sku,balance as stock,
             if(inventory_age <= 30, quantity, 0)                        as 'Age 0 - 30',
             if(inventory_age > 30 and inventory_age <= 60, quantity, 0) as 'Age 31 - 60',
             if(inventory_age > 60 and inventory_age <= 90, quantity, 0) as 'Age 61 - 90',
             if(inventory_age > 90, quantity, 0)                         as 'Age 90+'
      from (select sku, quantity, balance, datediff( created_at, '2021-04-01') as inventory_age, created_at
            from movement
            where warehouse = 'HK'
              and sku = 'iPhone'
              and created_at <= '2021-04-01') A
      order by created_at
      limit 1) iPhone
union
select *
from (select sku,balance as stock,
             if(inventory_age <= 30, quantity, 0)                        as 'Age 0 - 30',
             if(inventory_age > 30 and inventory_age <= 60, quantity, 0) as 'Age 31 - 60',
             if(inventory_age > 60 and inventory_age <= 90, quantity, 0) as 'Age 61 - 90',
             if(inventory_age > 90, quantity, 0)                         as 'Age 90+'
      from (select sku, quantity, balance, datediff( created_at, '2021-04-01') as inventory_age, created_at
            from movement
            where warehouse = 'HK'
              and sku = 'iPod'
              and created_at <= '2021-04-01') A
      order by created_at
      limit 1) iPod