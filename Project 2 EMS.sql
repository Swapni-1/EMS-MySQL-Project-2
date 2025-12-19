#--------EMPLOYEE MANAGEMENT SYSTEM------------

#####Creating database for employee management system####
create database if not exists Employee_Management;

####Use Employee_Management Database####
use Employee_Management;

######Creating tables for employee management system#####

#Department Table
create table Department(
    DepartmentID int auto_increment primary key,
    DepartmentName varchar(100) not null unique
);

#Role Table
create table Role(
    RoleID int auto_increment primary key,
    RoleName varchar(100) not null unique
);

#Employee Table
create table Employee(
    EmployeeID int auto_increment primary key,
    FirstName varchar(100) not null,
    LastName varchar(100) not null,
    DepartmentID int not null,
    RoleID int not null,
    HireDate DATE not null,

    constraint fk_employee_department
    foreign key (DepartmentID) references Department(DepartmentID)
    on delete restrict on update cascade,

    constraint fk_employee_role
    foreign key (RoleID) references Role(RoleID)
    on delete restrict on update cascade
);

#Project Table
create table Project(
    ProjectID int auto_increment primary key,
    ProjectName varchar(100) not null,
    Status Enum('Ongoing','Completed','On Hold') not null,
    StartDate Date not null,
    ExpectedEndDate Date
);

#Employee Project Table
create table EmployeeProject(
    EmployeeID int not null,
    ProjectID int not null,
    RoleInProject varchar(100) not null,

    constraint fk_EmployeeProject_Employee
    foreign key (EmployeeID) references Employee(EmployeeId)
    on delete cascade on update cascade,

    constraint fk_EmployeeProject_Project
    foreign key (ProjectID) references Project(ProjectID)
    on delete cascade on update cascade
);

#Attendance Table
create table Attendance(
    AttendanceID int auto_increment primary key,
    EmployeeID int not null,
    Date DATE not null,
    CheckInTime TIME,
    CheckOutTime TIME,
    status Enum('Present','Absent','Leave') not null,

    constraint fk_Attendance_Employee
    foreign key (EmployeeID) references Employee(EmployeeID)
    on delete cascade on update cascade,

    unique(EmployeeID,Date)
);

#Payroll Table
create table Payroll(
    PayrollID int auto_increment primary key,
    EmployeeID int not null,
    BaseSalary DECIMAL(10,2) default 0.00,
    Bonuses Decimal(10,2) default 0.00,
    Deductions Decimal(10,2) default 0.00,
    NetPay Decimal(10,2)
        GENERATED ALWAYS AS (BaseSalary + Bonuses - Deductions) Stored,

    constraint fk_Payroll_Employee
    foreign key (EmployeeID) references Employee(EmployeeID)
    on delete cascade on update cascade
);

########Inserting Sample data for employee_management tables###########

#inserting data into department table
INSERT INTO Department (DepartmentName) VALUES
('HR'),
('Engineering'),
('Marketing'),
('Finance'),
('Operations');

#inserting data into role table
INSERT INTO Role (RoleName) VALUES
('Software Engineer'),
('Senior Software Engineer'),
('HR Manager'),
('Marketing Executive'),
('Accountant'),
('Project Manager');

#inserting data into employee table
INSERT INTO Employee (FirstName, LastName, DepartmentID, RoleID, HireDate) VALUES
('Amit', 'Sharma', 2, 1, '2022-03-15'),
('Neha', 'Verma', 2, 2, '2021-06-10'),
('Rahul', 'Mehta', 1, 3, '2020-01-20'),
('Priya', 'Singh', 3, 4, '2022-09-05'),
('Karan', 'Patel', 4, 5, '2019-11-12'),
('Sneha', 'Iyer', 2, 6, '2023-02-01'),
('Arjun', 'Rao', 5, 1, '2023-07-18');

#inserting data into project table
INSERT INTO Project (ProjectName, Status, StartDate, ExpectedEndDate) VALUES
('Employee Management System', 'Ongoing', '2023-01-10', '2024-06-30'),
('Marketing Automation Tool', 'Ongoing', '2023-05-01', '2024-03-31'),
('Payroll Optimization', 'Completed', '2022-08-15', '2023-01-31'),
('Customer Analytics Platform', 'On Hold', '2023-03-20', '2024-09-30');


#inserting data into employee project
INSERT INTO EmployeeProject (EmployeeID, ProjectID, RoleInProject) VALUES
(1, 1, 'Backend Developer'),
(2, 1, 'Tech Lead'),
(6, 1, 'Project Manager'),
(4, 2, 'Marketing Analyst'),
(3, 3, 'HR Consultant'),
(5, 3, 'Finance Lead'),
(1, 4, 'Support Developer'),
(7, 2, 'Operations Support');

#inserting data into attendance table
INSERT INTO Attendance (EmployeeID, Date, CheckInTime, CheckOutTime, Status) VALUES
(1, '2024-02-01', '09:05:00', '18:00:00', 'Present'),
(2, '2024-02-01', '09:00:00', '18:30:00', 'Present'),
(3, '2024-02-01', NULL, NULL, 'Absent'),
(4, '2024-02-01', '09:15:00', '17:45:00', 'Present'),
(5, '2024-02-01', '09:10:00', '18:10:00', 'Present'),
(1, '2024-02-02', '09:00:00', '18:00:00', 'Present'),
(3, '2024-02-02', NULL, NULL, 'Leave');

