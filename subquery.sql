create database subquery;
use subquery;
create table departments(
id int primary key auto_increment,
department_name varchar(50) not null,
location varchar(50),
budget int);
create table employees(
id int primary key auto_increment,
name varchar(50) not null,
department_id int,
salary int);
alter table employees add constraint fk_dept_id foreign key(id) references departments(id);



-- Insert departments
INSERT INTO departments (department_name, location, budget)
VALUES
('Human Resources', 'Kathmandu', 1200000),
('Finance', 'Pokhara', 1500000),
('IT', 'Biratnagar', 2000000),
('Marketing', 'Lalitpur', 1000000),
('Operations', 'Bhaktapur', 1300000),
('Sales', 'Dharan', 1100000),
('Logistics', 'Butwal', 900000),
('Research & Development', 'Chitwan', 2500000),
('Customer Support', 'Janakpur', 800000),
('Administration', 'Hetauda', 950000);

-- Insert employees
INSERT INTO employees (name, department_id, salary)
VALUES
('Arjun Shrestha', 1, 55000),
('Sita Rai', 2, 48000),
('Ramesh Koirala', 3, 60000),
('Mina Tamang', 4, 45000),
('Kamal Gurung', 5, 52000),
('Sunita Yadav', 6, 47000),
('Dipesh Maharjan', 7, 51000),
('Prakash Thapa', 8, 62000),
('Sarita Sharma', 9, 49000),
('Binod Adhikari', 10, 53000);

select name,salary from employees where salary=(select max(salary) from employees);
select name,salary from employees where salary>(select avg(salary) from employees);
select name,salary,(select avg(salary) from employees) as company_avg from employees;
select name,department_id,salary from employees where (department_id,salary)=(select department_id,salary from employees where name="Sita Rai");
select e.name
from employees e
where e.department_id in (
    select id
    from departments 
    where location = 'Kathmandu'
);

select name,department_id,salary from employees where(department_id,salary)=(select department_id,max(salary) from employees group by
department_id order by max(salary) desc limit 1);

select emp.name, 
       emp.salary, 
       dept.department_name
from (
    select name, salary, department_id
    from employees
    where salary > 50000
) as emp
join departments dept 
    on emp.department_id = dept.id;

select e1.name,e1.salary,e1.department_id from employees e1 
where e1.salary>(select avg(e2.salary)
from employees e2 where e2.department_id=e1.department_id);


create database lms_db;
use lms_db;
create table students(
student_id int primary key auto_increment,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
registration_date timestamp default current_timestamp,
country varchar(50));

create table instructors(
instructor_id int primary key auto_increment,
instructor_name varchar(100),
specialization varchar(100),
joining_date timestamp default current_timestamp);

create table courses(
course_id int auto_increment primary key,
course_name varchar(100),
category varchar(50),
course_fee decimal(10,2),
instructor_id int
);
alter table courses add constraint fk_inst_id foreign key(instructor_id) references instructors(instructor_id);

create table enrollments(
enrollment_id int auto_increment primary key,
student_id int,
course_id int,
enrollment_date timestamp default current_timestamp,
completion_status varchar(20));
drop table enrollments;
alter table enrollments add constraint fk_std_id foreign key(student_id) references students(student_id);
alter table enrollments add constraint fk_course_id foreign key(course_id) references courses(course_id);

create table assignments(
assignment_id int auto_increment primary key,
course_id int,
assignmnet_title varchar(100),
max_marks int,
due_date date
);
alter table assignments add constraint fk_crs_id foreign key(course_id) references courses(course_id);

create table assignment_submissions(
submission_id int auto_increment primary key,
assignment_id int,
student_id int,
marks_obtained int,
submission_date date);
alter table assignment_submissions add constraint fk_ass_id foreign key(assignment_id) references assignments(assignment_id);
alter table assignment_submissions add constraint fk_stddd_id foreign key(student_id) references students(student_id);

create table payments(payment_id int auto_increment primary key,
student_id int,
amount_paid decimal(10,2),
payment_date date,
payment_method varchar(20));
alter table payments add constraint fk_ste_id foreign key(student_id) references students(student_id);

insert into students(first_name,last_name,email,country) values
('suman','shrestha','suman.shrestha@gmail.com','nepal'),
('anita','gurung','anita.gurung@yahoo.com','nepal'),
('ramesh','thapa','ramesh.thapa@hotmail.com','nepal'),
('mina','koirala','mina.koirala@gmail.com','nepal'),
('prakash','rai','prakash.rai@gmail.com','nepal'),
('sarita','magar','sarita.magar@yahoo.com','nepal'),
('dipesh','kc','dipesh.kc@gmail.com','nepal'),
('kritika','lama','kritika.lama@gmail.com','nepal'),
('binod','poudel','binod.poudel@gmail.com','nepal'),
('shreya','shahi','shreya.shahi@gmail.com','nepal');

