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
    public class ShoppingCartsController : ControllerBase
    {
        private readonly SdpDbContext _context;

        public ShoppingCartsController(SdpDbContext context)
        {
            _context = context;
        }

        // GET: api/shoppingcarts/{userId}
        [HttpGet("{userId}")]
        public async Task<ActionResult<ShoppingCart>> GetCartByUserId(int userId)
        {
            var cart = await _context.ShoppingCarts
                .Include(c => c.ShoppingCartItems).ThenInclude(ci => ci.Product)
                .FirstOrDefaultAsync(c => c.UserId == userId);

            if (cart == null)
            {
                return NotFound();
            }

            return cart;
        }

        // POST: api/shoppingcarts
        [HttpPost]
        public async Task<ActionResult<ShoppingCart>> CreateCart(ShoppingCart cart)
        {
            var existingCart = await _context.ShoppingCarts
                .FirstOrDefaultAsync(c => c.UserId == cart.UserId);

            if (existingCart != null)
            {
                return BadRequest("User already has a shopping cart");
            }

            _context.ShoppingCarts.Add(cart);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetCartByUserId), new { userId = cart.UserId }, cart);
        }

        // POST: api/shoppingcarts/{cartId}/items
        [HttpPost("{cartId}/items")]
        public async Task<ActionResult<ShoppingCartItem>> AddItemToCart(int cartId, ShoppingCartItem item)
        {
            var cart = await _context.ShoppingCarts.FindAsync(cartId);
            if (cart == null)
            {
                return NotFound("Cart not found");
            }

            var existingItem = await _context.ShoppingCartItems
                .FirstOrDefaultAsync(ci => ci.CartId == cartId && ci.ProductId == item.ProductId);

            if (existingItem != null)
            {
                existingItem.Quantity += item.Quantity;
                _context.Entry(existingItem).State = EntityState.Modified;
            }
            else
            {
                item.CartId = cartId;
                _context.ShoppingCartItems.Add(item);
            }

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetCartByUserId), new { userId = cart.UserId }, item);
        }

        // DELETE: api/shoppingcarts/{cartId}/items/{itemId}
        [HttpDelete("{cartId}/items/{itemId}")]
        public async Task<IActionResult> RemoveItemFromCart(int cartId, int itemId)
        {
            var item = await _context.ShoppingCartItems
                .FirstOrDefaultAsync(ci => ci.CartItemId == itemId && ci.CartId == cartId);

            if (item == null)
            {
                return NotFound();
            }

            _context.ShoppingCartItems.Remove(item);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // PUT: api/shoppingcarts/{cartId}/items/{itemId}
        [HttpPut("{cartId}/items/{itemId}")]
        public async Task<IActionResult> UpdateCartItem(int cartId, int itemId, ShoppingCartItem item)
        {
            var cartItem = await _context.ShoppingCartItems
                .FirstOrDefaultAsync(ci => ci.CartItemId == itemId && ci.CartId == cartId);

            if (cartItem == null)
            {
                return NotFound();
            }

            cartItem.Quantity = item.Quantity;
            cartItem.UnitPrice = item.UnitPrice;

            _context.Entry(cartItem).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/shoppingcarts/{cartId}
        [HttpDelete("{cartId}")]
        public async Task<IActionResult> ClearCart(int cartId)
        {
            var items = await _context.ShoppingCartItems
                .Where(ci => ci.CartId == cartId)
                .ToListAsync();

            _context.ShoppingCartItems.RemoveRange(items);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/shoppingcarts/{cartId}/total
        [HttpGet("{cartId}/total")]
        public async Task<ActionResult<decimal>> GetCartTotal(int cartId)
        {
            var total = await _context.ShoppingCartItems
                .Where(ci => ci.CartId == cartId)
                .SumAsync(ci => ci.UnitPrice * ci.Quantity);

            return Ok(new { total });
        }
    }
}
