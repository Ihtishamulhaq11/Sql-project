-- STANDARIZING FIRST LEVEL
   -- removing duplicates(subquery)

   select * from actor;
    select distinct film_id, title,description
    from actor2;

   select  * from
        (select *,
        row_number() over(partition by film_id, title, description) as rwnmbr
        from film_text) as p
   where rwnmbr > 1;
    
    -- Another method of removing duplicates(cte)
    with duplicate_cte as
        (select *,
        row_number() over(partition by film_id, title, description) as rwnmbr
        from film_text) 
    select * from
    duplicate_cte
    where rwnmbr > 1;
    
    -- create copy of the table too remove duplicate since we can't update on cte or in subuery
    CREATE TABLE `actor2` (
        `actor_id` smallint unsigned NOT NULL AUTO_INCREMENT,
        `first_name` varchar(45) NOT NULL,
        `last_name` varchar(45) NOT NULL,
        `last_update` timestamp NOT NULL DEFAULT 
                    CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        `rwnmbr` int,                        -- included the column of row number
        PRIMARY KEY (`actor_id`),
        KEY `idx_actor_last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

    select * from actor2;
    
    -- insert values in the copy of the orignal table
    insert into actor2
        select *,
        row_number() over(partition by actor_id, first_name,last_name,last_update) as rwnmbr
    from actor;
    
     select * from actor2;
      
      -- deleting duplicates from the table
    delete from actor2
    where rwnmbr > 1;

  -- trimming the data

select distinct first_name , trim(first_name)
from actor2
order by 1;

 update actor2
 set first_name = trim(first_name);
 
select distinct last_name , trim(trailing '.' from  last_name)
from actor2
order by 1;

update actor2
   set last_name = trim(trailing '.' from last_name)
 where last_name like 'ALIEN%';
   
-- changing date time and craeting a right format

select last_update ,
str_to_date(last_update,'m%/d%/Y%')
from actor2;
  
ALTER table actor2
modify column last_update date;

select last_update 
from actor2;

 -- dealing with null and blank values
select * from actor2 
where first_name is null
or last_name is null;

delete from actor2
 where first_name is null
 or last_name is null;
 
select t1.first_name, t2.first_name
    from actor2 t1
    join actor2 t2
    on t1.actor_id = t2.actor_id
 where (t1.first_name is null or t1.first_name  = ' ')
    and t2.first_name is not null;
 
 update actor2 t1 
    join actor2 t2
    on t1.actor_id = t2.actor_id
    set t1.first_name = t2.first_name
 where (t1.first_name is null or t1.first_name  = ' ')
    and t2.first_name is not null;
 
 
 
 -- dropping column
alter table actor2
 drop column rwnmbr;

