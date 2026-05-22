using System.Collections.Generic;

namespace SDP.Models
{
    public class OrderStatus
    {
        public int OrderStatusId { get; set; }
        public string StatusName { get; set; }
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}
