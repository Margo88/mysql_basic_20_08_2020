-- ������������ ������� �� ���� ����������, ����������, ���������� � �����������

-- �1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. 
-- ��������� �� �������� ����� � ��������.

update users
set created_at = now() where created_at is null;

update users
set updated_at = now() where updated_at is null;
-- �2. ������� users ���� �������� ��������������. ������ creatae_at � updated_at 
-- ���� ������ ����� varchar � � ��� ������ ����� ����������
-- �������� � ������� 20.10.2017 8:10. ���������� ������������� 
-- ���� � ���� datetime, �������� ��������� ����� ��������

update 
	users
set
	created_at = str_to_date(created_at, '%d.%m.%Y %H:%i');

update 
	users
set
	updated_at = str_to_date(updated_at , '%d.%m.%Y %H:%i');

alter table users modify created_at datetime;	
alter table users modify updated_at datetime;	

-- �3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� 
-- ����� ������ �����: 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
-- ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
-- ������ ������� ������ ������ ���������� � �����, ����� ���� �������.


 select * from storehouses_products order by case when value = 0 then 1 else 0 end, value;

-- �4. �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� (may, august)

select * from users where birthday_at like '%august%' or birthday_at like '%may%';

-- �5. �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- ������������ ������ � �������, �������� � ������ IN.

SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by field(id,5,1,2);



