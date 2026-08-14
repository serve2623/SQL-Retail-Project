CREATE TABLE Customers
(
	customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(20) NOT NULL
		CONSTRAINT chk_gender CHECK (gender IN ('Female','Male','Non-Binary','Other','Prefer Not To Say')),
	date_of_birth DATE NOT NULL,
	date_of_joining DATE NOT NULL,
	phone_number VARCHAR(20) UNIQUE NOT NULL,
	"e-mail_address" VARCHAR(50) UNIQUE NOT NULL,
	updated_at DATE  NOT NULL
)
;


CREATE TABLE Customer_Addresses
(
	customer_id INT REFERENCES Customers(customer_id),
	address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	street_name VARCHAR(50) NOT NULL,
	street_number VARCHAR(10) NOT NULL,
	suburb VARCHAR(50),
	city VARCHAR(50) NOT NULL,
	postcode VARCHAR(50) NOT NULL
)
;


CREATE TABLE Categories
(
	category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	category_name VARCHAR(50) NOT NULL
)
;


CREATE TABLE Product
(
	product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	category_id INT REFERENCES Categories(category_id),
	name VARCHAR(100) NOT NULL,
	unit_price NUMERIC(10,2) NOT NULL,
	SKU VARCHAR(20) NOT NULL,
	number_in_stock INT NOT NULL,
	description VARCHAR(500),
	product_status VARCHAR(20) NOT NULL,
		CONSTRAINT chk_prod_status CHECK (product_status IN ('active', 'discontinued')),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP
)
;


CREATE TABLE Orders
(
	order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id) NOT NULL,
	order_date TIMESTAMP NOT NULL,
	delivery_status VARCHAR(20) NOT NULL,
		CONSTRAINT chk_delivery_status CHECK (delivery_status IN ('pending', 'shipped', 'delivered', 'cancelled')),
	address_id INT REFERENCES Customer_Addresses(address_id) NOT NULL,
	payment_status VARCHAR(20) NOT NULL,
		CONSTRAINT chk_payment_status CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
	payment_method VARCHAR(20) 
		CONSTRAINT chk_payment_method CHECK (payment_method IN ('credit_card','paypal','bank_transfer')) NOT NULL
)
;


CREATE TABLE Order_Item
(
	order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_id INT REFERENCES Orders(order_id) NOT NULL,
	product_id INT REFERENCES Product(product_id) NOT NULL,
	quantity INT NOT NULL,
	unit_price NUMERIC(10,2) NOT NULL
)
;
