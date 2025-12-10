using Microsoft.EntityFrameworkCore;
using UserApi.Models;

namespace UserApi.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Add Seed Data
        modelBuilder.Entity<User>().HasData(
            new User { id = 1, name = "John Doe", permission = "admin", createdAt = DateTime.Now, updatedAt = DateTime.Now }
        );
    }

    public DbSet<User> Users => Set<User>();
}