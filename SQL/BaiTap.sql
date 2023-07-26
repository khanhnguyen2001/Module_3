use demo2006;

-- Mức 1:
-- 1. In ra các sản phẩm có số lượng từ 30 trở lên.
select *
from product 
where quantity >= 30;

-- 2. In ra các sản phẩm có số lượng từ 30 trở lên và có giá trong khoảng 100 đến 200.
select *
from product 
where quantity >= 30 and price between 100 and 200;

-- 3. In ra thông tin khách hàng tuổi lớn hơn 18
select * 
from customer
where age > 18;

-- 4. In ra thông tin khách hàng họ Nguyễn và lớn hơn 20 tuổi
select *
from customer
where name like 'Nguyễn%';

-- 5. In ra sản phẩm tên bắt đầu bằng chữ M
select * 
from product
where name like 'M%';

-- 6. In ra sản phẩm kết thúc bằng chữ E
select * 
from product
where name like '%E';

-- 7. In ra danh sách sản phẩm số lượng tăng dần
select * 
from product
order by quantity;

-- 8. In ra danh sách sản phẩm giá giảm dần
select * 
from product
order by price desc;


-- Mức 2:
-- 1. In ra tổng số lượng sản phẩm giá nhỏ hơn 300
select sum(quantity) as 'Tổng số lượng sản phẩm'
from product
where price < 300;

-- 2. In tổng số sản phẩm theo từng giá
select count(*) as 'Tổng sản phẩm', price
from product
group by price;

-- 3. In ra sản phẩm có giá cao nhất
select *
from product
where price = (select max(price) from product);

-- 4. In ra giá trung bình của tất cả các sản phẩm
select avg(price) as ' Giá trung bình tất cả sản phẩm'
from product;

-- 5. In ra tổng số tiền nếu bán hết tất cả sản phẩm.
select sum(price * quantity) as 'Tổng tiền sản phẩm nếu bán hết'
from product;

-- 6. Tính tổng số sản phẩm giá < 300.
select count(*) as 'Tổng sản phẩm có giá < 300'
from product
where price < 300;

-- 7. Tìm giá bán cao nhất của các sản phẩm bắt đầu bằng chữ M.
select * 
from product
where name like 'M%' and price = (select max(price) from product where name like 'M%');

-- 8. Tìm giá bán thấp nhất của các sản phẩm bắt đầu bằng chữ M.
select * 
from product
where name like 'M%' and price = (select min(price) from product where name like 'M%');

-- 9. Tìm giá bán trung bình của các sản phẩm bắt đầu bằng chữ M.
select avg(price) as 'Giá trung bình của các sản phẩm bắt đầu bằng chữ M'
from product
where name like 'M%';

-- Mức 3: Thêm bảng category: id, tên. Thêm trường idCategory cho bảng Product
-- Tạo bảng category
create table category(
 idCategory int auto_increment not null primary key,
 name varchar(60) not null
 );

-- Thêm trường idCategory
ALTER TABLE product
ADD COLUMN idCategory INT;

-- Tạo khóa ngoại cho bảng product
ALTER TABLE product
ADD FOREIGN KEY (idCategory)
REFERENCES category(idCategory);
 
 -- 1. In ra tên khách hàng và thời gian mua hàng.
 select name, time
 from demo2006.customer c inner join demo2006.order o on c.id = o.customerId;
 
 -- 2. In ra tên khách hàng và tên sản phẩm đã mua
 select c.name as 'Tên khách hàng', p.name as 'Tên sản phẩm đã mua' 
 from demo2006.customer c 
 inner join demo2006.order o on c.id = o.customerId 
 inner join demo2006.orderdetail od on o.id = od.orderId 
 inner join demo2006.product p on od.productId = p.id;
 
 -- 3. In ra tổng số lượng sản phẩm từng loại
 select c.name as 'Tên loại sản phẩm',sum(p.quantity) as 'Số lượng sản phẩm từng loại'
 from product p inner join category c on p.idCategory = c.idCategory
 group by c.idCategory;
 
 -- 4. Đếm số mặt hàng từng loại
 select c.name as 'Tên loại sản phẩm',count(p.idCategory) as 'Số mặt hàng từng loại'
 from product p inner join category c on p.idCategory = c.idCategory
 group by c.idCategory;
 
 -- 5. Tính giá trung bình tất cả các sản phẩm
 select avg(price) as ' Giá trung bình tất cả sản phẩm'
from product;

-- 6. Tính giá trung bình từng loại
 select c.name as 'Tên loại sản phẩm',avg(p.price) as 'Giá trung bình từng loại mặt hàng'
 from product p inner join category c on p.idCategory = c.idCategory
 group by c.idCategory;
 
 -- 7. Tìm sản phẩm có giá lớn nhất theo từng loại
 select c.name as 'Tên loại sản phẩm', p.name as 'Sản phẩm có giá lớn nhất'
 from product p inner join category c on p.idCategory = c.idCategory
 where p.price = (
	select max(price)
    from product
    where idCategory = p.idCategory
    )
 group by c.name, p.name;
 -- Cách 2: select * from product where price in (select max(price) from product  group by idCategory);

 -- 8.	Tính tuổi trung bình của các khách hàng
 select avg(age) as ' Tuổi trung bình của khách hàng'
 from customer;
 
 -- 9.	Đếm số khách hàng tuổi lớn hơn 30
