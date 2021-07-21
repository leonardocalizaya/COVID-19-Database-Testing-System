select sitetester_username as username, 'Tester' as usertype from SITETESTER
union 
select labtech_username, 'LabTech' from LABTECH 
union
select admin_username, 'Admin' from ADMINISTRATOR
union
select student_username, 'Student' from STUDENT
where username = 'mrees785';

select * from STUDENT;

select student_username, 'Student' from STUDENT
where student_username = 'mrees785';