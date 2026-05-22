using System.Collections.Generic;

namespace SDP.Models
{
    public class PaymentStatus
    {
        public int PaymentStatusId { get; set; }
        public string StatusName { get; set; }
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<OrderPayment> OrderPayments { get; set; } = new List<OrderPayment>();
    }
}
