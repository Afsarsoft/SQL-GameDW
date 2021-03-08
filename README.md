# SQL-GameDW
A Sample Data Warehouse/OLAP for Game OLTP Sample. <br />

# Recommended Prerequisites
-https://github.com/Afsarsoft/SQL101 <br />
-https://github.com/Afsarsoft/SQL-AnimalShelter <br />
-https://github.com/Afsarsoft/SQL-DDW1 <br />
-https://github.com/Afsarsoft/SQL-DDW2 <br />
-https://github.com/Afsarsoft/SQL-Game <br />

# Manual Installation 
1- In a new or existing SQL DB or Azure SQL DB, from "Script1" folder, install script CreateSchema.sql <br />
2- From "SP" folder install all SPs (ignore any warnings) <br />
3- From "Script2" folder, run all scripts starting with 01_% to 02_% <br />
4- For SQL DB or Azure SQL DB, change connection "DW_Connection" according to your "DW" environment change connection "OLTP_Connection" according to your "OLTP" environment and Run SSIS package LoadGameDW <br />
Note: SSIS package LoadGameDW load data from "OLTP" environment to the "DW" environment.

# Automated Installation 
1- Create a folder "C:\GameDW" <br />
2- Copy folders "Script1", "Script2", "SP" in folder "C:\GameDW" <br /> 
3- For SQL DB or Azure SQL DB, change connection "DB_Connection" according to your environment and Run SSIS package BuildGameDW <br />
4- For SQL DB or Azure SQL DB, change connection "DW_Connection" according to your "DW" environment change connection "OLTP_Connection" according to your "OLTP" environment and Run SSIS package LoadGameDW <br />
Note: SSIS package LoadGameDW load data from "OLTP" environment to the "DW" environment.

