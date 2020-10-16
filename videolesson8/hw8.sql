-- ���� "����������, ����������, �������������"
-- � �������� ����������� ������ �������, ���� ���� ������ � ������� �� ����������.
-- ������ 1.
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
use sample;

DROP TABLE IF EXISTS users; -- ������� ������� ����������� ������� users � ���� ������ shop, ����� ������ ����� ��������� ������

CREATE TABLE users(
	id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	birthday_at DATE DEFAULT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM users;

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM users;

-- ������� 2.

use hw7; -- � ���� ������ hw7 � ��������� ������� �� ����� shop

create or replace view product_description (product_id, catalog_name, product_name) as 
select p.id as product_id, p.name, c.name 
from products as p 
join
catalogs as c
on p.catalog_id = c.id;

select*from product_description 

-- ���� "�������� ��������� � �������, ��������"
-- ������ 1.
use hw7;
delimiter //

create procedure hello()
begin
	case
		when curtime() between '06:00:00' and '12:00:00' then 
			select '������ ����';
		when curtime() between '12:00:00' and '18:00:00' then 
			select '������ ����';
		when curtime() between '18:00:00' and '00:00:00' then 
			select '������ �����';
		else 
			select '������ ����';
	end case;
end //


delimiter ;
call hello();

-- ������ 2.
DROP TRIGGER IF EXISTS nullTrigger;
delimiter //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
	END IF;
END //
delimiter ;
