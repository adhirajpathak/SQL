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

SELECT	FirstName + ' ' + LastName As "Vendor Contact"
FROM	Person.Person 
WHERE	PersonType = 'VC'
ORDER BY LastName, FirstName;

/*The first contact listed is Cathan Cook, it has 156 rows*/

/*
-- 1b. Execute the following query, which is the same as above except that I've
-- 	added middle name (a column that may have NULL values) to the SELECT clause. 
-- 	The results don't look right! What happened & why? */ 

SELECT	FirstName + ' ' + MiddleName + ' ' + LastName As "Vendor Contact"
FROM	Person.Person 
WHERE	PersonType = 'VC'
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

FROM 	Person.Person 
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
