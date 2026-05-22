-- SDP Database Seed Data Script
-- This script populates initial reference data for the e-commerce system

-- Seed UserRole table
INSERT INTO UserRole (RoleName, Description) VALUES
    ('Admin', 'Administrator with full system access'),
    ('Customer', 'Regular customer user'),
    ('Vendor', 'Vendor/Seller user'),
    ('Support', 'Customer support staff');

-- Seed OrderStatus table
INSERT INTO OrderStatus (StatusName, Description) VALUES
    ('Pending', 'Order is pending confirmation'),
    ('Confirmed', 'Order has been confirmed'),
    ('Processing', 'Order is being processed'),
    ('Shipped', 'Order has been shipped'),
    ('Delivered', 'Order has been delivered'),
    ('Cancelled', 'Order has been cancelled'),
    ('Returned', 'Order has been returned');

-- Seed PaymentMethod table
INSERT INTO PaymentMethod (MethodName, Description, IsActive) VALUES
    ('Credit Card', 'Payment via credit card', 1),
    ('Debit Card', 'Payment via debit card', 1),
    ('PayPal', 'Payment via PayPal', 1),
    ('Bank Transfer', 'Direct bank transfer', 1),
    ('Cash on Delivery', 'Payment on delivery', 1);

-- Seed PaymentStatus table
INSERT INTO PaymentStatus (StatusName, Description) VALUES
    ('Pending', 'Payment is pending'),
    ('Completed', 'Payment has been completed'),
    ('Failed', 'Payment failed'),
    ('Refunded', 'Payment has been refunded'),
    ('Cancelled', 'Payment has been cancelled');

-- Seed ShippingMethod table
INSERT INTO ShippingMethod (MethodName, Description, BaseCost, IsActive) VALUES
    ('Standard Shipping', 'Standard ground shipping (5-7 business days)', 5.00, 1),
    ('Express Shipping', 'Express shipping (2-3 business days)', 15.00, 1),
    ('Overnight Shipping', 'Next day delivery', 25.00, 1),
    ('Local Pickup', 'Local store pickup', 0.00, 1);

-- Seed ShippingStatus table
INSERT INTO ShippingStatus (StatusName, Description) VALUES
    ('Not Shipped', 'Order not yet shipped'),
    ('In Transit', 'Order is in transit'),
    ('Out for Delivery', 'Order is out for delivery'),
    ('Delivered', 'Order has been delivered'),
    ('Delivery Failed', 'Delivery attempt failed'),
    ('Returned to Sender', 'Package returned to sender');

-- Seed sample Vendor
INSERT INTO Vendor (VendorName, Email, PhoneNumber, Address, City, State, PostalCode, Country, BankAccount, IsActive) VALUES
    ('Electronics Plus', 'vendor@electronicsplus.com', '+1-555-0001', '123 Business Ave', 'New York', 'NY', '10001', 'USA', 'ACC123456789', 1),
    ('Fashion Boutique', 'info@fashionboutique.com', '+1-555-0002', '456 Style St', 'Los Angeles', 'CA', '90001', 'USA', 'ACC987654321', 1);

-- Seed sample ProductCategory
INSERT INTO ProductCategory (CategoryName, Description, IsActive) VALUES
    ('Electronics', 'Electronic devices and accessories', 1),
    ('Computers', 'Computers and computer accessories', 1),
    ('Mobile Devices', 'Smartphones and tablets', 1),
    ('Fashion', 'Clothing and fashion items', 1),
    ('Footwear', 'Shoes and footwear', 1),
    ('Books', 'Books and publications', 1);

-- Update ProductCategory to add parent categories
UPDATE ProductCategory SET ParentCategoryId = 1 WHERE CategoryName IN ('Computers', 'Mobile Devices');

