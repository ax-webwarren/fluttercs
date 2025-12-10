class User {
  final int id;
  final String name;
  final String permission;
  // Add other fields as necessary

  User({required this.id, required this.name, required this.permission});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      permission: json['permission'],
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'permission': permission};
  }
}
