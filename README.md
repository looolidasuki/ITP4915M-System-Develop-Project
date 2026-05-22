# E-Commerce System - SDP Database & Models Documentation

## Overview
This document describes the complete C# model classes and SQL database schema created for the Software Development Project (SDP) e-commerce system based on the provided Entity Relationship Diagram (ERD).

## Architecture

### Project Structure
```
SDP/
├── Models/
│   ├── User.cs
│   ├── UserRole.cs
│   ├── Product.cs
│   ├── ProductCategory.cs
│   ├── ProductInventory.cs
│   ├── ProductReview.cs
│   ├── Vendor.cs
│   ├── Order.cs
│   ├── OrderStatus.cs
│   ├── OrderItem.cs
│   ├── OrderPayment.cs
│   ├── PaymentMethod.cs
│   ├── PaymentStatus.cs
│   ├── OrderShipping.cs
│   ├── ShippingMethod.cs
│   ├── ShippingStatus.cs
│   ├── ShoppingCart.cs
│   └── ShoppingCartItem.cs
├── Database_Schema.sql
└── Database_SeedData.sql
```

## Core Entities

### 1. User Management
- **User**: Stores user account information with role-based access
- **UserRole**: Defines user roles (Admin, Customer, Vendor, Support)

### 2. Product Management
- **Product**: Main product entity with pricing and details
- **ProductCategory**: Hierarchical product categories with parent-child relationships
- **ProductInventory**: Tracks inventory levels by warehouse location
- **ProductReview**: Stores customer reviews and ratings
- **Vendor**: Manages third-party vendors/sellers

### 3. Shopping
- **ShoppingCart**: User shopping carts
- **ShoppingCartItem**: Individual items in shopping carts

### 4. Orders
- **Order**: Main order entity with status and totals
- **OrderStatus**: Order status types (Pending, Confirmed, Processing, etc.)
- **OrderItem**: Individual line items in orders
- **OrderPayment**: Payment information for orders
- **PaymentMethod**: Payment type options
- **PaymentStatus**: Payment status tracking
- **OrderShipping**: Shipping details and tracking
- **ShippingMethod**: Shipping options with costs
- **ShippingStatus**: Shipping status tracking

## Database Features

### Key Features
- **Referential Integrity**: Foreign key constraints ensure data consistency
- **Indexes**: Performance indexes on frequently queried columns
- **Audit Trail**: CreatedDate and ModifiedDate fields for tracking changes
- **Active Status**: IsActive flags for soft-delete functionality
- **Default Values**: GETUTCDATE() for automatic timestamp population

### Relationships
- **One-to-Many**: User → Orders, Product → Reviews, Product → Inventory
- **Many-to-Many**: Order ↔ Product (via OrderItem), Cart ↔ Product (via CartItem)
- **Hierarchical**: ProductCategory (parent-child relationship)

## C# Model Implementation

### Key Characteristics
- **Entity Framework Compatible**: Models designed for Entity Framework Core
- **Navigation Properties**: Collections for related entities
- **Data Annotations Ready**: Properties configured for database mapping
- **Strong Typing**: Appropriate data types for each property

### Example Model Structure
```csharp
public class Product
{
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public decimal Price { get; set; }
    public int CategoryId { get; set; }
    
    // Navigation properties
    public virtual ProductCategory Category { get; set; }
    public virtual ICollection<OrderItem> OrderItems { get; set; }
}
```

## Database Schema

### Tables Created (19 total)
1. UserRole
2. User
3. Vendor
4. ProductCategory
5. Product
6. ProductInventory
7. ProductReview
8. ShoppingCart
9. ShoppingCartItem
10. OrderStatus
11. Order
12. OrderItem
13. PaymentMethod
14. PaymentStatus
15. OrderPayment
16. ShippingMethod
17. ShippingStatus
18. OrderShipping

### Sample Data Included
- 2 user roles (Customer, Vendor)
- 2 sample users
- 2 vendors
- 5 product categories
- 5 sample products
- 2 sample orders with complete order items, payments, and shipping details

## Data Types

### SQL Server Data Types Used
- **INT**: Primary keys and foreign keys
- **NVARCHAR(n)**: Text fields with Unicode support
- **NVARCHAR(MAX)**: Large text fields (descriptions, notes)
- **DECIMAL(10, 2)**: Currency/monetary values
- **DATETIME**: Timestamps
- **BIT**: Boolean flags

## Security Considerations

1. **Password Storage**: User passwords should be hashed before storage
2. **Data Encryption**: Sensitive data like bank accounts should be encrypted
3. **Role-Based Access**: Implement authorization based on UserRole
4. **Audit Logging**: Track sensitive operations on orders and payments

## Setup Instructions

### 1. Create Database
Execute `Database_Schema.sql` to create all tables and indexes

### 2. Seed Data
Execute `Database_SeedData.sql` to populate initial data

### 3. Entity Framework Configuration
Add DbSet properties to your DbContext:
```csharp
public DbSet<User> Users { get; set; }
public DbSet<Product> Products { get; set; }
public DbSet<Order> Orders { get; set; }
// ... etc
```

### 4. Connection String
Configure your connection string in `appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=SDP;Integrated Security=true;"
  }
}
```

## Performance Optimization

### Indexes Created
- Email and Username lookups on User table
- Product category and vendor lookups
- Order and payment status lookups
- Shopping cart and inventory management
- Total of 20 indexes for optimal query performance

### Best Practices
- Use eager loading for navigation properties when needed
- Consider pagination for large result sets
- Monitor database performance and adjust indexes as needed
- Archive old orders periodically for optimal performance

## Future Enhancements

1. **Promotions/Coupons**: Add discount codes and promotional rules
2. **Product Variants**: Support for different product sizes/colors
3. **Supplier Management**: Track product suppliers separately
4. **Return Management**: Detailed return and refund processes
5. **Analytics**: Order analytics and reporting tables
6. **Notifications**: Customer notification preferences and history