select count(age) as 'Khách hàng có tuổi lớn hơn 30'
from customer
where age > 30;

-- 10.	Đếm số lần mua hàng của từng khách hàng
select customer.id, customer.name, COUNT(demo2006.order.id) as 'Số lần mua hàng của từng khách hàng'
from customer
left join demo2006.order on customer.id = demo2006.order.id
group by customer.id, customer.name;
-- Cách đơn giản hơn: select customer.id, customer.name, COUNT(`order`.id) as 'Số lần mua hàng của từng khách hàng' 
-- 					  from customer join `order` on customer.id = `order`.customerId 
-- 					  group by customer.id;

 -- 11.	Đếm số lượng hóa đơn theo từng tháng
select month(time) as order_month, count(demo2006.order.id) as total_orders
from demo2006.order
group by order_month;

 -- 12. In ra mã hoá đơn và giá trị hoá đơn
 select `order`.id as 'Mã hóa đơn', sum(orderdetail.quantity * product.price) as 'Giá trị hóa đơn' 
 from `order` join orderdetail on orderdetail.orderId = `order`.id 
			  join product on orderdetail.productId = product.id
group by `order`.id;
 
-- 13.	In ra mã hoá đơn và giá trị hoá đơn giảm dần
 select `order`.id, sum(orderdetail.quantity * product.price) as order_value
 from `order` join orderdetail on orderdetail.orderId = `order`.id 
			  join product on orderdetail.productId = product.id
group by `order`.id
order by order_value desc;


-- 14.	Tính tổng tiền từng khách hàng đã mua
select customer.name, sum(orderdetail.quantity * product.price)	as 'Tổng tiền hóa đơn'
from customer join `order` on customer.id = `order`.customerId
	join orderdetail on `order`.id = orderdetail.orderId
    join product on orderdetail.productId = product.id
group by customer.id;
 
 
 
 -- Mức 4: 
 -- 1.	In ra các mã hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
 select o.id as 'Mã hóa đơn', date(o.time) as 'Thời gian', sum(od.quantity * p.price) as 'Tổng tiền hóa đơn'
 from `order`o
	join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
 where date(o.time) = '2006-06-20' or date(o.time) = '2006-09-19'  -- Hoặc: Có thể sử dụng between
 group by o.id;
 
 
-- 2. In ra các mã hóa đơn, trị giá hóa đơn trong tháng 6/2006, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
 select o.id as 'Mã hóa đơn', day(o.time) as 'Ngày', sum(od.quantity * p.price) as 'Tổng tiền hóa đơn'
 from `order` o
	join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
 where date_format(o.time, 	'%m/%Y') = '06/2006'
 group by o.id, day(o.time)
 order by  day(o.time) asc, 'Tổng tiền hóa đơn' desc;
 
 
-- 3.In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007.
select c.id as 'Mã khách hàng', c.name as 'Tên khách hàng'
 from customer c inner join `order` o on c.id = o.customerId
 where date(o.time) = '2007-06-19';
 
