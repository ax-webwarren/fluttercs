using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using UserApi.Models;
using UserApi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text.Json;

namespace UserApi.Services;

public class UserService
{

    private readonly ApplicationDbContext _context;
    private readonly IConfiguration _config;

    public UserService(
        IConfiguration? config,
        ApplicationDbContext context
    )
    {
        _config = config;
        _context = context;
    }

    public async Task<List<User>> getUsers()
    {
        // Get All Users
        try
        {
            // Get User
            var users = await _context.Users
                .ToListAsync();

            return users;
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex.Message);
            return new List<User>(); // Return what we have so far
        }
    }

    public async Task<User> getUserDetails(
        int id
    )
    {
        // Get User Detail
        try
        {
            // Get User
            var user = await _context.Users
                .FirstOrDefaultAsync(user => user.id == id);

            return user;
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex.Message);
            return new User(); // Return what we have so far
        }
    }

    public async Task<User> getUserDetailsByName(
        string name
    )
    {
        // Get User Detail
        try
        {
            // Get User
            var user = await _context.Users
                .FirstOrDefaultAsync(user => user.name == name);

            return user;
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex.Message);
            return new User(); // Return what we have so far
        }
    }

    public async Task<User> saveUserDetails(
        string name,
        string permission
    )
    {
        try
        {
            var newUser = new User
            {
                name = name,
                permission = permission
            };

            _context.Users.Add(newUser);
            _context.SaveChanges();

            return newUser;
        }
        catch (Exception err)
        {
            return new User();
        }
    }

    public async Task<User> updateUserDetails(
        int id,
        string name,
        string permission
    )
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(user => user.id == id);

        if (user != null)
        {
            user.name = name;
            user.permission = permission;
            user.updatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }

        return user;
    }

    public async Task<Boolean> removeUser(
        int id
    )
    {
        var user = await _context.Users
                .FirstOrDefaultAsync(user => user.id == id);

        if (user != null)
        {
            _context.Users.Remove(user);
            // user.delete_flag = "y";
            await _context.SaveChangesAsync();
        }

        return true;
    }
}