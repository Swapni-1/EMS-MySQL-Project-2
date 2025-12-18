#--------EMPLOYEE MANAGEMENT SYSTEM------------

#Creating database for employee management system
create database if not exists Employee_Management;

#Use Employee_Management Database
use Employee_Management;

#Creating tables for employee management system

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
    HireData DATE not null,

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
    StartDate Date not null
);

#Employee Project Table
create table EmplolyeeProject(
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