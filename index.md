John Lor

Assignment07

Foundations of Databases

Dec 2, 2020

# Functions

## Introduction
Functions are incredibly powerful tools to save time and keystrokes when using SQL. There are predefined functions that do common tasks such as returning sums or applying formatting. However, users can also define their own functions for other specific use-cases. In this paper we will examine the user-defined functions as well as define the categories of functions.

## User-Defined Functions
SQL has many built-in functions that take a parameter and return a value or set of values. These functions save time by performing a useful calculation, negating the need for lengthy code or calculating by hand. However, the developers cannot realistically capture all possible use-cases. Therefore they allow the users to create user-defined functions. For example, in the assignment we created a function to return all data with the key performance indicator specified. It was run three times for each possible KPI.


## Scalar, Inline, and Multi-Statement Functions
There are different types of functions that we can invoke in SQL. See the breakdown below
Scalar functions return a single value
Inline functions return a table where the format of the table is defined by the SELECT statement
Multi-statement functions also returns a table but the user defines the columns and their data types as well as what rows to add

## Conclusion
As stated above, the essence of a function is to save an action to save time. Using various functions, we can define a set of actions that takes a set of parameters and outputs useful information--without the need to type it out every time.
