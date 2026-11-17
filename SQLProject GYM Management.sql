CREATE TABLE 'membership_plans'
(
    membership_plan_id INT PRIMARY KEY,
    plan_name VARCHAR(30),
    duration_months INT,
    plan_fee INT
);

INSERT INTO membership_plans VALUES
(1, 'Basic', 1, 1000),
(2, 'Standard', 3, 2500),
(3, 'Premium', 6, 4500),
(4, 'Gold', 12, 8000),
(5, 'Platinum', 12, 12000);



CREATE TABLE trainers
(
    trainer_id INT PRIMARY KEY,
    trainer_name VARCHAR(50),
    specialization VARCHAR(50)
);

INSERT INTO trainers VALUES
(1, 'Amit Sharma', 'Weight Training'),
(2, 'Rahul Patel', 'Cardio'),
(3, 'Priya Shah', 'Yoga'),
(4, 'Neha Verma', 'Fitness'),
(5, 'Karan Mehta', 'Crossfit'),
(6, 'Rohit Singh', 'Weight Training'),
(7, 'Pooja Joshi', 'Yoga'),
(8, 'Vikas Kumar', 'Cardio'),
(9, 'Anjali Desai', 'Fitness'),
(10, 'Arjun Shah', 'Crossfit');


CREATE TABLE members
(
    member_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    gender VARCHAR(10),
    date_of_birth DATE,
    phone VARCHAR(15),
    email VARCHAR(100),
    city VARCHAR(30),
    membership_plan_id INT,
    join_date DATE,
    expiry_date DATE,
    monthly_fee INT,
    trainer_id INT,
    attendance_count INT,
    membership_status VARCHAR(20),

    FOREIGN KEY (membership_plan_id)
    REFERENCES membership_plans(membership_plan_id),

    FOREIGN KEY (trainer_id)
    REFERENCES trainers(trainer_id)
);

DECLARE @i INT = 1;

WHILE @i <= 500
BEGIN

INSERT INTO members VALUES
(
    @i,

    CASE @i % 10
        WHEN 0 THEN 'Amit'
        WHEN 1 THEN 'Rahul'
        WHEN 2 THEN 'Priya'
        WHEN 3 THEN 'Neha'
        WHEN 4 THEN 'Karan'
        WHEN 5 THEN 'Rohit'
        WHEN 6 THEN 'Pooja'
        WHEN 7 THEN 'Vikas'
        WHEN 8 THEN 'Anjali'
        ELSE 'Arjun'
    END,

    CASE @i % 5
        WHEN 0 THEN 'Sharma'
        WHEN 1 THEN 'Patel'
        WHEN 2 THEN 'Singh'
        WHEN 3 THEN 'Mehta'
        ELSE 'Verma'
    END,

    CASE WHEN @i % 2 = 0 THEN 'Male'
         ELSE 'Female'
    END,

    DATEADD(YEAR, - (20 + @i % 25), GETDATE()),

    CAST(9000000000 + @i AS VARCHAR(15)),

    'member' + CAST(@i AS VARCHAR(10)) + '@gmail.com',

    CASE @i % 5
        WHEN 0 THEN 'Ahmedabad'
        WHEN 1 THEN 'Mumbai'
        WHEN 2 THEN 'Pune'
        WHEN 3 THEN 'Delhi'
        ELSE 'Surat'
    END,

    (@i % 5) + 1,

    DATEADD(DAY, -(@i % 700), GETDATE()),

    DATEADD(DAY, 365 - (@i % 700), GETDATE()),

    CASE @i % 5
        WHEN 0 THEN 1000
        WHEN 1 THEN 2500
        WHEN 2 THEN 4500
        WHEN 3 THEN 8000
        ELSE 12000
    END,

    (@i % 10) + 1,

    @i % 100,

    CASE
        WHEN (@i % 700) <= 365 THEN 'Active'
        ELSE 'Expired'
    END
);

SET @i = @i + 1;

END;

-- TASK 1: DISPLAY ALL MEMBERS

SELECT * FROM members;


-- TASK 2: FIND EXPIRED MEMBERSHIPS

SELECT *
FROM members
WHERE membership_status = 'Expired';


-- TASK 3: SORT MEMBERS BY JOIN DATE

SELECT *
FROM members
ORDER BY join_date ASC;


-- TASK 4: GROUP MEMBERS BY MEMBERSHIP PLAN

SELECT
    membership_plan_id,
    COUNT(*) AS Total_Members
FROM members
GROUP BY membership_plan_id;


-- TASK 5: CALCULATE AVERAGE MEMBERSHIP FEES BY PLAN

SELECT
    membership_plan_id,
    AVG(monthly_fee) AS Average_Fee
FROM members
GROUP BY membership_plan_id;


-- TASK 6: DISPLAY 10 LONGEST-STANDING MEMBERS

SELECT TOP 10 *
FROM members
ORDER BY join_date ASC;


-- TASK 8: JOIN MEMBERS, MEMBERSHIP PLANS AND TRAINERS

SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    mp.plan_name,
    mp.plan_fee,
    t.trainer_name,
    t.specialization
FROM members m

INNER JOIN membership_plans mp
ON m.membership_plan_id = mp.membership_plan_id

INNER JOIN trainers t
ON m.trainer_id = t.trainer_id;


-- TASK 9: FIND TRAINERS ASSIGNED TO MORE THAN 15 MEMBERS

SELECT
    t.trainer_id,
    t.trainer_name,
    COUNT(m.member_id) AS Total_Members
FROM trainers t

INNER JOIN members m
ON t.trainer_id = m.trainer_id

GROUP BY
    t.trainer_id,
    t.trainer_name

HAVING COUNT(m.member_id) > 15;


-- TASK 10: COUNT ACTIVE AND EXPIRED MEMBERSHIPS BY PLAN

SELECT
    mp.plan_name,
    SUM(CASE
        WHEN m.membership_status = 'Active'
        THEN 1 ELSE 0
    END) AS Active_Members,

    SUM(CASE
        WHEN m.membership_status = 'Expired'
        THEN 1 ELSE 0
    END) AS Expired_Members

FROM membership_plans mp

LEFT JOIN members m
ON mp.membership_plan_id = m.membership_plan_id

GROUP BY mp.plan_name;