-- SDP Database Schema Creation Script
-- This script creates all necessary tables for the e-commerce system

-- Create UserRole table
CREATE TABLE UserRole (
    UserRoleId INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- Create User table
CREATE TABLE [User] (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    UserRoleId INT NOT NULL,
    FOREIGN KEY (UserRoleId) REFERENCES UserRole(UserRoleId)
);

-- Create Vendor table
CREATE TABLE Vendor (
    VendorId INT PRIMARY KEY IDENTITY(1,1),
    VendorName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    BankAccount NVARCHAR(50),
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1
);

-- Create ProductCategory table
CREATE TABLE ProductCategory (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    ParentCategoryId INT,
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (ParentCategoryId) REFERENCES ProductCategory(CategoryId)
);

-- Create Product table
CREATE TABLE Product (
    ProductId INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    DiscountPrice DECIMAL(10, 2),
    CategoryId INT NOT NULL,
    SKU NVARCHAR(50) UNIQUE,
    Barcode NVARCHAR(50),
    Weight INT,
    Height INT,
    Width INT,
    Depth INT,
    Color NVARCHAR(50),
    Size NVARCHAR(50),
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    VendorId INT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES ProductCategory(CategoryId),
    FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId)
);

-- Create ProductInventory table
CREATE TABLE ProductInventory (
    InventoryId INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT NOT NULL,
    WarehouseLocation NVARCHAR(100),
    QuantityOnHand INT NOT NULL,
    ReorderLevel INT,
    LastRestockDate DATETIME NOT NULL,
    ModifiedDate DATETIME,
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
);

-- Create ProductReview table
CREATE TABLE ProductReview (
    ReviewId INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT NOT NULL,
    UserId INT NOT NULL,
    Rating INT NOT NULL,
    ReviewTitle NVARCHAR(200),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    IsApproved BIT NOT NULL DEFAULT 0,
    HelpfulCount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId),
    FOREIGN KEY (UserId) REFERENCES [User](UserId)
);

-- Create ShoppingCart table
CREATE TABLE ShoppingCart (
    CartId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL UNIQUE,
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    ModifiedDate DATETIME,
    FOREIGN KEY (UserId) REFERENCES [User](UserId)
);

-- Create ShoppingCartItem table
CREATE TABLE ShoppingCartItem (
    CartItemId INT PRIMARY KEY IDENTITY(1,1),
    CartId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    AddedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY (CartId) REFERENCES ShoppingCart(CartId),
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
);

-- Create OrderStatus table
CREATE TABLE OrderStatus (
    OrderStatusId INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- Create Order table
CREATE TABLE [Order] (
    OrderId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    TaxAmount DECIMAL(10, 2),
    ShippingCost DECIMAL(10, 2),
    DiscountAmount DECIMAL(10, 2),
    OrderStatusId INT NOT NULL,
    ShippingAddress NVARCHAR(255),
    BillingAddress NVARCHAR(255),
    SpecialNotes NVARCHAR(MAX),
    ModifiedDate DATETIME,
    FOREIGN KEY (UserId) REFERENCES [User](UserId),
    FOREIGN KEY (OrderStatusId) REFERENCES OrderStatus(OrderStatusId)
);

-- Create OrderItem table
CREATE TABLE OrderItem (
    OrderItemId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    DiscountAmount DECIMAL(10, 2),
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
);

-- Create PaymentMethod table
CREATE TABLE PaymentMethod (
    PaymentMethodId INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- Create PaymentStatus table
CREATE TABLE PaymentStatus (
    PaymentStatusId INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- Create OrderPayment table
CREATE TABLE OrderPayment (
    PaymentId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    PaymentMethodId INT NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentStatusId INT NOT NULL,
    TransactionNumber NVARCHAR(100),
    FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(PaymentMethodId),
    FOREIGN KEY (PaymentStatusId) REFERENCES PaymentStatus(PaymentStatusId)
);

-- Create ShippingMethod table
CREATE TABLE ShippingMethod (
    ShippingMethodId INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    BaseCost DECIMAL(10, 2),
    IsActive BIT NOT NULL DEFAULT 1
);

-- Create ShippingStatus table
CREATE TABLE ShippingStatus (
    ShippingStatusId INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- Create OrderShipping table
CREATE TABLE OrderShipping (
    ShippingId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    ShippingMethodId INT NOT NULL,
    ShippingDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    DeliveryDate DATETIME,
    ShippingStatusId INT NOT NULL,
    TrackingNumber NVARCHAR(100),
    ShippingCost DECIMAL(10, 2),
    FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
    FOREIGN KEY (ShippingMethodId) REFERENCES ShippingMethod(ShippingMethodId),
    FOREIGN KEY (ShippingStatusId) REFERENCES ShippingStatus(ShippingStatusId)
);

-- Create Indexes for better query performance
CREATE INDEX IX_User_Email ON [User](Email);
CREATE INDEX IX_User_UserName ON [User](UserName);
CREATE INDEX IX_Product_CategoryId ON Product(CategoryId);
CREATE INDEX IX_Product_VendorId ON Product(VendorId);
CREATE INDEX IX_ProductReview_ProductId ON ProductReview(ProductId);
CREATE INDEX IX_ProductReview_UserId ON ProductReview(UserId);
CREATE INDEX IX_Order_UserId ON [Order](UserId);
CREATE INDEX IX_Order_OrderStatusId ON [Order](OrderStatusId);
CREATE INDEX IX_OrderItem_OrderId ON OrderItem(OrderId);
CREATE INDEX IX_OrderItem_ProductId ON OrderItem(ProductId);
CREATE INDEX IX_OrderPayment_OrderId ON OrderPayment(OrderId);
CREATE INDEX IX_OrderPayment_PaymentMethodId ON OrderPayment(PaymentMethodId);
CREATE INDEX IX_OrderPayment_PaymentStatusId ON OrderPayment(PaymentStatusId);
CREATE INDEX IX_OrderShipping_OrderId ON OrderShipping(OrderId);
CREATE INDEX IX_OrderShipping_ShippingStatusId ON OrderShipping(ShippingStatusId);
CREATE INDEX IX_ShoppingCart_UserId ON ShoppingCart(UserId);
CREATE INDEX IX_ShoppingCartItem_CartId ON ShoppingCartItem(CartId);
CREATE INDEX IX_ShoppingCartItem_ProductId ON ShoppingCartItem(ProductId);
CREATE INDEX IX_ProductInventory_ProductId ON ProductInventory(ProductId);
