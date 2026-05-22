using System.Collections.Generic;

namespace SDP.Models
{
    public class PaymentMethod
    {
        public int PaymentMethodId { get; set; }
        public string MethodName { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public virtual ICollection<OrderPayment> OrderPayments { get; set; } = new List<OrderPayment>();
    }
}
