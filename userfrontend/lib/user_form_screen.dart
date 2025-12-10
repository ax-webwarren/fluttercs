import 'package:flutter/material.dart';
import 'models/user.dart';
import 'services/api_service.dart';

class UserFormScreen extends StatefulWidget {
  final User? user; // Null if adding a new user, non-null if editing

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TextEditingController _nameController;
  late TextEditingController _permissionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing, otherwise empty
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _permissionController = TextEditingController(text: widget.user?.permission ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _permissionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        id: widget.user?.id ?? 0, // ID is 0 if new, actual ID if editing
        name: _nameController.text,
        permission: _permissionController.text,
      );

      bool success = false;
      if (widget.user == null) {
        // Create new user
        User createdUser = await _apiService.createUser(newUser);
        success = createdUser.id != 0;
      } else {
        // Update existing user
        success = await _apiService.updateUser(newUser.id, newUser);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(widget.user == null ? 'User created successfully!' : 'User updated successfully!')),
        );
        Navigator.pop(context); // Go back to the list screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to save user.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _permissionController,
                decoration: const InputDecoration(labelText: 'Permission Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a permission level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.user == null ? 'Save User' : 'Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}