-- Drop the tables if they exist

DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Line;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS Delivery;
;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Create the tables


CREATE TABLE product (
ProductCode varchar(35) PRIMARY KEY,
PName varchar(35) not null,
PPrice decimal (8,2),
QuantityOnHand smallint not null,
PColor varchar(15));
--------------------------------------------------------------------------
CREATE TABLE Supplier (
SupplierId int PRIMARY KEY,
SupplierFName varchar(35) not null,
SupplierLName varchar(35) not null,
SupplierPhone char(10) not null,
SupplierEmail varchar(35) not null);
--------------------------------------------------------------------------
create table Orders(
orderid varchar(35) Primary key,
productcode varchar(35) not null,
CONSTRAINT supplies FOREIGN KEY (productcode) REFERENCES product (productcode)
    ON UPDATE CASCADE ON DELETE SET NULL
);
---------------------------------------------------------------------------
CREATE TABLE Users(
UserId int NOT NULL UNIQUE,
UserFName varchar(35) NOT NULL,
UserLName varchar(35) NOT NULL,
UserAddress varchar(70) NOT NULL,
UserEmail varchar(35) NOT NULL UNIQUE,
UserPhone char(10) NOT NULL,
Password varchar(300) NOT NULL,
PRIMARY KEY (UserId)
);
---------------------------------------------------------------------------
CREATE TABLE Line(
LineNumber int PRIMARY KEY,
UnitPrice decimal (8,2),
Quantity int,
productcode varchar(35) UNIQUE,
CONSTRAINT supplies FOREIGN KEY (ProductCode) REFERENCES Product (ProductCode)
ON UPDATE CASCADE ON DELETE SET NULL
    );
---------------------------------------------------------------------------
create table Invoice (
invoicenumber int primary key,
productcode    varchar(35) not null,
orderid     varchar(35) not null,
invoicedate date not null,
CONSTRAINT supplies FOREIGN KEY (productcode) REFERENCES line (productcode)
	ON UPDATE CASCADE ON DELETE SET NULL,
CONSTRAINT supply FOREIGN KEY (orderid) REFERENCES orders (orderid)
    ON UPDATE CASCADE ON DELETE SET NULL
);
---------------------------------------------------------------------------

CREATE TABLE Delivery(
supplierID int UNIQUE,
Productcode varchar(35)UNIQUE,
deliverycode int primary key,
CONSTRAINT supply FOREIGN KEY (supplierID) REFERENCES supplier (Supplierid)
ON UPDATE CASCADE ON DELETE SET NULL,
CONSTRAINT deliver FOREIGN KEY (productcode) REFERENCES product (productcode)
ON UPDATE CASCADE ON DELETE SET NULL);

---------------------------------POPULATION--------------------------------
INSERT INTO Supplier (supplierID,supplierfname,supplierlname,supplierphone,supplieremail) VALUES
(21300,'Ayoub','Azmi','0610346423','aazmi@gmail.com'),
(21301,'Ismail','Bahiaoui','0661326593','ibahiaoui@gmail.com'),
(21302,'Omar','Aarab','0650346312','oaarab@gmail.com'),
(21303,'Riad','Jabri','0668342319','rjabri@gmail.com'),
(21304,'Anass','Bouargane','0661900059','abouargane@gmail.com'),
(21305,'Akram','Seddiki','0610484238','aseddiki@gmail.com');
---------------------------------------------------------------------------
INSERT INTO Product (productcode,pname,pprice,quantityonhand,pcolor) VALUES
('PGO597','Accoustic Guitar',2000.00,30,'black'),
('PLP165','Bass Flute',500.00,17,'Gold'),
('PBY231','Alto Saxophone',3000,5,null),
('PGK486','Bass Guitar',2500,15,'Beige'),
('PYU689','Bass Drum',3500,2,null),
('PAQ249','Clarinet',1500,27,null),
('PFR323','Accoustic Guitar Strings',10.99,50,'Blue'),
('PAS190','Electric Piano',9999.90,3,'Black'),
('PDZ123','Electric Guitar',4999.90,10,'Black'),
('PHW021','Electric Guitar Strings',10.99,50,'Orange');

 --add userid
INSERT INTO Orders (orderid, productcode) VALUES --we added a column with the userid (see alter table) and we implemetend the column with users ids in pgAdmin
('OLO499','PGO597'),
('OFH795','PLP165'),
('ODR165','PBY231'),
('OTR684','PGK486'),
('OGX356','PYU689'),
('ONM561','PAQ249');
---------------------------------------------------------------------------
INSERT INTO line (LineNumber,UnitPrice,Quantity,ProductCode) VALUES
(12,10.5,20,'PGO597'),
(11,10.7,30,'PLP165'),
(10,10.9,50,'PBY231'),
(18,12.4,10,'PGK486')
;
---------------------------------------------------------------------------
INSERT INTO Invoice (invoicenumber, productcode, orderid, invoicedate) VALUES
(1234,'PGO597','OLO499','2016-06-12'),
(1259,'PLP165','OFH795','2016-05-18'),
(1958,'PBY231','ODR165','2017-10-11'),
(7986,'PGK486','OTR684','2017-01-05');
---------------------------------------------------------------------------
INSERT INTO Users (UserId,UserFName,UserLName,UserAddress,UserEmail,UserPhone, Password) VALUES
(75848,'Hamza','Waled','hay nahda','H.waled@aui.ma','0645789565', 'ABD123'),
(78956,'Achraf','Soualhia','hay salam','A.soualhia@aui.ma','0642784598', '345EFD'),
(45789,'Houssam','Mouloue','hay marzoug','H.mouloue@aui.ma','0650869575', 'WER666'),
(12365,'Yasmine','Najd','hay berchid','Y.najd@aui.ma','0612324565', 'X4E2T8')
;
---------------------------------------------------------------------------
------------------------------queries--------------------------------------

alter table orders
add constraint uid foreign key (userid) references users (userid) on update cascade on delete cascade;
---------------------------------------------------------------------------
alter table orders
add column userid int;
---------------------------------------------------------------------------

CREATE INDEX IX_users_name ON users (userfname,userlname);
---------------------------------------------------------------------------
Select * from line as L
INNER JOIN product as P
on L.productcode = P.productcode;
---------------------------------------------------------------------------
--This trigger was not used because we did not implement everything
DROP TRIGGER IF EXISTS trdiscount ON invoice;
DROP FUNCTION IF EXISTS discountfun();
 
CREATE FUNCTION discountfun() RETURNS TRIGGER
AS $$
BEGIN
  UPDATE invoice
  SET Iprice = new.price - (0.2 * new.price)
  WHERE  (SELECT ismember
                      FROM user
                        WHERE userid = new.userid) = 1;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER trdiscount AFTER INSERT ON invoice
FOR EACH ROW
EXECUTE FUNCTION discountfun();

---------------------------------------------------------------------------
CREATE FUNCTION update_prod() RETURNS TRIGGER
AS $$
BEGIN
UPDATE Product
set quantityonhand = quantityonhand - 1
WHERE productCode = new.productCode;

RETURN NEW;
END;
$$
LANGUAGE plpgsql;
CREATE TRIGGER trProdUpd AFTER INSERT ON Orders
FOR EACH ROW
EXECUTE FUNCTION update_prod();


