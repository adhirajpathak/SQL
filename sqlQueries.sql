-- #1. Create an alphabetical listing (​LastName​, ​FirstName​) of all employees not living in the 
-- USA who have been employed with Northwinds for at least 5 years as of today.
   SELECT LastName, FirstName 
   FROM nwEmployees 
   WHERE Country <> 'USA' 
   ORDER BY LastName ASC;

-- #2. Prepare a ​Reorder List​ for products currently in stock. 
-- Products in stock have at leastone unit in the inventory. 
-- Show ​ProductID​, ​ProductName​, ​UnitsInStock,​ andUnitPrice​ for products whose inventory level is at or below the ​ReorderLevel​.
   
   SELECT ProductID, ProductName, UnitsInStock, UnitPrice 
   FROM nwProducts 
   WHERE UnitsInStock >= 1 AND UnitsInStock < ReorderLevel;

-- #3. What is the name and unit price of the most expensive product sold by Northwinds? Use
-- a subquery. 
   SELECT ProductName, UnitPrice
   FROM nwProducts
   WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM nwProducts);

-- #4.Create a list of the products in stock which have an inventory value (“inventory value” =
-- UnitsInStock * UnitPrice) over $2,000. Show the answer set columns as
-- ProductID, ProductName, and “Total Inventory Value” in order of descending
-- inventory value (highest to lowest).

   SELECT ProductID, ProductName, UnitsInStock * UnitPrice AS 'Total Inventory Value'
   FROM nwProducts
   WHERE UnitsInStock*UnitPrice > 2000
   ORDER BY UnitsInStock*UnitPrice DESC;

-- #5 List the ShipCountry and a count of orders for all the orders that shipped outside the
-- USA during September 2013 in ascending country sequence

   SELECT ShipCountry, COUNT(*) as 'numOrders'
   FROM nwOrders
   WHERE ShipCountry <> 'USA' AND ShippedDate >= '2013-09-01' AND ShippedDate <= '2013-09-30'
   GROUP BY ShipCountry
   ORDER BY ShipCountry ASC;

-- #6. List the CustomerID and CompanyName of the customers who have more than 20
-- orders.
   SELECT c.CustomerID, c.CompanyName 
   FROM nwCustomers c JOIN nwOrders o 
   WHERE c.CustomerID = o.CustomerID
   GROUP BY CustomerID HAVING COUNT(OrderID) > 20;

-- #7. Create a Supplier Inventory Report (by SupplierID) showing the total value of their
-- inventory in stock (“inventory value” = UnitsInStock * UnitPrice). List only those
-- suppliers from whom Northwinds receives more than 3 different items. Show
-- SupplierID and “Total Inventory Value”. 
   SELECT SupplierID, SUM(UnitsInStock * UnitPrice) AS 'Supplier Inventory Report'
   FROM nwProducts
   GROUP BY SupplierID
   HAVING COUNT(*) > 3;

-- #8. Create a Supplier Price List showing the suppliers’ CompanyName, and products’
-- ProductName and UnitPrice for all products from suppliers located in the USA. Sort
-- the list in order from highest price to lowest price. 
   SELECT CompanyName, ProductName, UnitPrice
   FROM nwSuppliers, nwProducts
   WHERE nwProducts.SupplierID = nwSuppliers.SupplierID AND nwSuppliers.Country = 'USA'
   ORDER BY UnitPrice DESC; 

-- #9. Create an Employee Order List showing, in alphabetical order (by full name), the
-- LastName, FirstName, Title, Extension, and “Number of Orders” for each
-- employee who has more than 100 orders.
   SELECT emp.LastName, emp.FirstName, emp.Title, emp.Extension, COUNT(emp.EmployeeID) AS 'Number of Orders'
   FROM nwEmployees emp INNER JOIN nwOrders ord
   ON (emp.EmployeeID = ord.EmployeeID)
   GROUP BY emp.LastName, emp.FirstName, emp.Title, emp.Extension
   HAVING COUNT(emp.EmployeeID) >= 100;

