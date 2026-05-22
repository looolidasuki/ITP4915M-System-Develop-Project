# SDP E-Commerce API Documentation

## Overview
RESTful API for the SDP (Software Development Project) e-commerce system. This API provides endpoints for managing products, orders, users, shopping carts, and inventory.

## Base URL
```
http://localhost:5000/api
```

## Authentication
*Note: Add Bearer token authentication as needed based on your security requirements*

---

## API Endpoints

### 1. Products Controller
Base endpoint: `/api/products`

#### Get All Products
```
GET /api/products
```
**Response:** Array of Product objects with related Category, Vendor, and Inventory

#### Get Product by ID
```
GET /api/products/{id}
```
**Response:** Product object with full details including reviews

#### Create Product
```
POST /api/products
Content-Type: application/json

{
  "productName": "New Product",
  "description": "Product description",
  "price": 99.99,
  "categoryId": 1,
  "vendorId": 1,
  "sku": "SKU123",
  "isActive": true
}
```

#### Update Product
```
PUT /api/products/{id}
Content-Type: application/json

{
  "productId": 1,
  "productName": "Updated Name",
  ...
}
```

#### Delete Product (Soft Delete)
```
DELETE /api/products/{id}
```

#### Get Products by Category
```
GET /api/products/category/{categoryId}
```

#### Search Products
```
GET /api/products/search?term=laptop
```

---

### 2. Orders Controller
Base endpoint: `/api/orders`

#### Get All Orders
```
GET /api/orders
```
**Response:** Array of Orders with User, Status, and Items

#### Get Order by ID
```
GET /api/orders/{id}
```
**Response:** Complete order with items, payments, and shipping details

#### Create Order
```
POST /api/orders
Content-Type: application/json

{
  "userId": 1,
  "totalAmount": 199.99,
  "taxAmount": 15.99,
  "shippingCost": 10.00,
  "orderStatusId": 1,
  "shippingAddress": "123 Main St, City, State 12345",
  "billingAddress": "123 Main St, City, State 12345"
}
```

#### Update Order
```
PUT /api/orders/{id}
Content-Type: application/json

{
  "orderId": 1,
  "totalAmount": 199.99,
  ...
}
```

#### Get User Orders
```
GET /api/orders/user/{userId}
```

#### Get Orders by Status
```
GET /api/orders/status/{statusId}
```

#### Update Order Status
```
PUT /api/orders/{id}/status/{statusId}
```

---

### 3. Users Controller
Base endpoint: `/api/users`

#### Get All Users
```
GET /api/users
```

#### Get User by ID
```
GET /api/users/{id}
```

#### Create User
```
POST /api/users
Content-Type: application/json

{
  "userName": "john_doe",
  "email": "john@example.com",
  "password": "hashedpassword",
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+1-555-1234",
  "address": "123 Main St",
  "city": "New York",
  "state": "NY",
  "postalCode": "10001",
  "country": "USA",
  "userRoleId": 2
}
```

#### Update User
```
PUT /api/users/{id}
Content-Type: application/json

{
  "userId": 1,
  "userName": "john_doe",
  ...
}
```

#### Get User by Email
```
GET /api/users/email/{email}
```

#### Get User Orders
```
GET /api/users/{id}/orders
```

#### Get User Reviews
```
GET /api/users/{id}/reviews
```

#### Delete User (Soft Delete)
```
DELETE /api/users/{id}
```

---

### 4. Shopping Carts Controller
Base endpoint: `/api/shoppingcarts`

#### Get Cart by User ID
```
GET /api/shoppingcarts/{userId}
```
**Response:** Shopping cart with all items and product details

#### Create Cart
```
POST /api/shoppingcarts
Content-Type: application/json

{
  "userId": 1
}
```

#### Add Item to Cart
```
POST /api/shoppingcarts/{cartId}/items
Content-Type: application/json

{
  "productId": 1,
  "quantity": 2,
  "unitPrice": 99.99
}
```

#### Update Cart Item
```
PUT /api/shoppingcarts/{cartId}/items/{itemId}
Content-Type: application/json

{
  "quantity": 3,
  "unitPrice": 99.99
}
```

#### Remove Item from Cart
```
DELETE /api/shoppingcarts/{cartId}/items/{itemId}
```

#### Clear Cart
```
DELETE /api/shoppingcarts/{cartId}
```

#### Get Cart Total
```
GET /api/shoppingcarts/{cartId}/total
```
**Response:** 
```json
{
  "total": 199.98
}
```

---

### 5. Product Reviews Controller
Base endpoint: `/api/productreviews`

#### Get Product Reviews
```
GET /api/productreviews/product/{productId}
```
**Response:** Array of approved reviews for the product

