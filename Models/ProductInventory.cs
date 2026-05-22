using System;

namespace SDP.Models
{
    public class ProductInventory
    {
        public int InventoryId { get; set; }
        public int ProductId { get; set; }
        public string WarehouseLocation { get; set; }
        public int QuantityOnHand { get; set; }
        public int ReorderLevel { get; set; }
        public DateTime LastRestockDate { get; set; }
        public DateTime? ModifiedDate { get; set; }

        // Navigation properties
        public virtual Product Product { get; set; }
    }
}
