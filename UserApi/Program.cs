using Microsoft.EntityFrameworkCore;
using UserApi.Data;
using System.IO;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http.Features;
using UserApi.Services; // Ensure your UserService is accessible

var builder = WebApplication.CreateBuilder(args);

// 1. Add API controllers support (essential for returning JSON responses)
builder.Services.AddControllers(); 

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.AddEndpointsApiExplorer(); // Often needed for Swagger/OpenAPI UI

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection")),
        mySqlOptions =>
        {
            mySqlOptions.EnableRetryOnFailure(
                maxRetryCount: 5,
                maxRetryDelay: TimeSpan.FromSeconds(10),
                errorNumbersToAdd: null
            );
        }
    ));

// Add UserService
builder.Services.AddScoped<UserService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    // Configure Swagger UI if needed for development
    // app.UseSwagger();
    // app.UseSwaggerUI();
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseRouting();
// app.UseSession(); // You might not need session state for a typical stateless REST API

app.UseAuthorization(); // Add authorization middleware if you plan to secure endpoints

// 2. Map the controllers (this tells the app to look for [ApiController] classes)
app.MapControllers(); 

app.Use(async (context, next) =>
{
    // ... (Your security headers middleware) ...
    context.Response.Headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains";
    context.Response.Headers["Content-Security-Policy"] = "default-src * 'unsafe-inline' 'unsafe-eval' data: blob:;";
    context.Response.Headers["X-Content-Type-Options"] = "nosniff";
    context.Response.Headers["Referrer-Policy"] = "strict-origin-when-cross-origin";
    context.Response.Headers["Permissions-Policy"] =
        "geolocation=(), microphone=(), camera=()";

    await next();
});

app.Run();