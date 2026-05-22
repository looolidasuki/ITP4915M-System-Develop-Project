using System;

namespace SDP.Models
{
    public class ProductReview
    {
        public int ReviewId { get; set; }
        public int ProductId { get; set; }
        public int UserId { get; set; }
        public int Rating { get; set; }
        public string ReviewTitle { get; set; }
        public string ReviewText { get; set; }
        public DateTime ReviewDate { get; set; }
        public bool IsApproved { get; set; }
        public int HelpfulCount { get; set; }

        // Navigation properties
        public virtual Product Product { get; set; }
        public virtual User User { get; set; }
    }
}
