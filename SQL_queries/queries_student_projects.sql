/* here are my skills in sql coding from Warsaw University of Technology */

/*
1
*/
create PROCEDURE
    Zadanie1 @Number Int
AS
    BEGIN TRANSACTION
        insert into ArchivedOrderDetails (OrderId,ProductID,
        UnitPrice,Quantity,Discount) select OrderId,ProductID,
        UnitPrice,Quantity,Discount from (select od.* from [Order Details] as od 
        join Orders as o on o.OrderID = od.OrderID where 
        datediff(yy,OrderDate,getdate()) > 26) as a
    COMMIT TRANSACTION
go

exec Zadanie1 @Number = 26

drop PROCEDURE Zadanie1

/*
2
*/
select e.LastName, e.Firstname, sum(Quantity) as TotalSum from Employees as e
Join Orders as o on o.EmployeeID = e.EmployeeID
Join [Order Details] as od on o.OrderID = od.OrderId 
Join Products as p on p.ProductID = od.ProductID where p.ProductName = 'Chocolade' 
and year(o.OrderDate) = 1998
group by p.ProductName, e.LastName, e.FirstName
having sum(Quantity) > 100


/* 
3
*/
select p.productname, c.CustomerID, sum(Quantity) as TotalSum from Customers as c JOIN
orders as o on c.CustomerID = o.CustomerID JOIN
[Order Details] as od on o.OrderID = od.OrderID JOIN
Products as p on od.ProductID = p.ProductID where c.country = 'Italy'
group BY o.OrderId, p.Productname, c.customerid
having sum(Quantity)>20 

/*
4
*/
select c.ContactName as [Customer Name], p.ProductName, OrderDate, Quantity from Orders as o join
[Order Details] as od on od.OrderId = o.OrderID JOIN
Products as p on p.ProductID = od.ProductID join 
customers as c on c.CustomerID = o.CustomerID where c.City = 'Berlin' order BY [Customer Name], 
ProductName asc, OrderDate 


/*
5
*/
select distinct p.ProductName from Orders as o join
[Order Details] as od on od.OrderID = o.OrderID JOIN
Products as p on p.ProductID = od.ProductID WHERE
o.ShipCountry = 'France' and year(o.ShippedDate) = 1998 

 
/*
6
*/
select distinct b.customerId from (select a.CustomerID, count(suma) as total from 
(select o.orderID, customerId, count(o.CustomerID) 
as suma from Orders as o join
[Order Details] as od on o.OrderID = od.OrderID 
group by o.CustomerID, o.OrderID) as a GROUP BY CustomerID having count(suma)>2) 
as b left join orders as o on b.CustomerID=o.CustomerID left JOIN
[Order Details] as od on o.OrderID=od.OrderID left JOIN
Products as p on p.ProductID = od.ProductID where p.ProductName not like 'Ravioli%' 

select * from Customers
create index city_country on Customers (City, country)
/*
7
*/
select CompanyName, o.OrderId, total as ProductCount from orders as o join (select orderID, count(OrderID) as total from 
(select o.OrderID, p.productid, count(p.ProductID) as suma from orders as o left JOIN
[Order Details] as od on o.OrderID = od.OrderID JOIN
Products as p on p.ProductID = od.ProductID
group by p.productid, o.OrderID) as a GROUP by OrderID having count(OrderID) >= 4) as b on o.OrderID = b.OrderID join 
customers as c on o.CustomerID = c.CustomerID where c.Country = 'France'


/*
8
*/
select distinct c.CompanyName from customers as c join (select o.ShipCountry, o.CustomerID, count(o.OrderID) 
as total from orders as o join [Order Details] as od ON
o.OrderID = od.OrderID where o.ShipCountry='France' group by o.CustomerID, o.OrderID, o.ShipCountry
having count(o.OrderID) >= 5 union select o.ShipCountry, o.CustomerID, count(o.OrderID) 
as total from orders as o join [Order Details] as od ON
o.OrderID = od.OrderID where o.ShipCountry='Belgium' group by o.CustomerID, o.OrderID, o.ShipCountry
having count(o.OrderID) <= 2) as b on b.CustomerID = c.CustomerID

