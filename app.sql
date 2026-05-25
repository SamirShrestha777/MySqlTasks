create database task67;
use task67;
create table users(
user_id int auto_increment primary key,
username varchar(50) not null,
user_password varchar(67) not null,
user_role enum("Student","Teacher","Normal") default "Student"
);
drop table users;
create table notices(
notice_id int auto_increment primary key,
title varchar(100) not null,
content text not null,
created_by varchar(100) not null,
created_at timestamp default current_timestamp
);

delimiter $$
create procedure registeruser(in name varchar(50),in password varchar(50),in role varchar(50) )
begin
declare exit handler for sqlexception
begin
select "Please insert correct values" as error;
end;
insert into users(username,user_password,user_role) values(name,password,role);
end $$
delimiter ;
call registeruser("Sulav Thapa","6767","Student");

delimiter $$

create procedure userlogin(
 in uname varchar(50),
 in psw varchar(50)
)
begin
 declare exit handler for sqlexception
 begin
  select 'error' as status;
 end;
 if exists(select * from users where username=uname and user_password=psw) then
  select * from users where username=uname and user_password=psw limit 1;
 else
  select 'invalid' as status;
 end if;
end $$
delimiter ;
call userlogin("Samir Shrestha","6767");

delimiter $$
create procedure checkpermission(in uname varchar(50))
begin
    declare userrole enum('Student','Teacher','Normal');
    declare msg varchar(100);

    declare exit handler for sqlexception
    begin
        set msg = 'error: unable to check permission';
        select msg as result;
    end;

    select user_role into userrole
    from users
    where username = uname
    limit 1;

    if userrole is null then
        set msg = concat('access denied: user ', uname, ' not found');
        select msg as result;
    elseif userrole = 'Teacher' then
        set msg = 'permission granted: user is a teacher';
        select msg as result;
    else
        set msg = concat('access denied: user ', uname, ' is not a teacher');
        select msg as result;
    end if;
end $$
delimiter ;

drop procedure checkpermission;
delimiter $$
select * from notices;
create procedure viewnotices(in uname varchar(50))
begin
    declare userrole enum('Student','Teacher','Normal');
    declare msg varchar(200);

    declare exit handler for sqlexception
    begin
        set msg = 'error: unable to view';
        select msg as result;
    end;

    select user_role into userrole
    from users
    where username = uname
    limit 1;

    if userrole is null then
        set msg = concat('access denied: user ', uname, ' not found');
        select msg as result;
    elseif userrole = 'Teacher' or userrole="Student" then
    set msg = 'notice created successfully';
        select msg as result;
        select * from notices;
        
    else
        set msg = concat('access denied: user ', uname, ' is not a student or teacher');
        select msg as result;
    end if;
end $$

delimiter ;
call viewnotices("Samir Shrestha");




call updatenotice("Samir Shrestha","Rajiv The Dawg","Rajiv is a dogg",1);
delimiter $$
drop procedure updatenotice;
create procedure createnotice(in uname varchar(50), in ntitle varchar(100), in ncontent text)
begin
    declare userrole enum('Student','Teacher','Normal');
    declare msg varchar(200);

    declare exit handler for sqlexception
    begin
        set msg = 'error: unable to create notice';
        select msg as result;
    end;

    select user_role into userrole
    from users
    where username = uname
    limit 1;

    if userrole is null then
        set msg = concat('access denied: user ', uname, ' not found');
        select msg as result;
    elseif userrole = 'Teacher' then
        insert into notices(title, content, created_by)
        values(ntitle, ncontent, uname);
        set msg = 'notice created successfully';
        select msg as result;
    else
        set msg = concat('access denied: user ', uname, ' is not a teacher');
        select msg as result;
    end if;
end $$

delimiter ;
call createnotice("Samir Shrestha","Harry Potter","Harry is a wizard");

delimiter $$

create procedure updatenotice(in uname varchar(50), in ntitle varchar(100), in ncontent text,in nt_id int)
begin
    declare userrole enum('Student','Teacher','Normal');
    declare msg varchar(200);

    declare exit handler for sqlexception
    begin
        set msg = 'error: unable to update notice';
        select msg as result;
    end;

    select user_role into userrole
    from users
    where username = uname
    limit 1;

    if userrole is null then
        set msg = concat('access denied: user ', uname, ' not found');
        select msg as result;
    elseif userrole = 'Teacher' then
        update  notices set title=ntitle,content=ncontent where notice_id=nt_id;
        set msg = 'table updated successfully';
        select msg as result;
    else
        set msg = concat('access denied: user ', uname, ' is not a teacher');
        select msg as result;
    end if;
end $$
delimiter ;

delimiter $$

create procedure deletenotice(in uname varchar(50),in nt_id int)
begin
    declare userrole enum('Student','Teacher','Normal');
    declare msg varchar(200);

    declare exit handler for sqlexception
    begin
        set msg = 'error: unable to delete notice';
        select msg as result;
    end;

    select user_role into userrole
    from users
    where username = uname
    limit 1;

    if userrole is null then
        set msg = concat('access denied: user ', uname, ' not found');
        select msg as result;
    elseif userrole = 'Teacher' then
        delete from  notices where notice_id=nt_id;
        set msg = 'deleted data successfully';
        select msg as result;
    else
        set msg = concat('access denied: user ', uname, ' is not a teacher');
        select msg as result;
    end if;
end $$
delimiter ;
call deletenotice("Samir Shrestha","1");
select * from notices;