#### Get Review by ID
```
GET /api/productreviews/{id}
```

#### Create Review
```
POST /api/productreviews
Content-Type: application/json

{
  "productId": 1,
  "userId": 1,
  "rating": 5,
  "reviewTitle": "Excellent Product",
  "reviewText": "This product exceeded my expectations...",
  "isApproved": false
}
```

#### Update Review
```
PUT /api/productreviews/{id}
Content-Type: application/json

{
  "reviewId": 1,
  "rating": 4,
  ...
}
```

#### Delete Review
```
DELETE /api/productreviews/{id}
```

#### Approve Review
```
PUT /api/productreviews/{id}/approve
```

#### Get User Reviews
```
GET /api/productreviews/user/{userId}
```

#### Get Product Rating
```
GET /api/productreviews/product/{productId}/rating
```
**Response:**
```json
{
  "averageRating": 4.5,
  "totalReviews": 12
}
```

---

### 6. Inventory Controller
Base endpoint: `/api/inventory`

#### Get Product Inventory
```
GET /api/inventory/product/{productId}
```

#### Get Inventory by ID
```
GET /api/inventory/{inventoryId}
```

#### Create Inventory Record
```
POST /api/inventory
Content-Type: application/json

{
  "productId": 1,
  "warehouseLocation": "Warehouse A - Shelf 1",
  "quantityOnHand": 100,
  "reorderLevel": 20
}
```

#### Update Inventory
```
PUT /api/inventory/{inventoryId}
Content-Type: application/json

{
  "inventoryId": 1,
  "quantityOnHand": 95,
  "reorderLevel": 20
}
```

#### Get Low Stock Items
```
GET /api/inventory/lowstock
```
**Response:** Array of items with quantity below reorder level

#### Adjust Inventory Quantity
```
PUT /api/inventory/{inventoryId}/adjust
Content-Type: application/json

5
```
*Positive number to add, negative to subtract*

#### Get Inventory by Location
```
GET /api/inventory/warehouse/{location}
```

---

## Common Response Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 204 | No Content - Request successful (no content to return) |
| 400 | Bad Request - Invalid request data |
| 404 | Not Found - Resource not found |
| 500 | Internal Server Error - Server error |

---

## Error Response Format

```json
{
  "error": "Description of the error",
  "message": "Detailed error message",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

---

## Sample Workflow: Create Order

### Step 1: Get User
```
GET /api/users/1
```

### Step 2: Get Shopping Cart
```
GET /api/shoppingcarts/1
```

### Step 3: Create Order
```
POST /api/orders
{
  "userId": 1,
  "totalAmount": 199.99,
  "taxAmount": 15.99,
  "shippingCost": 10.00,
  "orderStatusId": 1,
  "shippingAddress": "123 Main St, City, State 12345",
  "billingAddress": "123 Main St, City, State 12345"
}
```

### Step 4: Add Order Items
```
POST /api/orders/1/items
{
  "productId": 1,
  "quantity": 2,
  "unitPrice": 99.99,
  "totalPrice": 199.98
}
```

### Step 5: Clear Shopping Cart
```
DELETE /api/shoppingcarts/1
```

---

## Rate Limiting
*Implement as needed based on requirements*

---

## Pagination
*Add pagination parameters to list endpoints as needed*

Example:
```
GET /api/products?page=1&pageSize=20
```

---

## Filtering & Sorting
*Add query parameters for advanced filtering*

Example:
```
GET /api/orders?status=pending&sortBy=orderDate&order=desc
```

---

## Deployment Checklist

- [ ] Add authentication/authorization
- [ ] Add request validation
- [ ] Add error handling middleware
- [ ] Enable CORS if needed
- [ ] Add logging
- [ ] Add API versioning
- [ ] Document authentication scheme
- [ ] Set up rate limiting
- [ ] Add API documentation (Swagger)
- [ ] Configure environment-specific settings
- [ ] Add performance monitoring
- [ ] Configure database backups

---

## Development Notes

- All API endpoints return JSON
- Use HTTP status codes appropriately
- Implement soft deletes using IsActive flag
- Include timestamps for audit trail
- Support pagination for large result sets
- Consider caching for read-heavy endpoints
- Implement transaction support for multi-step operations

---

## Next Steps

1. Add Swagger/OpenAPI documentation
2. Implement JWT authentication
3. Add input validation with FluentValidation
4. Add comprehensive error handling
5. Implement logging with Serilog
6. Add caching layer (Redis)
7. Add unit tests
8. Add integration tests
9. Performance optimization
10. Security hardening (CORS, rate limiting, etc.)