#inserting data into payroll table
INSERT INTO Payroll (EmployeeID, BaseSalary, Bonuses, Deductions) VALUES
(1, 60000.00, 5000.00, 2000.00),
(2, 90000.00, 10000.00, 5000.00),
(3, 70000.00, 0.00, 3000.00),
(4, 50000.00, 3000.00, 1000.00),
(5, 80000.00, 7000.00, 4000.00),
(6, 100000.00, 15000.00, 8000.00),
(7, 55000.00, 2000.00, 1500.00);

#----------Running SQL Query for Employee Management System----------

/* 1. Identify High-Performing Employees
"Management wants to know which employees have worked on more than three active
projects (Status = 'Ongoing'). Write a query to list the names of these employees with
project name."*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {EmployeeProject : [EmployeeID],[ProjectID]} -> {Project : [ProjectID],[ProjectName],[Status]}

/*
2. Monitor Employee Attendance
"Generate a report of employees who were marked 'Absent' more than three times in the
last month. Include their names and the total number of absences with absence dates."
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Attendance : [EmployeeID],[Date],[Status]}

/*
3. Department Salary Analysis
"Provide a report that shows the total and average salary (NetPay) for employees in each
department. Include department names in your results."
*/

#{Payroll : [EmployeeID],[NetPay]} -> {Employee : [EmployeeID],[DepartmentID]} -> {Department : [DepartmentID],[DepartmentName]}

/*
4. Employee Without Projects
"Find employees who are not currently assigned to any project. Display their names,
department names, and roles."
*/

#{Employee : [EmployeeID],[RoleID],[FirstName],[LastName]} -> {EmployeeProject : [EmployeeID],[ProjectID]} -> {Department : [EmployeeID],[DepartmentID],[DepartmentName]} -> {Role : [RoleID],[RoleName]}

/*
5. Project Assignment Role
"Retrieve a list of employees assigned to a project named 'Tech Upgrade' and their roles in
the project. Ensure the project is still ongoing."
*/

# {Employee : [EmployeeID],[FirstName],[LastName]} -> {EmployeeProject : [EmployeeID],[ProjectID],[RoleInProject]} -> {Project : [ProjectID],[ProjectName],[Status]}

/*
6. Payroll Verification
"Identify employees whose net pay (NetPay) is less than 60% of their base salary
(BaseSalary). Display their names and corresponding percentages. Result should for
selected month"
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Payroll : [EmployeeID],[BaseSalary],[NetPay]}

/*
7. Department Hire Dates
"Find the earliest hire date of employees in each department and the names of employees
hired on those dates."
*/

#{Employee : [EmployeeID],[FirstName],[LastName],[HireDate]} -> {Department : [EmployeeID],[DepartmentID],[DepartmentName]}

/*
8. Long Working Hours
"Create a report of employees who worked more than 10 hours on any given day last
month. Include their names, the date, and total hours worked."
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Attendance : [EmployeeID],[Date],[Status],[CheckInTime],[CheckOutTIme]}

/*
9. Department Leaders
"Display the names of department managers (employees whose RoleID corresponds to
'Manager') along with their department names."
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Role : [RoleID],[RoleName]} -> {Department : [DepartmentID],[DepartmentName]}


/*
10. Salary Increment Plan
"Management wants to give a 10% salary increment to all employees hired before 2020.
Write a query to update the BaseSalary in the Payroll table and list the updated
salaries."
*/

#{Employee : [EmployeeID],[FirstName],[LastName],[HireDate]} -> [Payroll : [EmployeeID],[BaseSalary]]


#---------------Additional SQL Challenges---------------

/*
1. Employee Experience Report: Find the total experience (in years) of all employees
grouped by department. Include department names and average employee experience.
*/

#{Employee : [EmployeeID],[FirstName],[LastName],[HireDate]} -> {Department : [DepartmentID],[EmployeeID],[DepartmentName]}

/*
2. Project Status Overview: Write a query to count the number of projects in each status
(e.g., Ongoing, Completed, Pending).
*/

#{Project ,[Status]}

/*
3. Late Check-In Report: Identify employees who checked in late (after 9:00 AM) more
than 5 times in the past month. Display their names and the dates they were late.
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Attendance : [EmployeeID],[CheckInTime]}

/*
4. Inactive Employees: Find employees who have not checked in or checked out in the
last 3 months. List their names and departments.
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Attendance : [EmployeeID],[CheckInTime][CheckOutTime]}

/*
5. Employee Role Statistics: Write a query to calculate the number of employees in each
role and display it alongside the role names.
*/

/*
6. Overdue Projects: List all projects that are overdue based on their expected
completion date. Include project names, current status, and the number of overdue
days.
*/
#{Project : [ProjectName],[Status],[ExpectedEndDate]}

/*
7. Employee Attendance Patterns: Identify employees with consistent attendance (e.g.,
marked 'Present' for more than 90% of working days in the past month). Include their
names and attendance percentages.
*/

#{Employee : [EmployeeID],[FirstName],[LastName]} -> {Attendance : [EmployeeID],[Date],[Status]}

/*
8. Highest Paid Employees: Retrieve the top 5 highest-paid employees in the
organization along with their departments and roles.
*/

#{Payroll : [EmployeeID],[NetPay]} -> {Employee : [EmployeeID],[FirstName],[LastName]} -> {Department : [DepartmentID],[DepartmentName]} -> {Role : [RoleId],[RoleName]}

/*
9. Cross-Department Projects: Identify projects that involve employees from more than
3 different departments. List the project names and involved department counts.
*/

#{Project : [ProjectID],[ProjectName]} -> {EmployeeProject : [EmployeeID],[ProjectID]} -> {Employee : [EmployeeID]}