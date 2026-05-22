using System;
using System.Collections.Generic;

namespace SDP.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public decimal? DiscountPrice { get; set; }
        public int CategoryId { get; set; }
        public string SKU { get; set; }
        public string Barcode { get; set; }
        public int Weight { get; set; }
        public int Height { get; set; }
        public int Width { get; set; }
        public int Depth { get; set; }
        public string Color { get; set; }
        public string Size { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool IsActive { get; set; }
        public int VendorId { get; set; }

        // Navigation properties
        public virtual ProductCategory Category { get; set; }
        public virtual Vendor Vendor { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<ProductReview> ProductReviews { get; set; } = new List<ProductReview>();
        public virtual ICollection<ProductInventory> ProductInventories { get; set; } = new List<ProductInventory>();
        public virtual ICollection<ShoppingCartItem> ShoppingCartItems { get; set; } = new List<ShoppingCartItem>();
    }
}
