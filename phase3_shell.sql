/*
CS4400: Introduction to Database Systems
Fall 2020
Phase III Template

Team 114
Ethan Svitak (esvitak3)
Kira O’Hare (kohare6)
Mary Jiang (mjiang48)
Leonardo Calizaya (lquispe3)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/


-- ID: 2a
-- Author: lvossler3
-- Name: register_student
DROP PROCEDURE IF EXISTS register_student;
DELIMITER //
CREATE PROCEDURE register_student(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_location VARCHAR(40),
        IN i_housing_type VARCHAR(20),
        IN i_password VARCHAR(40)
)
sp_main: BEGIN

-- Type solution below

IF EXISTS ((SELECT username FROM USER WHERE username = i_username)) OR EXISTS(SELECT * FROM USER WHERE lname = i_lname AND fname = i_fname)
THEN LEAVE sp_main; END IF;

INSERT INTO USER VALUES 
(i_username,MD5(i_password),i_email,i_fname,i_lname);

INSERT INTO STUDENT VALUES
(i_username, i_housing_type, i_location);

-- End of solution

END //
DELIMITER ;

-- ID: 2b
-- Author: lvossler3
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_phone VARCHAR(10),
        IN i_labtech BOOLEAN,
        IN i_sitetester BOOLEAN,
        IN i_password VARCHAR(40)
)
sp_main: BEGIN

-- Type solution below

IF EXISTS (SELECT * FROM user WHERE username = i_username)
THEN LEAVE sp_main; END IF;

INSERT INTO user VALUES
(i_username, MD5(i_password), i_email, i_fname, i_lname);

INSERT INTO employee VALUES
(i_username, i_phone);

IF i_labtech = TRUE
THEN
	INSERT INTO labtech VALUES
    (i_username);
END IF;

IF i_sitetester = TRUE
THEN
	INSERT INTO sitetester VALUES
    (i_username);
END IF;

-- End of solution

END //
DELIMITER ;

-- ID: 4a
-- Author: Aviva Smith
-- Name: student_view_results
DROP PROCEDURE IF EXISTS `student_view_results`;
DELIMITER //
CREATE PROCEDURE `student_view_results`(
    IN i_student_username VARCHAR(50),
	IN i_test_status VARCHAR(50),
	IN i_start_date DATE,
    IN i_end_date DATE
)
BEGIN
	DROP TABLE IF EXISTS student_view_results_result;
    CREATE TABLE student_view_results_result(
        test_id VARCHAR(7),
        timeslot_date date,
        date_processed date,
        pool_status VARCHAR(40),
        test_status VARCHAR(40)
    );
    INSERT INTO student_view_results_result

    -- Type solution below

	SELECT t.test_id, t.appt_date, p.process_date, p.pool_status , t.test_status
        FROM Appointment a
            LEFT JOIN Test t
                ON t.appt_date = a.appt_date
                AND t.appt_time = a.appt_time
                AND t.appt_site = a.site_name
            LEFT JOIN Pool p
                ON t.pool_id = p.pool_id
        WHERE i_student_username = a.username
            AND (i_test_status = t.test_status OR i_test_status IS NULL)
            AND (i_start_date <= t.appt_date OR i_start_date IS NULL)
            AND (i_end_date >= t.appt_date OR i_end_date IS NULL);

    -- End of solution
END //
DELIMITER ;

-- ID: 5a
-- Author: asmith457
-- Name: explore_results
DROP PROCEDURE IF EXISTS explore_results;
DELIMITER $$
CREATE PROCEDURE explore_results (
    IN i_test_id VARCHAR(7))
BEGIN
    DROP TABLE IF EXISTS explore_results_result;
    CREATE TABLE explore_results_result(
        test_id VARCHAR(7),
        test_date date,
        timeslot time,
        testing_location VARCHAR(40),
        date_processed date,
        pooled_result VARCHAR(40),
        individual_result VARCHAR(40),
        processed_by VARCHAR(80)
    );
    INSERT INTO explore_results_result

    -- Type solution below

SELECT test_id, appt_date, appt_time, appt_site, process_date, pool_status, test_status, CONCAT(fname, " ", lname)
FROM (test join pool on test.pool_id = pool.pool_id) join user on processed_by = username
WHERE test_id = i_test_id;

-- End of solution

END$$
DELIMITER ;

-- ID: 6a
-- Author: asmith457
-- Name: aggregate_results
DROP PROCEDURE IF EXISTS aggregate_results;
DELIMITER $$
CREATE PROCEDURE aggregate_results(
    IN i_location VARCHAR(50),
    IN i_housing VARCHAR(50),
    IN i_testing_site VARCHAR(50),
    IN i_start_date DATE,
    IN i_end_date DATE)
BEGIN
    DROP TABLE IF EXISTS aggregate_results_result;
    CREATE TABLE aggregate_results_result(
        test_status VARCHAR(40),
        num_of_test INT,
        percentage DECIMAL(6,2)
    );

    INSERT INTO aggregate_results_result

    -- Type solution below

SELECT test_status, COUNT(*) AS num_of_test, ROUND(COUNT(*)/t.num * 100,2) AS percentage
FROM ((test JOIN site ON appt_site = site_name)
JOIN appointment ON
(test.appt_site = appointment.site_name
AND test.appt_date = appointment.appt_date
AND test.appt_time = appointment.appt_time))
JOIN student ON student_username = username
CROSS JOIN
(
	SELECT COUNT(*) AS num
	FROM ((test JOIN site ON appt_site = site_name)
	JOIN appointment ON
	(test.appt_site = appointment.site_name
	AND test.appt_date = appointment.appt_date
	AND test.appt_time = appointment.appt_time))
	JOIN student ON student_username = username
	WHERE
	(i_location IS NULL OR student.location LIKE i_location) AND
	(i_housing IS NULL OR housing_type LIKE i_housing) AND
	(i_testing_site IS NULL OR site.site_name LIKE i_testing_site) AND
	(i_start_date IS NULL OR test.appt_date >= i_start_date) AND
	(i_end_date IS NULL OR test.appt_date <= i_end_date)
) t
WHERE
(i_location IS NULL OR student.location LIKE i_location) AND
(i_housing IS NULL OR housing_type LIKE i_housing) AND
(i_testing_site IS NULL OR site.site_name LIKE i_testing_site) AND
(i_start_date IS NULL OR test.appt_date >= i_start_date) AND
(i_end_date IS NULL OR test.appt_date <= i_end_date)
GROUP BY test_status;

-- End of solution

END$$
DELIMITER ;


-- ID: 7a
-- Author: lvossler3
-- Name: test_sign_up_filter
DROP PROCEDURE IF EXISTS test_sign_up_filter;
DELIMITER //
CREATE PROCEDURE test_sign_up_filter(
    IN i_username VARCHAR(40),
    IN i_testing_site VARCHAR(40),
    IN i_start_date date,
    IN i_end_date date,
    IN i_start_time time,
    IN i_end_time time)
BEGIN
    DROP TABLE IF EXISTS test_sign_up_filter_result;
    CREATE TABLE test_sign_up_filter_result(
        appt_date date,
        appt_time time,
        street VARCHAR (40),
        city VARCHAR(40),
        state VARCHAR(2),
        zip VARCHAR(5),
        site_name VARCHAR(40));

    -- Type solution below

    INSERT INTO test_sign_up_filter_result
    SELECT a.appt_date, a.appt_time, s.street, s.city, s.state, s.zip, s.site_name
    FROM SITE as s JOIN (SELECT site_name, appt_date, appt_time 
    FROM APPOINTMENT
    WHERE username IS NULL AND (i_testing_site IS NULL OR site_name = i_testing_site) AND
    site_name in (SELECT site_name FROM SITE WHERE location in (SELECT location FROM STUDENT WHERE student_username = i_username)) AND
    (i_start_date IS NULL OR appt_date >= i_start_date) AND
    (i_end_date IS NULL OR appt_date <= i_end_date) AND
    (i_start_time IS NULL OR appt_time >= i_start_time) AND
    (i_end_time IS NULL OR appt_time <= i_end_time)) as a ON s.site_name = a.site_name;
    
    SELECT appt_date, appt_time, street, city, state, zip, site_name  FROM test_sign_up_filter_result;


    -- End of solution

    END //
    DELIMITER ;

-- ID: 7b
-- Author: lvossler3
-- Name: test_sign_up
DROP PROCEDURE IF EXISTS test_sign_up;
DELIMITER //
CREATE PROCEDURE test_sign_up(
		IN i_username VARCHAR(40),
        IN i_site_name VARCHAR(40),
        IN i_appt_date date,
        IN i_appt_time time,
        IN i_test_id VARCHAR(7)
)
sp_main: BEGIN
-- Type solution below
	if (select username from appointment
		where site_name = i_site_name
		and (appt_date = i_appt_date)
		and (appt_time = i_appt_time)) is not null
	or (select exists (select a.username, t.test_status
		from appointment a
			left join test t
				on t.appt_site = a.site_name
                and t.appt_date = a.appt_date
                and t.appt_time = a.appt_time
		where a.username = i_username
        and (t.test_status = 'pending')))
	then leave sp_main; end if;
    
    update appointment
		set username = i_username
		where site_name = i_site_name and
			appt_date = i_appt_date and
            appt_time = i_appt_time;
	
    insert into test 
    values(i_test_id, 'pending', null, i_site_name, i_appt_date, i_appt_time);

-- End of solution
END //
DELIMITER ;


-- Number: 8a
-- Author: lvossler3
-- Name: tests_processed
DROP PROCEDURE IF EXISTS tests_processed;
DELIMITER //
CREATE PROCEDURE tests_processed(
    IN i_start_date date,
    IN i_end_date date,
    IN i_test_status VARCHAR(10),
    IN i_lab_tech_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tests_processed_result;
    CREATE TABLE tests_processed_result(
        test_id VARCHAR(7),
        pool_id VARCHAR(10),
        test_date date,
        process_date date,
        test_status VARCHAR(10) );
    INSERT INTO tests_processed_result
    -- Type solution below
            
            select t.test_id, p.pool_id, t.appt_date as test_date, p.process_date as process_date, t.test_status
        from pool p
			left join test t
				on t.pool_id = p.pool_id
		where (p.processed_by = i_lab_tech_username)
			and (t.appt_date >= i_start_date or i_start_date is null)
            and (t.appt_date <= i_end_date or i_end_date is null)
            and (t.test_status = i_test_status or i_test_status is null);

    -- End of solution
END //
DELIMITER ;

-- ID: 9a
-- Author: ahatcher8@
-- Name: view_pools
DROP PROCEDURE IF EXISTS view_pools;
DELIMITER //
CREATE PROCEDURE view_pools(
    IN i_begin_process_date DATE,
    IN i_end_process_date DATE,
    IN i_pool_status VARCHAR(20),
    IN i_processed_by VARCHAR(40)
)
BEGIN
    DROP TABLE IF EXISTS view_pools_result;
    CREATE TABLE view_pools_result(
        pool_id VARCHAR(10),
        test_ids VARCHAR(100),
        date_processed DATE,
        processed_by VARCHAR(40),
        pool_status VARCHAR(20));

-- Type solution below

INSERT INTO view_pools_result
SELECT p.pool_id, g.test_ids, p.process_date, p.processed_by, p.pool_status
FROM (SELECT pool_id, GROUP_CONCAT(test_id) AS test_ids from TEST GROUP BY pool_id) as g JOIN
	(SELECT *
	FROM POOL
	WHERE (i_begin_process_date IS NULL OR ((process_date >= i_begin_process_date) OR (process_date IS NULL))) AND
	(i_end_process_date IS NULL OR process_date <= i_end_process_date) AND
	(i_pool_status IS NULL OR pool_status = i_pool_status) AND
	(i_processed_by IS NULL OR (processed_by LIKE CONCAT('%',i_processed_by,'%')))) as p 
    ON g.pool_id = p.pool_id;

SELECT pool_id, test_ids, date_processed, processed_by, pool_status
FROM view_pools_result;

-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: ahatcher8@
-- Name: create_pool
DROP PROCEDURE IF EXISTS create_pool;
DELIMITER //
CREATE PROCEDURE create_pool(
	IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
sp_main: BEGIN
-- Type solution below

	 if ((select pool_id from TEST where not isnull(pool_id) and test_id = i_test_id)) 
		or (select not exists (select * from TEST where test_id = i_test_id))
			then leave sp_main; end if;
	
			-- insert new pool
			insert into POOL (pool_id, pool_status, process_date, processed_by) values (i_pool_id, "pending", NULL, NULL);
			
			-- update test's pool id
			update TEST
			set pool_id = i_pool_id
			where test_id = i_test_id;


-- End of solution
END //
DELIMITER ;

-- ID: 10b
-- Author: ahatcher8@
-- Name: assign_test_to_pool
DROP PROCEDURE IF EXISTS assign_test_to_pool;
DELIMITER //
CREATE PROCEDURE assign_test_to_pool(
    IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
sp_main: BEGIN

-- Type solution below

IF (NOT EXISTS (SELECT * FROM test WHERE test_id = i_test_id) OR (NOT EXISTS (SELECT * FROM pool WHERE pool_id = i_pool_id)))
	THEN LEAVE sp_main; END IF;

SELECT pool_id
INTO @poolCheck
FROM test
WHERE test_id = i_test_id;

IF (@poolCheck IS NOT NULL)
	THEN LEAVE sp_main; END IF;

SELECT COUNT(*)
INTO @testCount
FROM test
WHERE pool_id = i_pool_id;

IF (@testCount < 7)
THEN
	UPDATE test
	SET pool_id = i_pool_id
	WHERE test_id = i_test_id;
END IF;

-- End of solution

END //
DELIMITER ;

-- ID: 11a
-- Author: ahatcher8@
-- Name: process_pool
DROP PROCEDURE IF EXISTS process_pool;
DELIMITER //

CREATE PROCEDURE process_pool(
    IN i_pool_id VARCHAR(10),
    IN i_pool_status VARCHAR(20),
    IN i_process_date DATE,
    IN i_processed_by VARCHAR(40)
)
BEGIN
-- Type solution below

    SELECT pool_status
    INTO @curr_status
    FROM POOL
    WHERE pool_id = i_pool_id;

    IF
        ((@curr_status = 'pending') AND (i_pool_status = 'positive' OR i_pool_status = 'negative'))
    THEN
        UPDATE POOL
        SET pool_status = i_pool_status, process_date = i_process_date, processed_by = i_processed_by
        WHERE pool_id = i_pool_id;
    END IF;


-- End of solution
END //
DELIMITER ;


-- ID: 11b
-- Author: ahatcher8@
-- Name: process_test
DROP PROCEDURE IF EXISTS process_test;
DELIMITER //
CREATE PROCEDURE process_test(
    IN i_test_id VARCHAR(7),
    IN i_test_status VARCHAR(20)
)
BEGIN
-- Type solution below
    
	SELECT test_status
    INTO @test_status
    FROM test
    WHERE test_id = i_test_id;
    
    SELECT pool_id
    INTO @pool_id
    FROM test
    WHERE test_id = i_test_id;
    
    select pool_status
    into @pool_status
    from pool
    where pool_id = @pool_id;


    IF
        ((@test_status = 'pending') AND (i_test_status = 'positive' OR i_test_status = 'negative')
        and (@pool_status = 'positive'))
    THEN
        UPDATE test
        SET test_status = i_test_status
        WHERE test_id = i_test_id;
    END IF;
    
    IF
        ((@test_status = 'pending') AND (i_test_status = 'negative')
        and (@pool_status = 'negative'))
    THEN
        UPDATE test
        SET test_status = i_test_status
        WHERE test_id = i_test_id;
    END IF;


-- End of solution
END //
DELIMITER ;


-- ID: 12a
-- Author: dvaidyanathan6
-- Name: create_appointment

DROP PROCEDURE IF EXISTS create_appointment;
DELIMITER //
CREATE PROCEDURE create_appointment(
	IN i_site_name VARCHAR(40),
    IN i_date DATE,
    IN i_time TIME
)
sp_main: BEGIN
-- Type solution below

select count(*)
    into @siteCount
    from WORKING_AT
    where site = i_site_name;
    
    select count(*)
    into @appointmentCount
    from APPOINTMENT
    where site_name = i_site_name and appt_date = i_date;
    
    if (@appointmentCount > @siteCount * 10) 
		then leave sp_main; 
	end if;
    
    insert into APPOINTMENT (username, site_name, appt_date, appt_time) values (NULL, i_site_name, i_date, i_time);


-- End of solution
END //
DELIMITER ;

-- ID: 13a
-- Author: dvaidyanathan6@
-- Name: view_appointments
DROP PROCEDURE IF EXISTS view_appointments;
DELIMITER //
CREATE PROCEDURE view_appointments(
    IN i_site_name VARCHAR(40),
    IN i_begin_appt_date DATE,
    IN i_end_appt_date DATE,
    IN i_begin_appt_time TIME,
    IN i_end_appt_time TIME,
    IN i_is_available INT  -- 0 for "booked only", 1 for "available only", NULL for "all"
)
sp_main: BEGIN
    DROP TABLE IF EXISTS view_appointments_result;
    CREATE TABLE view_appointments_result(

        appt_date DATE,
        appt_time TIME,
        site_name VARCHAR(40),
        location VARCHAR(40),
        username VARCHAR(40));

    INSERT INTO view_appointments_result
-- Type solution below

select a.appt_date, a.appt_time, a.site_name, s.location, a.username
	from APPOINTMENT a
		left join SITE s
			on s.site_name = a.site_name
	where (a.appt_date >= i_begin_appt_date or i_begin_appt_date is null)
		and (a.appt_date <= i_end_appt_date or i_end_appt_date is null)
        and (a.appt_time >= i_begin_appt_time or i_begin_appt_time is null)
        and (a.appt_time <= i_end_appt_time or i_end_appt_time is null)
        and (a.site_name = i_site_name or i_site_name is null)
        and ((i_is_available = 0 and not isnull(username)) or (i_is_available = 1 and isnull(username)) or (i_is_available is NULL));
        
        select appt_date, appt_time, site_name, location, username from view_appointments_result;

-- End of solution
END //
DELIMITER ;


-- ID: 14a
-- Author: kachtani3@
-- Name: view_testers
DROP PROCEDURE IF EXISTS view_testers;
DELIMITER //
CREATE PROCEDURE view_testers()
BEGIN
    DROP TABLE IF EXISTS view_testers_result;
    CREATE TABLE view_testers_result(

        username VARCHAR(40),
        name VARCHAR(80),
        phone_number VARCHAR(10),
        assigned_sites VARCHAR(255));

    INSERT INTO view_testers_result
-- Type solution below
	select st.sitetester_username, concat_ws(' ', fname, lname) as full_name, e.phone_num, group_concat(site order by site asc separator ', ')
	from sitetester st
		left join user u
			on u.username = st.sitetester_username
		left join employee e
			on e.emp_username = st.sitetester_username
		left join working_at wa
			on wa.username = st.sitetester_username
	group by st.sitetester_username;
    
    select st.sitetester_username, concat_ws(' ', fname, lname) as full_name, e.phone_num, group_concat(site order by site asc separator ', ')
	from sitetester st
		left join user u
			on u.username = st.sitetester_username
		left join employee e
			on e.emp_username = st.sitetester_username
		left join working_at wa
			on wa.username = st.sitetester_username
	group by st.sitetester_username;

-- End of solution
END //
DELIMITER ;


-- ID: 15a
-- Author: kachtani3@
-- Name: create_testing_site
DROP PROCEDURE IF EXISTS create_testing_site;
DELIMITER //
CREATE PROCEDURE create_testing_site(
	IN i_site_name VARCHAR(40),
    IN i_street varchar(40),
    IN i_city varchar(40),
    IN i_state char(2),
    IN i_zip char(5),
    IN i_location varchar(40),
    IN i_first_tester_username varchar(40)
)
BEGIN

-- Type solution below

INSERT INTO site VALUES
(i_site_name, i_street, i_city, i_state, i_zip, i_location);

INSERT INTO working_at VALUES
(i_first_tester_username, i_site_name);

-- End of solution

END //
DELIMITER ;




-- ID: 16a
-- Author: kachtani3@
-- Name: pool_metadata
DROP PROCEDURE IF EXISTS pool_metadata;
DELIMITER //
CREATE PROCEDURE pool_metadata(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS pool_metadata_result;
    CREATE TABLE pool_metadata_result(
        pool_id VARCHAR(10),
        date_processed DATE,
        pooled_result VARCHAR(20),
        processed_by VARCHAR(100));

    INSERT INTO pool_metadata_result
-- Type solution below

    select p.pool_id as 'Pool ID', p.process_date as 'Date Processed',
		p.pool_status as 'Pooled Result', concat_ws(' ', u.fname, u.lname) as 'Processed By'
    from pool p 
		left join user u
			on u.username = p.processed_by
    where pool_id = i_pool_id;

-- End of solution
END //
DELIMITER ;


-- ID: 16b
-- Author: kachtani3@
-- Name: tests_in_pool
DROP PROCEDURE IF EXISTS tests_in_pool;
DELIMITER //
CREATE PROCEDURE tests_in_pool(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS tests_in_pool_result;
    CREATE TABLE tests_in_pool_result(
        test_id varchar(7),
        date_tested DATE,
        testing_site VARCHAR(40),
        test_result VARCHAR(20));

    INSERT INTO tests_in_pool_result
-- Type solution below

    select test_id as 'Test ID#', appt_date as 'Date Tested',
    appt_site as 'Testing Site', test_status as 'Test Result'
    from test
    where pool_id = i_pool_id;

-- End of solution
END //
DELIMITER ;



-- ID: 17a
-- Author: kachtani3@
-- Name: tester_assigned_sites
DROP PROCEDURE IF EXISTS tester_assigned_sites;
DELIMITER //
CREATE PROCEDURE tester_assigned_sites(
    IN i_tester_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tester_assigned_sites_result;
    CREATE TABLE tester_assigned_sites_result(
        site_name VARCHAR(40));

-- Type solution below
INSERT INTO tester_assigned_sites_result
SELECT distinct site from WORKING_AT where username = i_tester_username;
    
SELECT site_name FROM tester_assigned_sites_result;

 -- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: kachtani3@
-- Name: assign_tester
DROP PROCEDURE IF EXISTS assign_tester;
DELIMITER //
CREATE PROCEDURE assign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
sp_main: BEGIN
-- Type solution below

INSERT INTO WORKING_AT (username, site) VALUES (i_tester_username, i_site_name);
	
update WORKING_AT
set username = i_tester_username
where site = i_site_name;


-- End of solution
END //
DELIMITER ;


-- ID: 17c
-- Author: kachtani3@
-- Name: unassign_tester
DROP PROCEDURE IF EXISTS unassign_tester;
DELIMITER //
CREATE PROCEDURE unassign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
sp_main: BEGIN
-- Type solution below

select count(*)
into @workerCount
from WORKING_AT
where site = i_site_name;
    
if (@workerCount > 1) then
delete from WORKING_AT
        	where username = i_tester_username and site = i_site_name;
end if;


-- End of solution
END //
DELIMITER ;


-- ID: 18a
-- Author: lvossler3
-- Name: daily_results
DROP PROCEDURE IF EXISTS daily_results;
DELIMITER //
CREATE PROCEDURE daily_results()
BEGIN
	DROP TABLE IF EXISTS daily_results_result;
    CREATE TABLE daily_results_result(
		process_date date,
        num_tests int,
        pos_tests int,
        pos_percent DECIMAL(6,2));
	INSERT INTO daily_results_result
    -- Type solution below


 
select p.process_date, count(*) as total_processed, 
sum(case when t.test_status = 'positive' then 1 else 0 end) as total_positive,
(sum(case when t.test_status = 'positive' then 1 else 0 end)/count(*))*100 as positives_percentage
 from test t
 right join pool p
	on t.pool_id = p.pool_id
where t.test_status != 'pending'
group by p.process_date;


    -- End of solution
    END //
    DELIMITER ;





