using System;
using System.Collections.Generic;

namespace SDP.Models
{
    public class ProductCategory
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public int? ParentCategoryId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
        public virtual ProductCategory ParentCategory { get; set; }
        public virtual ICollection<ProductCategory> SubCategories { get; set; } = new List<ProductCategory>();
    }
}
