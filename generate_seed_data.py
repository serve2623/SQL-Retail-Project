import csv
from datetime import datetime
from faker import Faker
import faker_commerce
import random


def unit_price_finder(target_id):
    unit_price = []
    for prod in product:
        if prod['product_id'] == target_id:
            unit_price.append(prod['unit_price'])
            return unit_price[0]
     
fake = Faker("en_AU")
fake.add_provider(faker_commerce.Provider)


genders = ['Female','Male','Non-Binary','Other','Prefer Not To Say']

customer = []
for i in range (1, 76):
        date = fake.date_between(start_date='-5y', end_date='today')
        customer.append({
            'customer_id': i,
            'first_name': fake.first_name(),
            'last_name': fake.last_name(),
            'gender': fake.random_element(elements=genders),
            'date_of_birth': fake.date_of_birth(minimum_age=18, maximum_age=90),
            'date_of_joining': date,
            'phone_number': fake.phone_number(),
            'e-mail_address': fake.email(),
            'updated_at': date
    })


customer_addresses = []
customer_ids = [c['customer_id'] for c in customer]
for i in range (1, 51):
     customer_addresses.append({
          'address_id': i,
          'customer_id': random.choice(customer_ids),
          'street_name': fake.street_name(),
          'street_number': fake.building_number(),
          'city': fake.city(),
          'postcode': fake.postcode()
     })


categories = []
for i in range (1, 11):
     categories.append({
        'category_id': i,
        'category_name': fake.ecommerce_category(),
     })


product = []
category_id = [c['category_id'] for c in categories]
product_status = ['active', 'discontinued']
for i in range (1, 51):
    unit_price = fake.pydecimal(left_digits=3, right_digits=2, positive=True)
    start = datetime(2024, 1, 1)
    end = datetime(2026, 6, 30)
    date = fake.date_time_between(start_date=start, end_date=end)
    product.append({
         'product_id': i,
         'category_id': random.choice(category_id),
         'name': fake.ecommerce_name(),
         'unit_price': unit_price,
         'SKU': fake.bothify(text="????-####-??"),
         'number_in_stock': fake.random_int(min=0, max=100),
         'description': fake.text(),
         'product_status': random.choice(product_status),
         'created_at': date,
         'updated_at': date
    })


orders = []
address_id = [a['address_id'] for a in customer_addresses]
customer_ids = [c['customer_id'] for c in customer]
delivery_status = ['pending', 'shipped', 'delivered', 'cancelled']
payment_status = ['pending', 'paid', 'failed', 'refunded']
payment_method = ['credit_card','paypal','bank_transfer']
for i in range (1, 201):
     start = datetime(2024, 1, 1)
     end = datetime(2026, 6, 30)
     date = fake.date_time_between(start_date=start, end_date=end)
     orders.append({
        'order_id': i,
        'customer_id': random.choice(customer_ids),
        'order_date': date,
        'delivery_status': random.choice(delivery_status),
        'address_id': random.choice(address_id),
        'payment_status': random.choice(payment_status),
        'payment_method': random.choice(payment_method)
     })


order_item = []
order_id = [o['order_id'] for o in orders]
product_id = [p['product_id'] for p in product]

for i in range (1, 501):
    chosen_product_id = random.choice(product_id)
    order_item.append({
        'order_item_id': i,
        'order_id': random.choice(order_id),
        'product_id': chosen_product_id,
        'quantity': fake.random_int(min=1, max=99),
        'unit_price': unit_price_finder(chosen_product_id)
    })


with open ('data/02_seed_data.sql', 'w') as f:
    for c in customer:
        f.write(
            f"INSERT INTO customers (first_name, last_name, gender, date_of_birth, "
            f"date_of_joining, phone_number, \"e-mail_address\", updated_at) VALUES " 
            f"('{c['first_name']}', '{c['last_name']}', '{c['gender']}', '{c['date_of_birth']}', "
            f"'{c['date_of_joining']}', '{c['phone_number']}', '{c['e-mail_address']}', '{c['updated_at']}');\n"
        )


with open ('data/02_seed_data.sql', 'a') as f:
    for c in customer_addresses:
        f.write(
            f"INSERT INTO customer_addresses (customer_id, street_name, street_number, city, postcode) VALUES " 
            f"('{c['customer_id']}', '{c['street_name']}', '{c['street_number']}', '{c['city']}', '{c['postcode']}');\n"
        )


with open ('data/02_seed_data.sql', 'a') as f:
     for c in categories:
          f.write(
            f"INSERT INTO categories (category_name) VALUES " 
            f"('{c['category_name']}');\n"
          )


with open ('data/02_seed_data.sql', 'a') as f:
     for p in product:
          f.write(
            f"INSERT INTO product (category_id, name, unit_price, SKU, "
            f"number_in_stock, description, product_status, created_at, updated_at) VALUES " 
            f"('{p['category_id']}', '{p['name']}', '{p['unit_price']}', '{p['SKU']}', "
            f"'{p['number_in_stock']}', '{p['description']}', '{p['product_status']}', '{p['created_at']}', '{p['updated_at']}');\n"
        )


with open ('data/02_seed_data.sql', 'a') as f:
     for o in orders:
          f.write(
            f"INSERT INTO orders (customer_id, order_date, delivery_status, "
            f"address_id, payment_status, payment_method) VALUES " 
            f"('{o['customer_id']}', '{o['order_date']}', '{o['delivery_status']}', "
            f"'{o['address_id']}', '{o['payment_status']}', '{o['payment_method']}');\n"
        )


with open ('data/02_seed_data.sql', 'a') as f:
     for o in order_item:
          f.write(
            f"INSERT INTO order_item (order_id, product_id, quantity, unit_price) VALUES "
            f"('{o['order_id']}', '{o['product_id']}', '{o['quantity']}', '{o['unit_price']}');\n"
        )