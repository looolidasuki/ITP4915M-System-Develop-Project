-- SDP Database Setup Instructions
-- Step-by-step guide to set up the database

-- ============================================
-- STEP 1: Create the Database
-- ============================================
-- Run this command in SQL Server Management Studio
-- OR modify if using a different approach

-- IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SDP')
-- BEGIN
--     ALTER DATABASE SDP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--     DROP DATABASE SDP;
-- END
-- GO
-- CREATE DATABASE SDP;
-- GO

-- ============================================
-- STEP 2: Execute Database Schema
-- ============================================
-- Run the entire Database_Schema.sql file
-- This will create all 18 tables and 20 indexes

-- ============================================
-- STEP 3: Execute Seed Data
-- ============================================
-- Run the entire Database_SeedData.sql file
-- This will populate reference data and sample records

-- ============================================
-- STEP 4: Verify Installation
-- ============================================
-- Run these verification queries:

-- Check all tables created
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' ORDER BY TABLE_NAME;

-- Check row counts
SELECT 
    '[User]' AS TableName, COUNT(*) AS RowCount FROM [User]
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'Order', COUNT(*) FROM [Order]
UNION ALL
SELECT 'OrderItem', COUNT(*) FROM OrderItem
UNION ALL
SELECT 'ProductCategory', COUNT(*) FROM ProductCategory
UNION ALL
SELECT 'UserRole', COUNT(*) FROM UserRole
UNION ALL
SELECT 'Vendor', COUNT(*) FROM Vendor
ORDER BY TableName;

-- ============================================
-- STEP 5: .NET Entity Framework Setup
-- ============================================
-- In your .NET Project, add NuGet packages:
-- - Microsoft.EntityFrameworkCore
-- - Microsoft.EntityFrameworkCore.SqlServer
-- - Microsoft.EntityFrameworkCore.Tools

-- Command Line (Package Manager Console):
-- Install-Package Microsoft.EntityFrameworkCore
-- Install-Package Microsoft.EntityFrameworkCore.SqlServer
-- Install-Package Microsoft.EntityFrameworkCore.Tools

-- ============================================
-- STEP 6: Add Connection String
-- ============================================
-- In appsettings.json add:
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(local);Database=SDP;Integrated Security=true;Encrypt=false;TrustServerCertificate=true;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}

-- ============================================
-- STEP 7: Configure Dependency Injection
-- ============================================
-- In Program.cs or Startup.cs add:

-- builder.Services.AddDbContext<SdpDbContext>(options =>
--     options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

-- ============================================
-- STEP 8: Create Migrations (if using Code-First approach)
-- ============================================
-- In Package Manager Console:
-- Add-Migration InitialCreate
-- Update-Database

-- ============================================
-- Useful SQL Queries for Development
-- ============================================

-- Get all products with inventory
SELECT 
    p.ProductId,
    p.ProductName,
    p.Price,
    c.CategoryName,
    v.VendorName,
    pi.QuantityOnHand,
    pi.WarehouseLocation
FROM Product p
INNER JOIN ProductCategory c ON p.CategoryId = c.CategoryId
INNER JOIN Vendor v ON p.VendorId = v.VendorId
LEFT JOIN ProductInventory pi ON p.ProductId = pi.ProductId
ORDER BY p.ProductName;

-- Get all orders with user and status
SELECT 
    o.OrderId,
    u.UserName,
    u.Email,
    o.OrderDate,
    o.TotalAmount,
    os.StatusName,
    COUNT(oi.OrderItemId) AS ItemCount
FROM [Order] o
INNER JOIN [User] u ON o.UserId = u.UserId
INNER JOIN OrderStatus os ON o.OrderStatusId = os.OrderStatusId
LEFT JOIN OrderItem oi ON o.OrderId = oi.OrderId
GROUP BY o.OrderId, u.UserName, u.Email, o.OrderDate, o.TotalAmount, os.StatusName
ORDER BY o.OrderDate DESC;

-- Get product reviews with ratings
SELECT 
    p.ProductName,
    u.UserName,
    pr.Rating,
    pr.ReviewTitle,
    pr.ReviewText,
    pr.ReviewDate,
    pr.IsApproved
FROM ProductReview pr
INNER JOIN Product p ON pr.ProductId = p.ProductId
INNER JOIN [User] u ON pr.UserId = u.UserId
ORDER BY pr.ReviewDate DESC;

-- Get inventory low stock alerts
SELECT 
    p.ProductId,
    p.ProductName,
    pi.QuantityOnHand,
    pi.ReorderLevel,
    (pi.ReorderLevel - pi.QuantityOnHand) AS QuantityToReorder,
    pi.WarehouseLocation
FROM Product p
INNER JOIN ProductInventory pi ON p.ProductId = pi.ProductId
WHERE pi.QuantityOnHand <= pi.ReorderLevel
ORDER BY (pi.ReorderLevel - pi.QuantityOnHand) DESC;

-- Get pending orders requiring action
SELECT 
    o.OrderId,
    u.UserName,
    o.OrderDate,
    o.TotalAmount,
    os.StatusName,
    os2.StatusName AS PaymentStatus,
    ss.StatusName AS ShippingStatus
FROM [Order] o
INNER JOIN [User] u ON o.UserId = u.UserId
INNER JOIN OrderStatus os ON o.OrderStatusId = os.OrderStatusId
LEFT JOIN OrderPayment op ON o.OrderId = op.OrderId
LEFT JOIN PaymentStatus os2 ON op.PaymentStatusId = os2.PaymentStatusId
LEFT JOIN OrderShipping osh ON o.OrderId = osh.OrderId
LEFT JOIN ShippingStatus ss ON osh.ShippingStatusId = ss.ShippingStatusId
WHERE os.StatusName IN ('Pending', 'Processing')
ORDER BY o.OrderDate;

-- ============================================
-- Database Maintenance
-- ============================================

-- Rebuild all indexes
-- EXEC sp_MSForEachTable 'DBCC DBREINDEX (''?'')'

-- Update statistics
-- EXEC sp_updatestats

-- Check database integrity
-- DBCC CHECKDB (SDP, REPAIR_REBUILD)

-- ============================================
-- Backup Database
-- ============================================

-- BACKUP DATABASE SDP
-- TO DISK = 'C:\Backups\SDP_$(DATE).bak'
-- WITH INIT, COMPRESSION, STATS = 10;

-- ============================================
-- Troubleshooting
-- ============================================

-- If you need to reset the database:
-- 1. Delete the database
-- 2. Run Database_Schema.sql to recreate tables
-- 3. Run Database_SeedData.sql to add sample data

-- If migrations are out of sync:
-- Remove-Migration (in Package Manager Console)
-- Update-Database -TargetMigration:0
-- Add-Migration InitialCreate
-- Update-Database

-- Common Issues and Solutions:
-- Issue: "Cannot insert duplicate key in object 'dbo.UserRole'"
-- Solution: Check if seed data script has been run; may need to drop and recreate tables

-- Issue: "The MERGE statement attempted to UPDATE or DELETE the same row more than once"
-- Solution: Check for duplicate keys in seed data or remove duplicates

-- Issue: "Timeout expired. The timeout period elapsed prior to completing the operation"
-- Solution: Increase CommandTimeout in DbContext configuration
