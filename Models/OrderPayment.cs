using System;

namespace SDP.Models
{
    public class OrderPayment
    {
        public int PaymentId { get; set; }
        public int OrderId { get; set; }
        public int PaymentMethodId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public int PaymentStatusId { get; set; }
        public string TransactionNumber { get; set; }

        // Navigation properties
        public virtual Order Order { get; set; }
        public virtual PaymentMethod PaymentMethod { get; set; }
        public virtual PaymentStatus PaymentStatus { get; set; }
    }
}