-- 4. In ra danh sách các sản phẩm (MASP, TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select p.id as 'Mã sản phẩm', p.name as 'Tên sản phẩm'
 from customer c
	join `order` o on c.id = o.customerId
	join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
 where date_format(o.time, '%m/%Y') = '10/2006'and c.name = 'Nguyen Van A';

# 5.	Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select o.id as MAHD
from `order` o inner
    join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
where p.name = 'Máy giặt' or p.name = 'Tủ lạnh'
group by o.id;

# Bài tập thêm
# Đề bài: Cho hai bảng Học sinh và Điểm. Trong bảng học sinh có id, tên; trong bảng điểm có id, tên môn học. 
# Thiết kế db sau đó tạo db, thêm dữ liệu. Tìm ra tất cả những sinh viên chưa có điểm (làm bằng 2 cách)

-- Tao bang hoc sinh
create table hocsinh(
    id int auto_increment not null primary key,
    name varchar(60) not null
);

-- Tao bang diem
create table diem(
    id int auto_increment not null primary key,
    name varchar(60) not null
);

ALTER TABLE diem
ADD COLUMN idHS INT;

ALTER TABLE diem
ADD FOREIGN KEY (idHS)
REFERENCES hocsinh(id);

-- Tìm ra tất cả những sinh viên chưa có điểm (làm bằng 2 cách)

-- Cach 1: Nguoc
select *
from hocsinh h left join diem d on h.id = d.idHS
where h.id not in (select h.id from hocsinh h join diem d on h.id = d.idHS group by h.id);

-- Cach 2: Thuan
select h.name
from hocsinh h left join diem d on h.id = d.idHS
where d.id is null;

 
 -- 6.	In ra danh sách các sản phẩm (MASP, TENSP) không bán được.
 select p.id as MASP, p.name as TENSP
 from product p
 where p.id not in (select p.id from `order` o
								join orderdetail od on o.id = od.orderId
								join product p on od.productId = p.id group by p.id);
 
 
-- 7.	In ra danh sách các sản phẩm (MASP, TENSP) không bán được trong năm 2006.
 select p.id as MASP, p.name as TENSP
 from product p
 where p.id not in (select p.id from `order` o
								join orderdetail od on o.id = od.orderId
								join product p on od.productId = p.id
                                where year(o.time) = '2006'
                                group by p.id);


-- 8.	In ra danh sách các sản phẩm (MASP, TENSP) có giá >300 sản xuất bán được trong năm 2006.
 select p.id as MASP, p.name as TENSP
 from  `order` o
	join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
 where p.price > 300 and year(o.time) = '2006'
 group by p.id;	

-- 9.	Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
-- Cách 1: View thường (Viết bằng lệnh truy vấn thông thường và không chứa hay lưu dữ liệu)
select count(SPBD.SP) as 'Số sản phẩm khác nhau được bán ra trong năm 2006'
from (select p.id as SP
 from orderdetail od 
	join `order` o on o.id = od.orderId
    join product p on od.productId = p.id
 where year(o.time) = '2006'
 group by p.id) as SPBD;
 
 -- Cách 2: View có chưa dữ liệu
CREATE VIEW Dem_SP AS
    SELECT p.id AS SP
    FROM orderdetail od 
		JOIN `order` o ON o.id = od.orderId
		JOIN product p ON od.productId = p.id
    WHERE YEAR(o.time) = '2006'
    GROUP BY p.id;
SELECT count(SP) as 'Số sản phẩm khác nhau được bán ra trong năm 2006' FROM Dem_SP;


-- 10.	Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select o.id as MAHD
from `order` o 
    join orderdetail od on o.id = od.orderId
    join product p on od.productId = p.id
where (p.name = 'Máy giặt' or p.name = 'Tủ lạnh') and od.quantity between 10 and 20
group by o.id;

-- 11.	Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
-- Cách 1:
select od.orderId as MAHD
from orderdetail od join product p on od.productId = p.id
where od.orderId in (select od.orderId 
		from orderdetail od join product p on od.productId = p.id 
		where p.name = 'Máy giặt' and od.quantity between 10 and
        
        20) 
	and od.orderId in (select od.orderId 
		from orderdetail od join product p on od.productId = p.id 
		where p.name = 'Tủ lạnh' and od.quantity between 10 and 20)
group by od.orderId;

select o.id  from `order` o
                      join orderdetail od on o.id = od.orderId
                      join product p on od.productId = p.id
where o.id in (select o.id   from `order` o
           join orderdetail od on o.id = od.orderId
           join product p on od.productId = p.id
           where p.name like '%Máy Giặt%' and  od.quantity between 10 and 20
           group by o.id)
  and  o.id in (select o.id  from `order` o
                                      join orderdetail od on o.id = od.orderId
                                      join product p on od.productId = p.id
                where p.name like '%Tủ Lạnh%' and  od.quantity between 10 and 20
                group by o.id)
group by o.id;

-- Cách 2:
SELECT o.id AS MAHD
FROM `order` o
	JOIN orderdetail od1 ON o.id = od1.orderId
	JOIN product p1 ON od1.productId = p1.id AND p1.name = 'Máy giặt' AND od1.quantity BETWEEN 10 AND 20
	JOIN orderdetail od2 ON o.id = od2.orderId
	JOIN product p2 ON od2.productId = p2.id AND p2.name = 'Tủ lạnh' AND od2.quantity BETWEEN 10 AND 20
GROUP BY o.id;

-- Cách 3:
SELECT od.orderId AS 'Mã hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”'
FROM orderdetail od
INNER JOIN product p ON od.productID = p.id
WHERE p.name in ('Máy giặt', 'Tủ lạnh', 'Máy giặt apple')
  AND od.quantity BETWEEN 10 AND 20
GROUP BY od.orderId
HAVING COUNT(p.id) = 2;

-- 12.	Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.
-- 13.	Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.
-- 14.	Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
-- 15.	Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
-- 16.	Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
-- 17.	Tính doanh thu bán hàng trong năm 2006.
-- 18.	Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
-- 19.	Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
-- 20.	In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).
-- 21.	In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
-- 22.	In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
-- 23.	Tính doanh thu bán hàng mỗi ngày.
-- 24.	Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
-- 25.	Tính doanh thu bán hàng của từng tháng trong năm 2006.
-- 26.	Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
-- 27.	Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).
-- 28.	Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
-- 29.	Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
-- 30.	Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
-- 31.	Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.

 
 
 
 
 
 
 