-- Seed sample Products
INSERT INTO Product (ProductName, Description, Price, DiscountPrice, CategoryId, SKU, Barcode, Weight, Height, Width, Depth, Color, Size, VendorId, IsActive) VALUES
    ('Laptop Pro', 'High-performance laptop with 16GB RAM', 1299.99, 1099.99, 2, 'SKU001', 'BAR001', 2000, 15, 35, 25, 'Silver', 'One Size', 1, 1),
    ('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, NULL, 2, 'SKU002', 'BAR002', 100, 5, 10, 8, 'Black', 'One Size', 1, 1),
    ('Smartphone X', 'Latest generation smartphone', 899.99, 799.99, 3, 'SKU003', 'BAR003', 200, 15, 8, 0, 'Black', 'One Size', 1, 1),
    ('T-Shirt Classic', 'Comfortable cotton t-shirt', 19.99, NULL, 4, 'SKU004', 'BAR004', 200, 30, 25, 2, 'Blue', 'M', 2, 1),
    ('Running Shoes', 'Professional running shoes', 89.99, 69.99, 5, 'SKU005', 'BAR005', 300, 30, 10, 12, 'Red', '10', 2, 1);

-- Seed ProductInventory
INSERT INTO ProductInventory (ProductId, WarehouseLocation, QuantityOnHand, ReorderLevel, LastRestockDate) VALUES
    (1, 'Warehouse A - Shelf 1', 50, 10, GETUTCDATE()),
    (2, 'Warehouse A - Shelf 2', 200, 50, GETUTCDATE()),
    (3, 'Warehouse B - Shelf 1', 75, 20, GETUTCDATE()),
    (4, 'Warehouse B - Shelf 3', 300, 100, GETUTCDATE()),
    (5, 'Warehouse C - Shelf 2', 150, 30, GETUTCDATE());

-- Seed sample User
INSERT INTO [User] (UserName, Email, Password, FirstName, LastName, PhoneNumber, Address, City, State, PostalCode, Country, UserRoleId, IsActive) VALUES
    ('john_doe', 'john@example.com', 'hashedpassword123', 'John', 'Doe', '+1-555-1234', '789 Customer St', 'Chicago', 'IL', '60601', 'USA', 2, 1),
    ('jane_smith', 'jane@example.com', 'hashedpassword456', 'Jane', 'Smith', '+1-555-5678', '321 Shopper Ave', 'Houston', 'TX', '77001', 'USA', 2, 1);

-- Seed ShoppingCart
INSERT INTO ShoppingCart (UserId) VALUES (1), (2);

-- Seed ShoppingCartItem
INSERT INTO ShoppingCartItem (CartId, ProductId, Quantity, UnitPrice) VALUES
    (1, 1, 1, 1099.99),
    (1, 2, 2, 29.99),
    (2, 3, 1, 799.99);

-- Seed sample Orders
INSERT INTO [Order] (UserId, TotalAmount, TaxAmount, ShippingCost, DiscountAmount, OrderStatusId, ShippingAddress, BillingAddress) VALUES
    (1, 1199.98, 95.99, 15.00, 50.00, 3, '789 Customer St, Chicago, IL 60601', '789 Customer St, Chicago, IL 60601'),
    (2, 899.99, 72.00, 5.00, 0.00, 2, '321 Shopper Ave, Houston, TX 77001', '321 Shopper Ave, Houston, TX 77001');

-- Seed OrderItem
INSERT INTO OrderItem (OrderId, ProductId, Quantity, UnitPrice, TotalPrice) VALUES
    (1, 1, 1, 1099.99, 1099.99),
    (1, 2, 1, 29.99, 29.99),
    (2, 3, 1, 799.99, 799.99);

-- Seed OrderPayment
INSERT INTO OrderPayment (OrderId, PaymentMethodId, Amount, PaymentStatusId, TransactionNumber) VALUES
    (1, 1, 1199.98, 2, 'TXN001'),
    (2, 3, 899.99, 2, 'TXN002');

-- Seed OrderShipping
INSERT INTO OrderShipping (OrderId, ShippingMethodId, ShippingStatusId, TrackingNumber, ShippingCost) VALUES
    (1, 2, 2, 'TRACK001', 15.00),
    (2, 1, 1, 'TRACK002', 5.00);

-- Seed ProductReview
INSERT INTO ProductReview (ProductId, UserId, Rating, ReviewTitle, ReviewText, IsApproved) VALUES
    (1, 1, 5, 'Excellent Laptop', 'Great performance and build quality', 1),
    (3, 2, 4, 'Good Phone', 'Good phone with minor issues', 1);
