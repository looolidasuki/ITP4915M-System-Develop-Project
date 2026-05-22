using Microsoft.EntityFrameworkCore;
using SDP.Models;

namespace SDP.Data
{
    public class SdpDbContext : DbContext
    {
        public SdpDbContext(DbContextOptions<SdpDbContext> options) : base(options)
        {
        }

        // DbSets for all entities
        public DbSet<User> Users { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<Vendor> Vendors { get; set; }
        public DbSet<ProductCategory> ProductCategories { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<ProductInventory> ProductInventories { get; set; }
        public DbSet<ProductReview> ProductReviews { get; set; }
        public DbSet<ShoppingCart> ShoppingCarts { get; set; }
        public DbSet<ShoppingCartItem> ShoppingCartItems { get; set; }
        public DbSet<OrderStatus> OrderStatuses { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }
        public DbSet<PaymentMethod> PaymentMethods { get; set; }
        public DbSet<PaymentStatus> PaymentStatuses { get; set; }
        public DbSet<OrderPayment> OrderPayments { get; set; }
        public DbSet<ShippingMethod> ShippingMethods { get; set; }
        public DbSet<ShippingStatus> ShippingStatuses { get; set; }
        public DbSet<OrderShipping> OrderShippings { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure decimal properties for currency
            modelBuilder.Entity<Product>()
                .Property(p => p.Price)
                .HasPrecision(10, 2);

            modelBuilder.Entity<Product>()
                .Property(p => p.DiscountPrice)
                .HasPrecision(10, 2);

            modelBuilder.Entity<Order>()
                .Property(o => o.TotalAmount)
                .HasPrecision(10, 2);

            modelBuilder.Entity<Order>()
                .Property(o => o.TaxAmount)
                .HasPrecision(10, 2);

            modelBuilder.Entity<Order>()
                .Property(o => o.ShippingCost)
                .HasPrecision(10, 2);

            modelBuilder.Entity<Order>()
                .Property(o => o.DiscountAmount)
                .HasPrecision(10, 2);

            modelBuilder.Entity<OrderItem>()
                .Property(oi => oi.UnitPrice)
                .HasPrecision(10, 2);

            modelBuilder.Entity<OrderItem>()
                .Property(oi => oi.TotalPrice)
                .HasPrecision(10, 2);

            modelBuilder.Entity<OrderItem>()
                .Property(oi => oi.DiscountAmount)
                .HasPrecision(10, 2);

            modelBuilder.Entity<OrderPayment>()
                .Property(op => op.Amount)
                .HasPrecision(10, 2);

            modelBuilder.Entity<OrderShipping>()
                .Property(os => os.ShippingCost)
                .HasPrecision(10, 2);

            modelBuilder.Entity<ShippingMethod>()
                .Property(sm => sm.BaseCost)
                .HasPrecision(10, 2);

            modelBuilder.Entity<ShoppingCartItem>()
                .Property(sci => sci.UnitPrice)
                .HasPrecision(10, 2);

            // Configure unique constraints
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.UserName)
                .IsUnique();

            modelBuilder.Entity<UserRole>()
                .HasIndex(ur => ur.RoleName)
                .IsUnique();

            modelBuilder.Entity<Product>()
                .HasIndex(p => p.SKU)
                .IsUnique();

            modelBuilder.Entity<OrderStatus>()
                .HasIndex(os => os.StatusName)
                .IsUnique();

            modelBuilder.Entity<PaymentMethod>()
                .HasIndex(pm => pm.MethodName)
                .IsUnique();

            modelBuilder.Entity<PaymentStatus>()
                .HasIndex(ps => ps.StatusName)
                .IsUnique();

            modelBuilder.Entity<ShippingMethod>()
                .HasIndex(sm => sm.MethodName)
                .IsUnique();

            modelBuilder.Entity<ShippingStatus>()
                .HasIndex(ss => ss.StatusName)
                .IsUnique();

            // Configure one-to-one relationships
            modelBuilder.Entity<ShoppingCart>()
                .HasOne(sc => sc.User)
                .WithMany(u => u.ShoppingCarts)
                .HasForeignKey(sc => sc.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Configure many-to-many relationships through junction tables
            modelBuilder.Entity<ShoppingCartItem>()
                .HasOne(sci => sci.ShoppingCart)
                .WithMany(sc => sc.ShoppingCartItems)
                .HasForeignKey(sci => sci.CartId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<OrderItem>()
                .HasOne(oi => oi.Order)
                .WithMany(o => o.OrderItems)
                .HasForeignKey(oi => oi.OrderId)
                .OnDelete(DeleteBehavior.Cascade);

            // Configure hierarchical relationship
            modelBuilder.Entity<ProductCategory>()
                .HasOne(pc => pc.ParentCategory)
                .WithMany(pc => pc.SubCategories)
                .HasForeignKey(pc => pc.ParentCategoryId)
                .OnDelete(DeleteBehavior.Restrict);

            // Add query filters for active records (soft delete pattern)
            modelBuilder.Entity<User>()
                .HasQueryFilter(u => u.IsActive);

            modelBuilder.Entity<Product>()
                .HasQueryFilter(p => p.IsActive);

            modelBuilder.Entity<ProductCategory>()
                .HasQueryFilter(pc => pc.IsActive);

            modelBuilder.Entity<Vendor>()
                .HasQueryFilter(v => v.IsActive);

            modelBuilder.Entity<PaymentMethod>()
                .HasQueryFilter(pm => pm.IsActive);

            modelBuilder.Entity<ShippingMethod>()
                .HasQueryFilter(sm => sm.IsActive);
        }
    }
}