/*
9
*/
select c.productname, cus.companyname, c.maksquantity from orders as o join
(select od.orderId, b.productname, b.maksquantity from [Order Details] as od join 
(select productname, a.maksquantity from(select ProductID, max(total) as maksQuantity from 
(select o.customerid, od.ProductID, sum(Quantity) as total from orders as o join [Order Details] as 
od on o.Orderid = od.OrderID group by o.CustomerID, od.ProductID) as a GROUP by ProductID) as a join 
Products as p on p.Productid = a.productid) as b on b.maksQuantity = od.Quantity) as c on o.OrderID = c.OrderID
join customers as cus on o.CustomerID = cus.customerid order by maksQuantity desc


/*
10
*/
select o.employeeId, count(o.orderId) as total from orders as o 
GROUP by o.EmployeeID
having count(o.orderId) > (select avg(a.total)*1.2 as avg from 
(select o.employeeId, count(o.orderId) as total from orders 
as o group by EmployeeID) as a)

/*
11
*/
select top 5 o.OrderID, count(ProductID) as [ProductCount] from orders as o join 
[Order Details] as od on o.OrderID = od.OrderID GROUP BY o.OrderID order by ProductCount desc


/*
12
*/
select p.productname, d.TotalQuantityIn1997, d.TotalQuantityIn1996 FROM
(select b.productID, b.TotalQuantityIn1996, c.TotalQuantityIn1997 from (select a.productid,  
count(a.Productquantity) as TotalQuantityIn1996
from (select ProductID, o.orderDate, sum(Quantity) as Productquantity from Orders as o join 
[Order Details] as od on o.OrderID = od.OrderID WHERE
year(OrderDate)=1996 GROUP by od.productID, o.OrderDate) 
as a group by ProductID) as b
join (select a.productid, count(a.Productquantity) as TotalQuantityIn1997
from (select ProductID, o.orderDate, sum(Quantity) as Productquantity from Orders as o join 
[Order Details] as od on o.OrderID = od.OrderID WHERE
year(OrderDate)=1997 GROUP by od.productID, o.OrderDate) as a group by ProductID) 
as c on b.ProductID=c.ProductID where TotalQuantityIn1997 > TotalQuantityIn1996) as d JOIN
Products as p on p.ProductID = d.ProductID

/*
13
*/
select p.productname, d.NumberOfOrdersIn1996, d.NumberOfOrdersIn1997 FROM
(select b.productID, b.NumberOfOrdersIn1996, c.NumberOfOrdersIn1997 from (select a.productid,  
count(a.Productquantity) as NumberOfOrdersIn1996
from (select ProductID, o.orderDate, count(o.OrderID) as Productquantity from Orders as o join 
[Order Details] as od on o.OrderID = od.OrderID WHERE
year(OrderDate)=1996 GROUP by od.productID, o.OrderDate) 
as a group by ProductID) as b
join (select a.productid, count(a.Productquantity) as NumberOfOrdersIn1997
from (select ProductID, o.orderDate, count(o.OrderID) as Productquantity from Orders as o join 
[Order Details] as od on o.OrderID = od.OrderID WHERE
year(OrderDate)=1997 GROUP by od.productID, o.OrderDate) as a group by ProductID) 
as c on b.ProductID=c.ProductID where NumberOfOrdersIn1997 > NumberOfOrdersIn1996) as d JOIN
Products as p on p.ProductID = d.ProductID

/*
14
*/
CREATE Table PriceList (
    ProductId int not null primary KEY,
    ProductName nvarchar(40),
    price DECIMAL(10,2),
    date_from datetime,
    date_to datetime
    CONSTRAINT fk_productid FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
)

begin TRANSACTION
    insert into PriceList (ProductId, ProductName, price, date_from, date_to) 
    select a.ProductId, a.ProductName, a.TotalSum, a.price_from, a.price_to 
    FROM (select od.ProductID, p.Productname, sum(od.UnitPrice) as TotalSum,
    min(OrderDate) AS price_from, max(OrderDate) as price_to
    from [Order Details] as od join Orders as o on
    o.OrderID = od.OrderID join Products as p on p.ProductID=od.ProductID
    group by od.ProductID, p.ProductName) as a;
    
    alter table [Order Details] add TotalValue decimal(10,2);