insert into instructors(instructor_name,specialization) values
('ram khadka','computer science'),
('sita basnet','mathematics'),
('hari shrestha','physics'),
('gita rai','english'),
('nabin gurung','economics'),
('saraswati lama','chemistry'),
('pratap magar','history'),
('manju poudel','biology'),
('sanjay kc','management'),
('sabina thapa','accounting');

insert into courses(course_name,category,course_fee,instructor_id) values
('python basics','programming',5000.00,1),
('advanced math','mathematics',6000.00,2),
('physics i','science',5500.00,3),
('english literature','arts',4000.00,4),
('microeconomics','economics',4500.00,5),
('organic chemistry','science',7000.00,6),
('world history','social science',3500.00,7),
('human biology','science',5000.00,8),
('project management','management',8000.00,9),
('financial accounting','commerce',6500.00,10);

insert into enrollments(student_id,course_id,completion_status) values
(1,1,'ongoing'),
(2,2,'completed'),
(3,3,'ongoing'),
(4,4,'completed'),
(5,5,'ongoing'),
(6,6,'ongoing'),
(7,7,'completed'),
(8,8,'ongoing'),
(9,9,'completed'),
(10,10,'ongoing');

insert into assignments(course_id,assignmnet_title,max_marks,due_date) values
(1,'intro project',100,'2026-07-01'),
(2,'algebra test',50,'2026-07-05'),
(3,'lab report',75,'2026-07-10'),
(4,'essay',100,'2026-07-15'),
(5,'case study',80,'2026-07-20'),
(6,'lab experiment',100,'2026-07-25'),
(7,'presentation',60,'2026-07-30'),
(8,'field report',70,'2026-08-05'),
(9,'group project',100,'2026-08-10'),
(10,'final exam',100,'2026-08-15');

insert into assignment_submissions(assignment_id,student_id,marks_obtained,submission_date) values
(1,1,90,'2026-07-01'),
(2,2,45,'2026-07-05'),
(3,3,70,'2026-07-10'),
(4,4,95,'2026-07-15'),
(5,5,75,'2026-07-20'),
(6,6,85,'2026-07-25'),
(7,7,55,'2026-07-30'),
(8,8,65,'2026-08-05'),
(9,9,92,'2026-08-10'),
(10,10,88,'2026-08-15');

insert into payments(student_id,amount_paid,payment_date,payment_method) values
(1,5000.00,'2026-06-01','cash'),
(2,6000.00,'2026-06-02','card'),
(3,5500.00,'2026-06-03','cash'),
(4,4000.00,'2026-06-04','card'),
(5,4500.00,'2026-06-05','cash'),
(6,7000.00,'2026-06-06','card'),
(7,3500.00,'2026-06-07','cash'),
(8,5000.00,'2026-06-08','card'),
(9,8000.00,'2026-06-09','cash'),
(10,6500.00,'2026-06-10','card');
use lms_db;
select concat(first_name," ",last_name) as name,amount_paid 
from students s join payments
p on s.student_id=p.student_id 
where amount_paid >(select avg(amount_paid) from payments);

select course_name,course_fee from courses where course_fee>(select avg(course_fee) from courses);

select instructor_name,specialization,course_fee 
from instructors i join
 courses c on i.instructor_id=c.instructor_id where course_fee=(select max(course_fee) from courses);
 
 select s.student_id,concat(first_name," ",last_name) as name,course_fee from students s join
 enrollments e on s.student_id=e.student_id 
 join courses c on c.course_id=e.course_id where course_fee=(select max(course_fee) from courses);
 
 select assignmnet_title,max_marks from assignments
 where max_marks>(select avg(max_marks) from assignments);
 
select s.student_id,
       CONCAT(s.first_name, " ", s.last_name) as student_name,
       COUNT(a.submission_id) as total_submissions
from students s
join assignment_submissions a on s.student_id = a.student_id
group by s.student_id, s.first_name, s.last_name;

 
 select * from assignment_Submissions;


select first_name from students where student_id in (select student_id from assignment_submissions);

select first_name from students where exists (select * from assignment_submissions);

select first_name as name from students where not exists (select 1 from assignment_submissions);

select first_name as name from students where student_id not in (select student_id from assignment_submissions);


select * from enrollments;

select course_name,c.course_id,enrollment_id from courses c join enrollments e 
on c.course_id=e.course_id where exists (select 1 from courses);

select c.course_name,c.course_id,enrollment_id from courses c join enrollments e 
on c.course_id=e.course_id where c.course_id in (select e.course_id from enrollments);

select course_name,c.course_id,enrollment_id from courses c join enrollments e 
on c.course_id=e.course_id where not exists (select 1 from courses);

select c.course_name,c.course_id,enrollment_id from courses c join enrollments e 
on c.course_id=e.course_id where c.course_id not in (select e.course_id from enrollments);

select * from courses;

select i.instructor_name from instructors i where 
not exists (select 1 from courses c where c.instructor_id=i.instructor_id);

select * from payments;

select concat(first_name," ",last_name) as name,amount_paid from students s 
join payments p on s.student_id=p.student_id 
where amount_paid>(select avg(amount_paid) from payments);
