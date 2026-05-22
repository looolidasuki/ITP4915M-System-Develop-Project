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
    public class ProductReviewsController : ControllerBase
    {
        private readonly SdpDbContext _context;

        public ProductReviewsController(SdpDbContext context)
        {
            _context = context;
        }

        // GET: api/productreviews/product/{productId}
        [HttpGet("product/{productId}")]
        public async Task<ActionResult<IEnumerable<ProductReview>>> GetProductReviews(int productId)
        {
            return await _context.ProductReviews
                .Where(pr => pr.ProductId == productId && pr.IsApproved)
                .Include(pr => pr.User)
                .OrderByDescending(pr => pr.ReviewDate)
                .ToListAsync();
        }

        // GET: api/productreviews/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<ProductReview>> GetReview(int id)
        {
            var review = await _context.ProductReviews
                .Include(pr => pr.Product)
                .Include(pr => pr.User)
                .FirstOrDefaultAsync(pr => pr.ReviewId == id);

            if (review == null)
            {
                return NotFound();
            }

            return review;
        }

        // POST: api/productreviews
        [HttpPost]
        public async Task<ActionResult<ProductReview>> CreateReview(ProductReview review)
        {
            _context.ProductReviews.Add(review);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetReview), new { id = review.ReviewId }, review);
        }

        // PUT: api/productreviews/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateReview(int id, ProductReview review)
        {
            if (id != review.ReviewId)
            {
                return BadRequest();
            }

            _context.Entry(review).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.ProductReviews.Any(e => e.ReviewId == id))
                {
                    return NotFound();
                }
                throw;
            }

            return NoContent();
        }

        // DELETE: api/productreviews/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReview(int id)
        {
            var review = await _context.ProductReviews.FindAsync(id);
            if (review == null)
            {
                return NotFound();
            }

            _context.ProductReviews.Remove(review);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // PUT: api/productreviews/{id}/approve
        [HttpPut("{id}/approve")]
        public async Task<IActionResult> ApproveReview(int id)
        {
            var review = await _context.ProductReviews.FindAsync(id);
            if (review == null)
            {
                return NotFound();
            }

            review.IsApproved = true;
            _context.Entry(review).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // GET: api/productreviews/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<ProductReview>>> GetUserReviews(int userId)
        {
            return await _context.ProductReviews
                .Where(pr => pr.UserId == userId)
                .Include(pr => pr.Product)
                .OrderByDescending(pr => pr.ReviewDate)
                .ToListAsync();
        }

        // GET: api/productreviews/product/{productId}/rating
        [HttpGet("product/{productId}/rating")]
        public async Task<ActionResult<object>> GetProductRating(int productId)
        {
            var reviews = await _context.ProductReviews
                .Where(pr => pr.ProductId == productId && pr.IsApproved)
                .ToListAsync();

            if (!reviews.Any())
            {
                return Ok(new { averageRating = 0, totalReviews = 0 });
            }

            var averageRating = reviews.Average(r => r.Rating);
            var totalReviews = reviews.Count;

            return Ok(new { averageRating, totalReviews });
        }
    }
}
