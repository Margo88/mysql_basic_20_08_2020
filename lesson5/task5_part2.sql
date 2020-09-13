-- ������������ ������� ���� ���������� �������

-- �1. ����������� ������� ������� ������������� � ������� users.

select 
	round(avg(timestampdiff(year, birthday_at, now()))) 
as 
	average_age 
from 
	users;

-- �2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.

select 
	count(*) as bday_count, 
	dayname(concat(year(now()), '-', substring(birthday_at, 6, 10))) as weekday 
from 
	users 
group by 
	weekday;

-- �3. ����������� ������������ ����� � ������� �������.

DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (
  id SERIAL PRIMARY KEY,
  value INT
);

INSERT INTO test_table
  (value)
VALUES
  (1),
  (2),
  (3),
  (4),
  (5);
 
select exp(sum(log(value))) as multiplication from test_table;


