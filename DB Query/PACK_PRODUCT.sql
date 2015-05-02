#Proc to add new product
DELIMITER //
CREATE PROCEDURE AddNewProduct(
         IN productName VARCHAR(100),
		 IN openingBalance INT,
		 IN costPrice DECIMAL(8,2),
		 IN dealerPrice DECIMAL(8,2),
		 IN marketPrice DECIMAL(8,2),
		 IN productCategory INT,
		 IN userID INT
         )
BEGIN
DECLARE productID INT DEFAULT 0;
DECLARE actionID INT DEFAULT 0;		
call generateActionID('New product creation',actionID);

INSERT into product values (null,productName,openingBalance,costPrice,productCategory,userID,actionID,null,marketPrice,dealerPrice);
SELECT MAX(product_id) into productID from product;

INSERT into price values(null,productID,1,costPrice,null,actionID);
INSERT into price values(null,productID,3,marketPrice,null,actionID);
INSERT into price values(null,productID,4,dealerPrice,null,actionID);
INSERT into product_stock values(null,productID,'Opening Balance',1,CURDATE(),openingBalance,0,openingBalance,null);
		
END//
DELIMITER ;

#Proc to update product
DELIMITER //
CREATE PROCEDURE updateProduct(
         IN productName VARCHAR(100),
		 IN openingBalance DECIMAL(8,2),
		 IN costPrice DECIMAL(8,2),
		 IN dealerPrice DECIMAL(8,2),
		 IN marketPrice DECIMAL(8,2),
		 IN productCategory INT,
		 IN userID INT,
		 IN productID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('New product creation',actionID);

UPDATE product 
SET 
    product_name = productName,
    product_category = productCategory
WHERE
    product_id = productID
        AND user_id = userID;	

UPDATE product_stock
SET in_value=openingBalance
WHERE product_id=productID
AND detail='Opening Balance';

UPDATE price
SET close_action_id = actionID
WHERE product_id= productID
AND price_type in (1,3,4)
AND close_action_id is null;

INSERT into price values(null,productID,1,costPrice,null,actionID);
INSERT into price values(null,productID,3,marketPrice,null,actionID);
INSERT into price values(null,productID,4,dealerPrice,null,actionID);

END//
DELIMITER ;

#Proc to get all products details
DELIMITER //
CREATE PROCEDURE getProductsDetails(
		 IN userID INT,
		 IN categoryID INT
         )
BEGIN
IF categoryID = -1 then
SELECT 
	st.product_id,st.product_name,SUM(st.in_value) IN_VALUE,SUM(st.out_value) OUT_VALUE,
	st.PRODUCT_CATEGORY,st.cost_price,st.dealer_price,st.market_price
FROM
(SELECT 
    p.product_id,p.product_name,ps.detail,ps.in_value,ps.out_value,c.category AS PRODUCT_CATEGORY,
	prc.price cost_price,prd.price dealer_price,prm.price market_price
FROM
    product p,product_stock ps,price prc,price prd,price prm,category c
WHERE
    p.user_id = userID
        AND p.close_action_id is null
        AND p.product_id = ps.product_id
		AND prc.product_id= p.product_id
		AND prd.product_id= p.product_id
		AND prm.product_id= p.product_id
		AND prc.close_action_id is null
		AND prc.price_type = 1
		AND prm.price_type = 3
		AND prd.price_type = 4
		AND prm.close_action_id is null
		AND prd.close_action_id is null
        AND c.category_id =p.product_category
		AND c.close_action_id is NULL
		AND ps.detail = 'Opening Balance'
UNION ALL
SELECT 
    p.product_id,p.product_name,ps.detail,ps.in_value,ps.out_value,c.category AS PRODUCT_CATEGORY,
	prc.price cost_price,prd.price dealer_price,prm.price market_price
FROM
    product p,product_stock ps,price prc,price prd,price prm,category c,invoice i
WHERE
    p.user_id = userID
        AND p.close_action_id is null
        AND p.product_id = ps.product_id
		AND prc.product_id= p.product_id
		AND prd.product_id= p.product_id
		AND prm.product_id= p.product_id
		AND prc.close_action_id is null
		AND prc.price_type = 1
		AND prm.price_type = 3
		AND prd.price_type = 4
		AND prm.close_action_id is null
		AND prd.close_action_id is null
        AND c.category_id =p.product_category
		AND c.close_action_id is NULL
		AND ps.detail <> 'Opening Balance'
		AND ps.invoice_id = i.invoice_id
		AND i.close_action_id is null)st
GROUP BY st.product_id
ORDER BY st.product_name;
else
SELECT 
	st.product_id,st.product_name,SUM(st.in_value) IN_VALUE,SUM(st.out_value) OUT_VALUE,
	st.PRODUCT_CATEGORY,st.cost_price,st.dealer_price,st.market_price
FROM
(SELECT 
    p.product_id,p.product_name,ps.detail,ps.in_value,ps.out_value,c.category AS PRODUCT_CATEGORY,
	prc.price cost_price,prd.price dealer_price,prm.price market_price
FROM
    product p,product_stock ps,price prc,price prd,price prm,category c
WHERE
    p.user_id = userID
        AND p.close_action_id is null
		AND p.product_category =categoryID
        AND p.product_id = ps.product_id
		AND prc.product_id= p.product_id
		AND prd.product_id= p.product_id
		AND prm.product_id= p.product_id
		AND prc.close_action_id is null
		AND prc.price_type = 1
		AND prm.price_type = 3
		AND prd.price_type = 4
		AND prm.close_action_id is null
		AND prd.close_action_id is null
        AND c.category_id =p.product_category
		AND c.close_action_id is NULL
		AND ps.detail = 'Opening Balance'
UNION ALL
SELECT 
    p.product_id,p.product_name,ps.detail,ps.in_value,ps.out_value,c.category AS PRODUCT_CATEGORY,
	prc.price cost_price,prd.price dealer_price,prm.price market_price
FROM
    product p,product_stock ps,price prc,price prd,price prm,category c,invoice i
WHERE
    p.user_id = userID
        AND p.close_action_id is null
		AND p.product_category = categoryID
        AND p.product_id = ps.product_id
		AND prc.product_id= p.product_id
		AND prd.product_id= p.product_id
		AND prm.product_id= p.product_id
		AND prc.close_action_id is null
		AND prc.price_type = 1
		AND prm.price_type = 3
		AND prd.price_type = 4
		AND prm.close_action_id is null
		AND prd.close_action_id is null
        AND c.category_id =p.product_category
		AND c.close_action_id is NULL
		AND ps.detail <> 'Opening Balance'
		AND ps.invoice_id = i.invoice_id
		AND i.close_action_id is null)st
GROUP BY st.product_id
ORDER BY st.product_name;
end if;
END//
DELIMITER ;

#Proc to get product name only.
DELIMITER //
CREATE PROCEDURE getProductName(
		 IN userID INT,
		 IN productID INT
         )
BEGIN
SELECT 
    product_name
from
    product
where
    user_id = userID
        and product_id = productID;
END//
DELIMITER ;

#Proc to get product's transaction
DELIMITER //
CREATE PROCEDURE getProductTransactions(
		 IN userID INT,
		 IN productID INT,
		 IN startdate VARCHAR(100),
		 IN enddate VARCHAR(100)
         )
BEGIN
SELECT t.* FROM
(	SELECT 0 AS stock_id,0 AS product_id,'Previous Balance' AS detail,
	  0 AS transaction_type_id,'1000-01-01' AS transaction_date,COALESCE(sum(pre.in_value)- sum(pre.out_value),0) AS in_value,
	  0.00 AS out_value,0.00 AS balance,0 AS invoice_id , null AS invoice_number FROM
	(SELECT 
      ps.in_value,ps.out_value
    FROM
        product_stock ps, product p
    WHERE
        p.user_id = userID
            and p.product_id = productID
            and ps.product_id = p.product_id
			and ps.transaction_date between '1000-01-01' and DATE_SUB(startdate,INTERVAL 1 DAY)
            and p.close_action_id is null
			and ps.detail = 'Opening Balance'
	UNION ALL
	SELECT 
      ps.in_value,ps.out_value
    FROM
        product_stock ps, product p, invoice i
    WHERE
        p.user_id = userID
            and p.product_id = productID
            and ps.product_id = p.product_id
			and ps.transaction_date between '1000-01-01' and DATE_SUB(startdate,INTERVAL 1 DAY)
            and p.close_action_id is null
			and ps.detail <> 'Opening Balance'
			and ps.invoice_id = i.invoice_id
			and i.close_action_id is null)pre
UNION ALL
SELECT 
      ps.*,null AS invoice_number
    FROM
        product_stock ps, product p
    WHERE
        p.user_id = userID
            and p.product_id = productID
            and ps.product_id = p.product_id
			and ps.transaction_date between startdate and enddate
			and ps.detail = 'Opening Balance'
            and p.close_action_id is null
UNION ALL
SELECT 
        ps . *,i.invoice_number
    FROM
        product_stock ps, product p, invoice i
    WHERE
        p.user_id = userID
            and p.product_id = productID
            and ps.product_id = p.product_id
			and ps.transaction_date between startdate and enddate
            and p.close_action_id is null
			and ps.detail <> 'Opening Balance'
			and ps.invoice_id = i.invoice_id
			and i.close_action_id is null)t
ORDER BY t.transaction_date;
END//
DELIMITER ;

#Proc to delete a product
DELIMITER //
CREATE PROCEDURE deleteProduct(
		 IN userID INT,
		 IN productID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('Product Delete',actionID);

UPDATE product 
set 
    close_action_id = actionID
where
    product_id = productID
        and user_id = userID
		and close_action_id is null;

END//
DELIMITER ;

#Proc to get product details
DELIMITER //
CREATE PROCEDURE getProductDetails(
		 IN userID INT,
		 IN productID INT
         )
BEGIN
SELECT 
    p.product_name,
	p.product_category,
	prc.price cost_price,
	prd.price dealer_price,
	prm.price market_price,
	ps.in_value opening_balance
from
    product p,
	price prc,
	price prd,
	price prm,
	product_stock ps
where
    p.user_id = userID
	and p.product_id = productID
	and prc.product_id = p.product_id
	and prm.product_id = p.product_id
	and prd.product_id =p.product_id
	and prc.close_action_id is null
	and prd.close_action_id is null
	and prm.close_action_id is null
	and prc.price_type = 1
	and prd.price_type=4
	and prm.price_type =3
	and ps.product_id=p.product_id
	and ps.detail = 'Opening Balance';
END//
DELIMITER ;
commit;

# Get Product Balance

#Proc to get product name only.
DELIMITER //
CREATE PROCEDURE getProductBalance(
		 IN userID INT,
		 IN productID INT
         )
BEGIN
SELECT SUM(st.IN_VALUE) IN_VALUE,SUM(st.out_value) OUT_VALUE FROM
(SELECT 
    ps.IN_VALUE,ps.OUT_VALUE
from
    product p,
	product_stock ps
where
    p.user_id = userID
        and p.product_id = productID
		and ps.product_id = p.product_id
		and ps.detail = 'Opening Balance'
UNION ALL
SELECT 
    ps.IN_VALUE,ps.OUT_VALUE
from
    product p,
	product_stock ps,invoice i
where
    p.user_id = userID
        and p.product_id = productID
		and ps.product_id = p.product_id
		and ps.detail <> 'Opening Balance'
		and ps.invoice_id = i.invoice_id
		and i.close_action_id is null)st;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE getCategoryDetails(
		IN userID INT
		)
BEGIN
SELECT 
    cat.category_id, cat.category,COUNT(products.product_id) AS NO_OF_PRODUCTS,
	SUM(products.STOCK_VALUE) AS STOCK_VALUE
from
    (SELECT 
        category_id, category
    FROM
        category
    where
        category.user_id = userID
            and category.close_action_id is null) cat
        LEFT OUTER JOIN
    (SELECT prod.product_id,prod.product_category,SUM(prod.STOCK_VALUE) STOCK_VALUE FROM
		(select 
			p.product_id,
					p.product_category,
					(SUM(ps.IN_VALUE) - SUM(ps.OUT_VALUE)) * pr.price AS STOCK_VALUE
			from
				product p, product_stock ps, price pr
			where
				pr.price_type = 1
					and pr.close_action_id is null
					and pr.product_id = p.product_id
					and ps.product_id = p.product_id
					and p.close_action_id is null
					and ps.detail = 'Opening Balance'
			group by p.product_id
		UNION all
		select 
				p.product_id,
					p.product_category,
					(SUM(ps.IN_VALUE) - SUM(ps.OUT_VALUE)) * pr.price AS STOCK_VALUE
			from
				product p, product_stock ps, price pr,invoice i
			where
				pr.price_type = 1
					and pr.close_action_id is null
					and pr.product_id = p.product_id
					and ps.product_id = p.product_id
					and p.close_action_id is null
					and ps.detail <> 'Opening Balance'
					and ps.invoice_id = i.invoice_id
					and i.close_action_id is null
		group by p.product_id )prod
		group by prod.product_id) products ON products.product_category = cat.category_id
GROUP BY cat.category_id
ORDER By cat.category;
END//
DELIMITER ;

#Proc to add new product
DELIMITER //
CREATE PROCEDURE AddNewCategory(
         IN categoryName VARCHAR(100),
		 IN userID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('New category creation',actionID);
INSERT into category values (null,categoryName,userID,null,actionID);		
END//
DELIMITER ;

#Proc to add new product
DELIMITER //
CREATE PROCEDURE updateCategory(
		 IN categoryID INT,
         IN categoryName VARCHAR(100),
		 IN userID INT
         )
BEGIN	
	UPDATE category
	SET category = categoryName
	WHERE category_id =categoryID
	AND user_id =userID
	AND close_action_id is null;	
END//
DELIMITER ;

#Proc to delete a product
DELIMITER //
CREATE PROCEDURE deleteCategory(
		 IN categoryID INT,
		 IN userID INT
         )
BEGIN
DECLARE actionID INT DEFAULT 0;		
call generateActionID('Category Delete',actionID);

UPDATE category 
set 
    close_action_id = actionID
where
    category_id = categoryID
        and user_id = userID
		and close_action_id is null;

END//
DELIMITER ;

#Proc to update product price
DELIMITER //
CREATE PROCEDURE updateProductPrice(
		 IN productID INT,
		 IN costPrice DECIMAL(8,2),
		 IN dealerPrice DECIMAL(8,2),
		 IN marketPrice DECIMAL(8,2)
         )
BEGIN
DECLARE actionID INT DEFAULT 0;
DECLARE oldCostPrice DECIMAL(8,2) DEFAULT 0;
DECLARE oldDealerPrice DECIMAL(8,2) DEFAULT 0;
DECLARE oldMarketPrice DECIMAL(8,2) DEFAULT 0;		
call generateActionID('Update Product Price',actionID);

SELECT price into oldCostPrice
FROM price
WHERE product_id = productID
	AND price_type = 1
	AND close_action_id is null;

SELECT price into oldDealerPrice
FROM price
WHERE product_id = productID
	AND price_type = 4
	AND close_action_id is null;

SELECT price into oldMarketPrice
FROM price
WHERE product_id = productID
	AND price_type = 3
	AND close_action_id is null;

if costPrice != oldCostPrice then
	UPDATE price 
	SET 
		close_action_id = actionID
	WHERE
		product_id = productID
			AND price_type = 1
			AND close_action_id is null;
	INSERT into price values(null,productID,1,costPrice,null,actionID);
end if;

if dealerPrice != oldDealerPrice then
	UPDATE price 
	SET 
		close_action_id = actionID
	WHERE
		product_id = productID
			AND price_type = 4
			AND close_action_id is null;
	INSERT into price values(null,productID,4,dealerPrice,null,actionID);
end if;

if marketPrice != oldMarketPrice then
	UPDATE price 
	SET 
		close_action_id = actionID
	WHERE
		product_id = productID
			AND price_type = 3
			AND close_action_id is null;
	INSERT into price values(null,productID,3,marketPrice,null,actionID);
end if;
END//
DELIMITER ;

select count(*) from price 