-- #10. Create an Orders Exception List showing the CustomerID and the CompanyName of
-- all customers who have no orders on file.
   SELECT CustomerID, CompanyName
   FROM nwCustomers
   WHERE CustomerID NOT IN (SELECT CustomerID FROM nwOrders);

-- #11. Create an Out of Stock List showing the suppliers’ CompanyName, ContactName,
-- and the products’ CategoryName, CategoryDescription, ProductName, and
-- UnitsOnOrder for all products that are out of stock (UnitsInStock = 0). 
   SELECT CompanyName, ContactName, CategoryName, Description, ProductName, UnitsOnOrder
   FROM nwSuppliers, nwProducts, nwCategories
   WHERE nwSuppliers.SupplierID = nwProducts.SupplierID AND nwProducts.CategoryID = nwCategories.CategoryID AND UnitsInStock = 0;

-- #12. List the ProductName, SupplierName, suppliers’ Country and UnitsInStock for
-- all the products that come in a bottle or bottles.
   SELECT ProductName, CompanyName, Country, UnitsInStock
   FROM nwProducts, nwSuppliers
   WHERE QuantityPerUnit LIKE '%bottles%' AND nwProducts.SupplierID = nwSuppliers.SupplierID;

-- #13. Create a new table named “nwtopitems” with the following columns: ItemID (integer),
-- ItemCode (integer), ItemName (varchar(40)), InventoryDate (DATE), SupplierID
-- (integer), ItemQuantity (integer), and ItemPrice (decimal(9,2)). None of these
-- columns can be NULL. Include a PRIMARY KEY constraint on ItemID.
   DROP TABLE IF EXISTS nwtopitems;

   CREATE TABLE nwtopitems(
   ItemID         int  unique  NOT NULL, 
   ItemCode       int          NOT NULL,
   ItemName       varchar(40)  NOT NULL, 
   InventoryDate  timestamp    NOT NULL,
   SupplierID     int          NOT NULL, 
   ItemQuantity   int          NOT NULL, 
   ItemPrice      decimal(9,2) NOT NULL, 
   PRIMARY KEY  (ItemID)
   );

-- #14. Populate the new table “nwtopitems” using these columns from the “nwproducts”
-- table ...
-- ProductID -> ItemID
-- CategoryID -> ItemCode
-- ProductName -> ItemName
-- Today’s date -> Inventory Date
-- UnitsInStock -> ItemQuantity
-- UnitPrice -> ItemPrice
-- SupplierID -> SupplierID
-- … only for products that have an inventory value greater than $2,500 (“inventory value”
-- = UnitsInStock * UnitPrice)
   INSERT INTO nwtopitems (ItemID, ItemCode, ItemName, InventoryDate, SupplierID, ItemQuantity, ItemPrice)
   SELECT ProductID, CategoryID, ProductName, CURRENT_DATE, SupplierID, UnitsInStock, UnitPrice
   FROM nwProducts
   WHERE (UnitPrice * UnitsInStock) > 2500;

-- #15. Delete the rows in “nwtopitems” for suppliers from Canada
   DELETE FROM nwtopitems
   WHERE SupplierID IN (SELECT s.SupplierID 
   						FROM nwSuppliers s
   						WHERE s.Country = "Canada");

-- #16. Add a new column to the “nwtopitems” table called InventoryValue (decimal(9,2))
-- after the inventory date.
   ALTER TABLE nwtopitemss
   ADD InventoryValue decimal(9,2);

-- #17. Update the “nwtopitems” table, setting the InventoryValue column equal to the
-- ItemPrice multiplied by the ItemQuantity
   UPDATE nwtopitems
   SET InventoryValue = ItemQuantity * ItemPrice;

-- #18. Drop the “nwtopitems” table.
   DROP TABLE nwtopitems;

