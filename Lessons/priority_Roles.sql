Create or replace table staging.priority_roles(
    role_id Integer primary key,
    role_name varchar(30),
    priority_lvl int,
);

insert into staging.priority_roles(role_id,role_name, priority_lvl) 
values (1, 'Data Engineer',1),
(2,'Senior Data Engineer',2),
(3,'Software Engineer',3),
(4,'Data Scientist',2),
(5,'Data Analyst',1);


select * from staging.priority_roles;