using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using UserApi.Models;
using UserApi.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using System.Text.Json;
using UserApi.Services;

namespace UserApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController
{
    private readonly ApplicationDbContext _context;
    private readonly UserService _userService;
    private readonly IConfiguration? _config;

    public UserController(
        ApplicationDbContext context,
        IWebHostEnvironment env,
        IConfiguration config
    )
    {
        _context = context;
        _userService = new UserService(_config, _context);
    }

    [HttpGet]
    public async Task<String> getUsers()
    {
        try
        {
            var users = await _userService.getUsers();
            return JsonSerializer.Serialize(new { success = true, users });
        }
        catch (Exception e)
        {
            return JsonSerializer.Serialize(new { success = false, message = e.Message });
        }
    }
    [HttpGet("{id}")]
    public async Task<String> getUser(int id)
    {
        try
        {
            var user = await _userService.getUserDetails(id);
            return JsonSerializer.Serialize(new { success = true, user });
        }
        catch (Exception e)
        {
            return JsonSerializer.Serialize(new { success = false, message = e.Message });
        }
    }
    [HttpPost]
    public async Task<String> createUser(User newUser)
    {
        try
        {
            var user = await _userService.saveUserDetails(
                newUser.name,
                newUser.permission
            );
            return JsonSerializer.Serialize(new { success = true, user });
        }
        catch (Exception e)
        {
            return JsonSerializer.Serialize(new { success = false, message = e.Message });
        }
    }
    [HttpPut("{id}")]
    public async Task<String> updateUser(int id, User updatedUser)
    {
        try
        {
            var user = await _userService.updateUserDetails(
                id,
                updatedUser.name,
                updatedUser.permission
            );
            return JsonSerializer.Serialize(new { success = true, user });
        }
        catch (Exception e)
        {
            return JsonSerializer.Serialize(new { success = false, message = e.Message });
        }
    }
    [HttpDelete("{id}")]
    public async Task<String> deleteUser(int id)
    {
        try
        {
            var user = await _userService.removeUser(id);
            return JsonSerializer.Serialize(new { success = true, user });
        }
        catch (Exception e)
        {
            return JsonSerializer.Serialize(new { success = false, message = e.Message });
        }
    }
}