commit TRANSACTION

begin TRANSACTION
update [Order Details] set [Order Details].TotalValue = PriceList.price 
    from PriceList WHERE
    PriceList.ProductId=[Order Details].ProductID;

    select * from [Order Details]
ROLLBACK

/*
15
*/
begin TRANSACTION
update Orders set employeeid = 4 where EmployeeID = 1
commit TRANSACTION


/*
16
*/
begin TRANSACTION
    UPDATE [Order Details] set Quantity=CEILING(0.8*Quantity) where exists(
    select * from Orders as o join 
    [Order Details] as od on o.OrderID = od.OrderID 
    join Products as p on p.ProductID = od.ProductID 
    where OrderDate > '1997-05-15' and p.ProductName='Ikura')
commit TRANSACTION  


/*
17
*/
begin TRANSACTION
    INSERT INTO [Order Details] (OrderID,ProductID,UnitPrice,Quantity,Discount) 
    values ((select top 1 o.OrderID from Orders as o join [Order Details] as 
    od on o.OrderId=od.OrderID JOIN
    Products as p on p.ProductID=od.ProductID where 
    p.ProductName!='Chocolade' and o.CustomerID = 'ALFKI'
    order by o.OrderDate desc), (select ProductID from Products 
    where ProductName = 'chocolade'), 12.75, 1, 0) 
commit TRANSACTION


/*
18
*/
begin TRANSACTION 
    insert into [Order Details] (OrderID,ProductID) values 
    ((select distinct o.OrderID from orders as o join [Order Details] as 
    od on o.OrderId=od.OrderID JOIN
    Products as p on p.ProductID=od.ProductID where o.CustomerID = 'ALFKI' and not exists
    (select o.OrderDate from Orders as o join [Order Details] as 
    od on o.OrderId=od.OrderID JOIN
    Products as p on p.ProductID=od.ProductID where 
    p.ProductName='Chocolade' and o.CustomerID = 'ALFKI')), 48)
commit TRANSACTION


/*
19
*/
begin TRANSACTION
delete from Customers where CustomerID in 
(select c.CustomerID from Customers as c full join Orders as o on o.CustomerID=c.CustomerID
where OrderId is null)
commit TRANSACTION


/*
20
*/
/* sprawdzam ilość łącznych zamówień przed transakcją*/
select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
join Orders as o on o.OrderID = od.OrderID
where p.ProductName = 'Chocolade' and year(OrderDate) = 1997
GROUP by ProductName

SET IDENTITY_INSERT Products ON;

/* uzywam funkcji rand() zeby wylosowac o jaką liczbę zwiększę zamówienie */

begin TRANSACTION 
    insert into Products (ProductID, ProductName) values (78, 'Programming in Java')
    update [Order Details] set Quantity=Quantity+(select CEILING(RAND() * 5)) WHERE
    OrderID in (select o.OrderId from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997)

    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997
    GROUP by ProductName
COMMIT TRANSACTION


/*
21
*/
begin TRANSACTION 
    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997
    GROUP by ProductName

    update [Order Details] set Quantity=Quantity*2 WHERE
    OrderID in (select o.OrderId from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997)

    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997
    GROUP by ProductName
ROLLBACK

select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
join Orders as o on o.OrderID = od.OrderID
where p.ProductName = 'Chocolade' and year(OrderDate) = 1997
GROUP by ProductName

/*
22
*/
begin TRANSACTION 
    update [Order Details] set Quantity=Quantity*2 WHERE
    OrderID in (select o.OrderId from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997)

    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Ikura'
    GROUP by ProductName

    delete from Orders where OrderId in (select distinct o.OrderId from Orders as o where o.OrderID not in(select distinct o.OrderID from Orders as o join [Order Details] as od on od.OrderID = o.OrderID
    join Products as p on p.ProductId = od.ProductID where p.ProductName = 'Chocolade'))

    insert into [Order Details] (OrderID, ProductID) 
    select od.OrderId,ProductID 
    from [Order Details] as od 
    where od.OrderId not in (select distinct o.OrderId from Orders as o where o.OrderID not 
    in(select distinct o.OrderID from Orders as o join [Order Details] as od on od.OrderID = o.OrderID
    join Products as p on p.ProductId = od.ProductID where p.ProductName = 'Ikura')) and ProductID = (select ProductID from Products where Products.ProductName = 'Ikura')

    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Ikura'
    GROUP by ProductName
