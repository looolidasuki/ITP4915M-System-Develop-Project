using System.Collections.Generic;

namespace SDP.Models
{
    public class UserRole
    {
        public int UserRoleId { get; set; }
        public string RoleName { get; set; }
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<User> Users { get; set; } = new List<User>();
    }
}
