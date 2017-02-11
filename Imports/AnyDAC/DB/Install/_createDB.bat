rem Command file has 3 parameters:
rem   1) directory with SQL scripts.
rem   2) connection definition name.
rem   3) says whether need to install Northwind DB.
rem Following steps will be performed:
rem ú Creates the Northwind DB tables (droping them before, if they exist).
rem ú Pumps data from ASCII CSV files to Northwind tables.
rem ú Creates relations between Northwind DB tables.
rem ú Creates Northwind DB stored procedures and functions (stored proc. packages) if RDBMS supports them.
rem ú Creates AnyDAC QA tables.
rem ú Creates AnyDAC QA stored procedures and functions (stored proc. packages) if RDBMS supports them.

@echo off
cls

set adhome=..\..
if not exist %adhome%\History.txt goto :wrongdir
if "%1"=="" goto :wrongcall

set exec=%adhome%\TOOL\Executor
set pump=%adhome%\TOOL\Pump

set data=%adhome%\DB\Data
set sql=%adhome%\DB\SQL
set install=%adhome%\DB\Install
set North=%sql%\%1\Northwind
set QA=%sql%\%1\QA

set ConnDef=%2
set NorthObj=%3

if "%1"=="Access" (call :msaccess) else call :nomsaccess
goto :EOF

:msaccess
cscript %North%\tables.vbs "%data%"
%pump%\ADPump /N $(ADHOME)\DB\ADConnectionDefs.ini  /D %ConnDef% /P %data% Categories CustomerCustomerDemo CustomerDemographics Customers Employees EmployeeTerritories "Order Details" Orders Products Region Shippers Suppliers Territories
cscript %North%\relations.vbs "%data%"
cscript %QA%\tables.vbs "%data%"
goto :EOF

:nomsaccess
if "%NorthObj%"=="False" (call :QA) else call :Northwind
goto :EOF

rem Northwind --------------
:Northwind
%exec%\ADExecutor /E /I /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %North% tables
%pump%\ADPump /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %data% Categories CustomerCustomerDemo CustomerDemographics Customers Employees EmployeeTerritories "Order Details" Orders Products Region Shippers Suppliers Territories
%exec%\ADExecutor /E /I /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %North% relations 
if exist %North%\procedures.sql %exec%\ADExecutor /E /I /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %North% procedures

rem QA ---------------------
:QA
%exec%\ADExecutor /E /I /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %QA% tables
if exist %QA%\procedures.sql %exec%\ADExecutor /E /I /N $(ADHOME)\DB\ADConnectionDefs.ini /D %ConnDef% /P %QA% procedures
goto :EOF

:wrongdir
echo To run this script $(ADHOME)\DB\Install directory must be current.
goto :EOF

:wrongcall
echo _createDB.bat script cannot be called directly.
goto :EOF
