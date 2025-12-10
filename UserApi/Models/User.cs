namespace UserApi.Models;

public class User
{
    public int? id { get; set; }
    public string? name { get; set; }
    public string? permission { get; set; }
    public DateTime createdAt { get; set; } = DateTime.UtcNow;
    public DateTime updatedAt { get; set; } = DateTime.UtcNow;
}