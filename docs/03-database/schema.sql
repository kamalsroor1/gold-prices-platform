-- هيكلية قاعدة البيانات النهائية للمنصة

CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    flag_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول أسعار الصرف (العملة المحلية مقابل الدولار)
CREATE TABLE exchange_rates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    rate DECIMAL(15, 6) NOT NULL, -- سعر الصرف
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE gold_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    karat INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id),
    UNIQUE(country_id, karat)
);

CREATE TABLE gold_price_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    karat INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE gold_price_candles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    karat INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    open_time TIMESTAMP NOT NULL,
    close_time TIMESTAMP NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE brands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(255),
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- تحديث جدول المنتجات ليرتبط بالعيار
CREATE TABLE gold_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    weight DECIMAL(10, 2) NOT NULL,
    karat INT NOT NULL -- عيار الذهب للمنتج
);

-- تحديث قواعد التسعير لتشمل الضرائب والرسوم
CREATE TABLE pricing_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    product_id INT NOT NULL,
    premium_per_gram DECIMAL(10, 2) NOT NULL,
    cashback_per_gram DECIMAL(10, 2) NOT NULL,
    tax_percentage DECIMAL(5, 2) DEFAULT 0.00, -- ضريبة النسبة المئوية
    fixed_fees DECIMAL(10, 2) DEFAULT 0.00,    -- رسوم ثابتة
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (product_id) REFERENCES gold_products(id)
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    country_id INT NOT NULL,
    karat INT NOT NULL,
    target_price DECIMAL(15, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE watchlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES gold_products(id)
);
