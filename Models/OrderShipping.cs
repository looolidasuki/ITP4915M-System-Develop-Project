using System;

namespace SDP.Models
{
    public class OrderShipping
    {
        public int ShippingId { get; set; }
        public int OrderId { get; set; }
        public int ShippingMethodId { get; set; }
        public DateTime ShippingDate { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public int ShippingStatusId { get; set; }
        public string TrackingNumber { get; set; }
        public decimal ShippingCost { get; set; }

        // Navigation properties
        public virtual Order Order { get; set; }
        public virtual ShippingMethod ShippingMethod { get; set; }
        public virtual ShippingStatus ShippingStatus { get; set; }
    }
}
