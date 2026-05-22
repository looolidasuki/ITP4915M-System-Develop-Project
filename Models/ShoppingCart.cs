using System;
using System.Collections.Generic;

namespace SDP.Models
{
    public class ShoppingCart
    {
        public int CartId { get; set; }
        public int UserId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }

        // Navigation properties
        public virtual User User { get; set; }
        public virtual ICollection<ShoppingCartItem> ShoppingCartItems { get; set; } = new List<ShoppingCartItem>();
    }
}
