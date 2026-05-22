using System.Collections.Generic;

namespace SDP.Models
{
    public class ShippingStatus
    {
        public int ShippingStatusId { get; set; }
        public string StatusName { get; set; }
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<OrderShipping> OrderShippings { get; set; } = new List<OrderShipping>();
    }
}
