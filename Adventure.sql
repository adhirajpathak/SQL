USE AdventureWorks2012;

/* HINT: The PersonType attribute in the Person.Person table is relevant for
the queries in this section. PersonType indicates what kind of person each row
in the table represents. It is a required column and its values are either 
SC, IN, SP, EM, VC, or GC. SC = Store Contact, IN = Individual (retail) customer, 
SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact

1a. Execute the following query, which produces a list of vendor contact names, 
	where the contact name consists of only the first name and the last name, both of 
	which are required (NOT NULL) columns. How many rows are returned and who is 
	the first contact listed?  */

SELECT FirstName + ' ' + LastName As "Vendor Contact"
FROM Person.Person 
WHERE PersonType = 'VC'
ORDER BY LastName, FirstName;

/*The first contact listed is Cathan Cook, it has 156 rows*/

/*
-- 1b. Execute the following query, which is the same as above except that I've
-- 	added middle name (a column that may have NULL values) to the SELECT clause. 
-- 	The results don't look right! What happened & why? */ 

SELECT FirstName + ' ' + MiddleName + ' ' + LastName As "Vendor Contact"
FROM Person.Person 
WHERE PersonType = 'VC'
ORDER BY LastName, FirstName;

/*
The results display a list of people’s FirstName, MiddleName, and LastName of the PersonType ‘VC’. The list includes null values as some of the people don’t have a MiddleName, which sets Vendor Contact to display null rows.  
/*

1c.	How can I fix the above query (and still keep middle name in the result)
	so that I get back better results? You can either explain what you would do
	or show a revised query. */ 

SELECT	FirstName + ' ' + MiddleName + ' ' + LastName As "Vendor Contact"
FROM	Person.Person 
WHERE	PersonType = 'VC' AND MiddleName IS NOT NULL
ORDER BY LastName, FirstName;


/* 
2.	Show the SQL statement to list the name and address for each salesperson. 
	You can assume that a salesperson has only one address.
	We don't need to see complete addresses -- just the city, 
	state (or province), and the country. 
	Use the full name for the state (province) and country -- not the 
	abbreviations (e.g., Alberta, Canada instead of AB, CA).
	Sort the results by country, then state (province), then city.  */

SELECT FirstName + ' ' + LastName AS "Sales person",
	City,
	Person.StateProvince.name AS "State/Province",
	Person.CountryRegion.name AS "Country/Region"
FROM Person.Person 
	LEFT OUTER JOIN Person.BusinessEntityAddress 
		ON Person.Person.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID
	LEFT OUTER JOIN Person.Address 
		ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID
	LEFT OUTER JOIN Person.StateProvince 
		ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
	LEFT OUTER JOIN Person.CountryRegion
		ON Person.CountryRegion.CountryRegionCode = Person.StateProvince.CountryRegionCode
WHERE PersonType = 'sp'
ORDER BY "Country/Region", "State/Province", City;

/* 
3.	A user wants to know which products (i.e., product numbers and names) have reviews. 
	This question can be answered in (at least) two ways: using a JOIN of the Product & 
	ProductReview tables, or using a subquery. It is similar to the first subquery example 
	from Thursday’s class (4/12) – in the Class Notes on subqueries.  */

     --a. Show the SELECT statement that answers the user’s question using a JOIN.

SELECT ProductNumber + ' ' + Name AS Product
FROM Production.Product AS pp INNER JOIN Production.ProductReview AS pr ON pp.ProductID = pr.ProductReviewID ON pp.ProductID = pr.ProductReviewID;
	 

     --b. Show the SELECT statement that answers the same question using a subquery. 

SELECT name, ProductNumber
FROM Production.Product 
WHERE productID IN (SELECT DISTINCT ProductID 
		      FROM Production.ProductReview);

/*
4.	Show the SQL statement to answer the following question:
	What products are located in the paint shop? List the shelf, bin, product name, 
	product number and quantity for every product in the paint shop location. 
	(Hint: 'Paint shop' is the name of a location in the Production.Location table.) */

SELECT Shelf, Bin, Production.Product.Name, ProductNumber
FROM Production.Product 
	INNER JOIN Production.ProductInventory
		ON Production.Product.ProductID = Production.ProductInventory.ProductID
	INNER JOIN Production.Location 
		ON Production.Location.LocationID = Production.ProductInventory.LocationID
WHERE Production.Location.Name LIKE '%paint shop%'
ORDER BY Shelf, Bin;


-- This is for a different table

USE GI_Animal;

/* This table is from a database that tracks livestock animals and their genealogy.
Note that there are two unary relationships on the Animal table, one for fathers and
one for mothers, and two corresponding FKs. Get familiar with the data by executing 
the following query: */

SELECT * FROM Animal;

/* 
5.	Show the SELECT statement that answers the following information request:
	List the IDs and names of the sheep who are fathers, along with
	the IDs and names of their offspring. Sort the results by father name. */

SELECT	p.AnimalID AS “FatherID”, p.AnimalName AS “Father Name”. c.AnimalID AS “OffSpring”, c.AnimalName AS “Offspring Name”
FROM Animal AS p JOIN Animal AS c ON p.AnimalID = c.FatherAnimalID
WHERE p.Breed LIKE ‘%sheep%’
ORDER BY “Father Name” ASC

	
/* 
6.	Show the SELECT statement that answers the following question:
	What is the name of Buck's mother?
	Note: You can answer this question with either a self-join or a subquery. */ 

SELECT p.AnimalName AS “Animal Name”
FROM Animal AS p JOIN Animal AS c ON p.AnimalID = c.MotherAnimalID
WHERE c.AnimalName = ‘Buck’

-- SUBQUERY

SELECT AnimalName AS Mother
FROM Animal 
WHERE AnimalID IN 
	(SELECT MotherAnimalID FROM Animal WHERE AnimalName = 'buck');


-- Who is Bob the father of?

SELECT child.AnimalName
FROM Animal AS parent INNER JOIN Animal AS child ON parent.AnimalID = child.FatherAnimalID
WHERE parent.AnimalName = ‘bob’;

-- SUBQUERY

SELECT AnimalName 
FROM Animal 
WHERE FatherAnimalID IN 
	(SELECT AnimalID FROM Animal WHERE AnimalName = ‘bob’);