ROLLBACK


begin TRANSACTION
    select ProductName, sum(Quantity) as TotalSum from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Ikura'
    GROUP by ProductName

    update [Order Details] set Quantity=Quantity*2 WHERE
    OrderID in (select o.OrderId from Products as p join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID = od.OrderID
    where p.ProductName = 'Chocolade' and year(OrderDate) = 1997)
commit TRANSACTION


/*
23
*/
CREATE TABLE ArchivedOrders(
    OrderID int NOT NULL PRIMARY KEY,
    CustomerID nchar(5),
    EmployeeID int,
    OrderDate datetime,
    RequiredDate datetime,
    ShippedDate datetime,
    ShipVia int,
    Freight money,
    ShipName nvarchar(40),
    ShipAddress nvarchar(60),
    ShipCity nvarchar(15),
    ShipRegion nvarchar(15),
    ShipPostalCode nvarchar(10),
    ShipCountry nvarchar(15),
    ArchiveDate DATETIME,
    CONSTRAINT fk_Customers foreign key (CustomerId) REFERENCES Customers(CustomerId),
    CONSTRAINT fk_employees foreign key (EmployeeID) REFERENCES Employees(EmployeeID)
);

create table ArchivedOrderDetails(
    OrderId int not null PRIMARY key,
    ProductId int,
    UnitPrice decimal(10,2),
    Quantity int,
    Discount decimal(10,2)
    CONSTRAINT fk_OrderId foreign key (OrderId) REFERENCES Orders(OrderId),
    CONSTRAINT fk_ProductId2 FOREIGN key (ProductID) REFERENCES Products(ProductID)
)

begin TRANSACTION
    INSERT INTO ArchivedOrders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry, ArchiveDate)
    SELECT OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry, '' as data
    FROM Orders where year(OrderDate) = 1996
    UPDATE ArchivedOrders set ArchiveDate = getdate()
    INSERT INTO ArchivedOrderDetails (OrderId, ProductId, UnitPrice, Quantity, Discount)
    select OrderId, ProductId, UnitPrice, Quantity, Discount as data from [Order Details]
    delete from ArchivedOrderDetails where OrderId not in (select o.OrderId from Orders as o join
    [Order Details] as od on o.orderId =od.OrderID where year(orderDate) =1996)
COMMIT TRANSACTION


/*
24
*/

begin TRANSACTION
    alter table Orders 
        add isCancelled int not null DEFAULT 0
    update Orders set isCancelled = 1 
        where CustomerId = 'ALFKI'
    update [Order Details] set Quantity = 0 where OrderId in (select OrderId from Orders as o
    where o.CustomerID = 'ALFKI')
commit TRANSACTION

/*
25
*/
begin TRANSACTION
    delete from Authors where au_id in(select au_id from authors as a where city = 'Oakland')
commit TRANSACTION

/*
26
*/
begin TRANSACTION
    insert into titles (title_id, title) 
    select top 6 t.title_id, title from titles as t join 
    titleauthor as ta on ta.title_id = t.title_id join authors as a on 
    ta.au_id = a.au_id where au_lname in ('Ishiguro', 'Murakamy', 'McEwan')
    order by pubdate desc;
    insert into stores (stor_id, stor_name) VALUES (6381,'Ishiguro, Murakamy, McEwan');

    insert into sales (stor_id, title_id)
    select top 6 stor_id,t.title_id from titles as t join 
    titleauthor as ta on ta.title_id = t.title_id join authors as a on 
    ta.au_id = a.au_id full join sales as s on s.title_id=t.title_id
    where au_lname in ('Ishiguro', 'Murakamy', 'McEwan') and s.stor_id = '6381'
    order by pubdate desc;
commit TRANSACTION

exec SelectAllCustomers @City = 'London'




















     
	
     








