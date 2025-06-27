import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> users = [];

Future<void> fetchSomething() async {
  try {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      users = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      print("Success.");
    } else {
      print("Failed: ${response.statusCode}");
    }
  } catch (e) {
    print(e);
  }
}

void main() async {
  await fetchSomething();

  String? choice;
  while (choice != '4') {
    print('''
==== User Manager Menu ====
1. Show all usernames
2. Show details of a user by ID
3. Filter users by city
4. Exit
Enter your choice:''');

    choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print("Usernames:");
        for (var user in users) {
          print(user['username']);
        }
        break;

      case '2':
        stdout.write("Enter user ID: ");
        var input = stdin.readLineSync();

        var user = users.firstWhere(
          (u) => u['id'].toString() == input,
          orElse: () => {},
        );

        if (user.isNotEmpty) {
          print("Name: ${user['name']}");
          print("Email: ${user['email']}");
          print("City: ${user['address']['city']}");
          print("Company: ${user['company']['name']}");
        } else {
          print("User not found.");
        }
        break;

      case '3':
        stdout.write("Enter city name: ");
        var city = stdin.readLineSync();

        var filteredUsers = users.where(
          (u) =>
              u['address']['city'].toString().toLowerCase() ==
              city?.toLowerCase(),
        );

        if (filteredUsers.isEmpty) {
          print("No users found in $city");
        } else {
          for (var user in filteredUsers) {
            print("${user['name']} - ${user['address']['city']}");
          }
        }
        break;

      case '4':
        print("Exiting... Goodbye!");
        break;

      default:
        print("Invalid choice. Please try again.");
    }
  }
}
