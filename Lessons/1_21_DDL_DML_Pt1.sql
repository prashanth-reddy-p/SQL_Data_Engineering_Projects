--.read Lessons/1_21_DDL_DML_Pt1.sql
use data_jobs;
drop database if exists jobs_mart;
create database if not exists jobs_mart;
use jobs_mart;
create schema if not exists jobs_mart.staging;


create table if not exists staging.preferred_roles(
    role_ID int primary key,
    role_name varchar(20)
);
insert into staging.preferred_roles (role_ID,role_name)
values
    (1, 'Data Engineer'),(2,'Senior Data Engineer');
insert into staging.preferred_roles (role_ID,role_name)
values
    (3, 'Software Engineer');


Alter table staging.preferred_roles
add column preferred_role boolean;

update staging.preferred_roles
set preferred_role=true
where role_ID in (1,2);

update staging.preferred_roles
set preferred_role=false
where role_ID =3;

alter table staging.preferred_roles
rename to priority_roles;


select * from staging.priority_roles;

alter table staging.priority_roles
rename column preferred_role to priority_lvl;

alter table staging.priority_roles
alter column priority_lvl type int;

update staging.priority_roles
set priority_lvl=3
where role_ID=3;