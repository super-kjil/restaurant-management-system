-- Here’s the revised version of the database schema including the Customer table and a clearer separation between customer-related information and other types of users (e.g., staff and admin).


-- 1. Customer Table
-- Stores information about customers using the system.

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    DateJoined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Users Table (for Admin/Staff)
-- Stores information about system users (staff and admin).

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserName VARCHAR(100) NOT NULL,
    UserType ENUM('Staff', 'Admin') NOT NULL,
    Email VARCHAR(100),
    Password VARCHAR(255),
    ContactNumber VARCHAR(15),
    DateCreated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tables Table
-- Stores the restaurant table information, including QR codes associated with each table.

CREATE TABLE Tables (
    TableID INT PRIMARY KEY AUTO_INCREMENT,
    TableNumber INT NOT NULL,
    MaxSeats INT,
    QRCodeURL VARCHAR(255)
);

-- 4. Category Table
-- Stores menu categories like appetizers, main courses, desserts, etc.

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    Description TEXT
);

-- 5. Size Table
-- Stores the available sizes for menu items, such as small, medium, and large.

CREATE TABLE Size (
    SizeID INT PRIMARY KEY AUTO_INCREMENT,
    SizeName VARCHAR(50) NOT NULL,
    Description TEXT,
    AdditionalPrice DECIMAL(10, 2)
);

-- 6. Menu Table
-- Stores details of the menu items available for customers to order.

CREATE TABLE Menu (
    MenuID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(100) NOT NULL,
    CategoryID INT,
    SizeAvailable BOOLEAN DEFAULT FALSE,
    Price DECIMAL(10, 2) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- 7. Orders Table
-- Stores information about customer orders.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TableID INT,
    OrderStatus ENUM('Pending', 'In Progress', 'Served', 'Paid') DEFAULT 'Pending',
    OrderTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalPrice DECIMAL(10, 2),
    PaymentStatus ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

-- 8. Order Items Table
-- Stores the individual items that are part of each order.

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    MenuID INT,
    SizeID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID),
    FOREIGN KEY (SizeID) REFERENCES Size(SizeID)
);

-- 9. Payments Table

-- Stores payment details for each order.

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentType ENUM('Pay Before', 'Pay After') NOT NULL,
    PaymentMethod ENUM('Card', 'Cash', 'Mobile Payment') NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    AmountPaid DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 10. Sales Analytics Table
-- Stores historical sales data for analytics purposes.

CREATE TABLE SalesAnalytics (
    SalesID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ItemName VARCHAR(100),
    CategoryID INT,
    Quantity INT,
    TotalSales DECIMAL(10, 2),
    OrderDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- 11. Data Analytics Table
-- Stores predicted and actual sales data for machine learning and forecasting.

CREATE TABLE DataAnalytics (
    AnalyticsID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE,
    PredictedSales DECIMAL(10, 2),
    ActualSales DECIMAL(10, 2)
);

-- 12. Feedback Table
-- Stores customer feedback about their experience.

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TableID INT,
    OrderID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comments TEXT,
    FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

Revised Entity-Relationship Diagram (ERD):

 • Customers place orders for items.
 • Orders are associated with tables and have multiple order items.
 • Order Items reference menu items and their sizes.
 • Payments are linked to orders.
 • Feedback is given for orders, referencing both the customer and the table.

Key Relationships:

 • One-to-Many between Customer and Orders.
 • One-to-Many between Orders and Order Items.
 • Many-to-One between Order Items and Menu.
 • One-to-One between Orders and Payments.
 • One-to-Many between Category and Menu.
 • One-to-Many between Size and Order Items.

This updated structure clearly distinguishes customers from other users and integrates them into the ordering and feedback processes effectively.