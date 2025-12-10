import 'package:flutter/material.dart';
import 'models/user.dart';
import 'services/api_service.dart';
import 'user_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserListScreen(title: 'CRUD User'),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key, required this.title});

  final String title;

  @override
  State<UserListScreen> createState() => _UserListScreen();
}

class _UserListScreen extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _usersFuture = _apiService.getUsers();
  }

  // Method to refresh the list after an operation
  void _refreshUserList() {
    setState(() {
      _usersFuture = _apiService.getUsers();
    });
  }

  // Method to handle deletion
  Future<void> _deleteUser(int id) async {
    bool success = await _apiService.deleteUser(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted!')));
      _refreshUserList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete user!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.permission),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigate to edit form
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFormScreen(user: user),
                            ),
                          ).then((_) => _refreshUserList()); // Refresh when returning
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add form (passing null user for 'new' mode)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserFormScreen(user: null),
            ),
          ).then((_) => _refreshUserList()); // Refresh when returning
        },
      ),
    );
  }
}
