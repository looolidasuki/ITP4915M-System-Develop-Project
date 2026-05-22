using System;
using System.Collections.Generic;

namespace SDP.Models
{
    public class Order
    {
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal ShippingCost { get; set; }
        public decimal DiscountAmount { get; set; }
        public int OrderStatusId { get; set; }
        public string ShippingAddress { get; set; }
        public string BillingAddress { get; set; }
        public string SpecialNotes { get; set; }
        public DateTime? ModifiedDate { get; set; }

        // Navigation properties
        public virtual User User { get; set; }
        public virtual OrderStatus OrderStatus { get; set; }
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<OrderPayment> OrderPayments { get; set; } = new List<OrderPayment>();
        public virtual ICollection<OrderShipping> OrderShippings { get; set; } = new List<OrderShipping>();
    }
}
