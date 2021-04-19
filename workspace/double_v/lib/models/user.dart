import 'package:double_v/data/database_helpers.dart';
import 'dart:convert';

// database table and column names
final String tableUsers = 'users';
final String columnId = 'id';
final String columnName = 'name';
final String columnLastName = 'last_name';
final String columnBirthDate = 'birth_date';
final String columnEmail = 'email';
final String columnAddress = 'adress';

class User {
  // Class attributes
  int id;
  String name;
  String lastName;
  String birthDate;
  String email;
  String address;

  User();

  // Convenience constructor to create a Word object
  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    lastName = map[columnLastName];
    birthDate = map[columnBirthDate];
    email = map[columnEmail];
    address = map[columnAddress];
  }

  // Convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnLastName: lastName,
      columnBirthDate: birthDate,
      columnEmail: email,
      columnAddress: address
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  // Update function
  // Modify the user in the database
  // Use a database helper to update
  update(id, name, lastName, birthDate, email, address) async {
    User user = User();
    user.id = id;
    user.name = name;
    user.lastName = lastName;
    user.birthDate = birthDate;
    user.email = email;
    user.address = address;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(user);
  }

  // Delete function
  // Delete user with specific id from database
  // Use a database helper to update
  delete(id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.delete(id);
  }

  // Save of create function
  // Create a new user in the database
  // Use a database helper to create it
  // Return the id of the new user
  Future<int> save(name, lastName, birthDate, email, address) async {
    User user = User();
    user.name = name;
    user.lastName = lastName;
    user.birthDate = birthDate;
    user.email = email;
    user.address = jsonEncode(address);
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(user);
    return id;
  }
}
