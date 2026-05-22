using System.Collections.Generic;

namespace SDP.Models
{
    public class ShippingMethod
    {
        public int ShippingMethodId { get; set; }
        public string MethodName { get; set; }
        public string Description { get; set; }
        public decimal BaseCost { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public virtual ICollection<OrderShipping> OrderShippings { get; set; } = new List<OrderShipping>();
    }
}
