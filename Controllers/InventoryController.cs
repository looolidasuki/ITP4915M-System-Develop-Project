using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SDP.Data;
using SDP.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SDP.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InventoryController : ControllerBase
    {
        private readonly SdpDbContext _context;

        public InventoryController(SdpDbContext context)
        {
            _context = context;
        }

        // GET: api/inventory/product/{productId}
        [HttpGet("product/{productId}")]
        public async Task<ActionResult<IEnumerable<ProductInventory>>> GetProductInventory(int productId)
        {
            return await _context.ProductInventories
                .Where(pi => pi.ProductId == productId)
                .Include(pi => pi.Product)
                .ToListAsync();
        }

        // GET: api/inventory/{inventoryId}
        [HttpGet("{inventoryId}")]
        public async Task<ActionResult<ProductInventory>> GetInventory(int inventoryId)
        {
            var inventory = await _context.ProductInventories
                .Include(pi => pi.Product)
                .FirstOrDefaultAsync(pi => pi.InventoryId == inventoryId);

            if (inventory == null)
            {
                return NotFound();
            }

            return inventory;
        }

        // POST: api/inventory
        [HttpPost]
        public async Task<ActionResult<ProductInventory>> CreateInventory(ProductInventory inventory)
        {
            _context.ProductInventories.Add(inventory);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetInventory), new { inventoryId = inventory.InventoryId }, inventory);
        }

        // PUT: api/inventory/{inventoryId}
        [HttpPut("{inventoryId}")]
        public async Task<IActionResult> UpdateInventory(int inventoryId, ProductInventory inventory)
        {
            if (inventoryId != inventory.InventoryId)
            {
                return BadRequest();
            }

            inventory.ModifiedDate = System.DateTime.Now;
            _context.Entry(inventory).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.ProductInventories.Any(e => e.InventoryId == inventoryId))
                {
                    return NotFound();
                }
                throw;
            }

            return NoContent();
        }

        // GET: api/inventory/lowstock
        [HttpGet("lowstock")]
        public async Task<ActionResult<IEnumerable<object>>> GetLowStockItems()
        {
            var lowStockItems = await _context.ProductInventories
                .Where(pi => pi.QuantityOnHand <= pi.ReorderLevel)
                .Include(pi => pi.Product)
                .Select(pi => new
                {
                    pi.InventoryId,
                    ProductName = pi.Product.ProductName,
                    pi.QuantityOnHand,
                    pi.ReorderLevel,
                    QuantityToReorder = pi.ReorderLevel - pi.QuantityOnHand,
                    pi.WarehouseLocation
                })
                .ToListAsync();

            return Ok(lowStockItems);
        }

        // PUT: api/inventory/{inventoryId}/adjust
        [HttpPut("{inventoryId}/adjust")]
        public async Task<IActionResult> AdjustInventory(int inventoryId, [FromBody] int quantityChange)
        {
            var inventory = await _context.ProductInventories.FindAsync(inventoryId);
            if (inventory == null)
            {
                return NotFound();
            }

            inventory.QuantityOnHand += quantityChange;
            inventory.ModifiedDate = System.DateTime.Now;

            if (inventory.QuantityOnHand < 0)
            {
                return BadRequest("Insufficient stock");
            }

            _context.Entry(inventory).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/inventory/warehouse/{location}
        [HttpGet("warehouse/{location}")]
        public async Task<ActionResult<IEnumerable<ProductInventory>>> GetInventoryByLocation(string location)
        {
            return await _context.ProductInventories
                .Where(pi => pi.WarehouseLocation == location)
                .Include(pi => pi.Product)
                .ToListAsync();
        }
    }
}
