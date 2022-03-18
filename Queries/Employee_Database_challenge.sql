-- CHALLENGE --

-- TABLE 1: Number of [Titles] Retiring
-- 1. Create a table that shows *current* employees eligible for retirement
select e.emp_no,
	e.first_name,
	e.last_name,
	de.to_date
into tbl_current_emp
from employees as e
	left join dept_emp as de
		on e.emp_no = de.emp_no
where (e.birth_date between '1952-01-01' and '1955-12-31')
	and (e.hire_date between '1985-01-01' and '1988-12-31')
		and de.to_date = ('9999-01-01');

-- 2. Find the titles retiring
select 
	ce.emp_no,
	ce.first_name,
	ce.last_name,
	ttl.title,
	ttl.from_date,
	s.salary
into tbl_titles_retiring
from tbl_current_emp as ce
	inner join titles as ttl
		on (ce.emp_no = ttl.emp_no)
	inner join salaries as s
		on (ce.emp_no = s.emp_no)
order by ttl.from_date DESC;

-- 3. Count the number of titles retiring
select 
	count (title), 
	title
into tbl_count_titles_retiring
from tbl_titles_retiring
group by 
	title
order by count desc;

select * from tbl_current_emp;
select * from tbl_titles_retiring;
select * from tbl_count_titles_retiring;



-- TABLE 2: Only the Most Recent Titles
-- The Number of Retiring Employees by Title (No Duplicates).
SELECT DISTINCT ON (rt.emp_no) 
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

-- The number of employees by their most recent job title who are about to retire.
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;


-- TABLE 3: Who's Ready for a Mentor?
select
	e.emp_no,
	e.last_name,
	e.first_name,
	e.birth_date,
	string_agg(ttl.title, '/') as titles,
	de.from_date,
	de.to_date
into tbl_mentor_ready
from employees as e
	left join titles as ttl
		on e.emp_no = ttl.emp_no
	left join dept_emp as de
		on e.emp_no = de.emp_no
where e.birth_date between '1965-01-01' and '1965-12-31'
	and de.to_date = ('9999-01-01')
group by
	e.emp_no,
	e.first_name,
	e.last_name,
	de.from_date,
	de.to_date
order by last_name;

select * from tbl_mentor_ready;
select count(*) from tbl_mentor_ready;