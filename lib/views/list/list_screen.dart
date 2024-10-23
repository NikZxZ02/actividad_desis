import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/user.dart';
import 'package:actividad_desis/views/list/user_details.dart';
import 'package:actividad_desis/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  DBSqlite database = DBSqlite();
  final _searchController = TextEditingController();
  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    loadUsers();
    _searchController.addListener(_filterUsers);
    super.initState();
  }

  Future<void> loadUsers() async {
    final usersData = await database.getUsers();
    setState(() {
      users = usersData;
      filteredUsers = users;
    });
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Listado",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      drawer: const CustomDrawer(
        isHome: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                ),
                label: const Text("Nombre"),
                fillColor: Colors.grey[100],
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: ListTile(
                    tileColor:
                        (index % 2 == 0) ? Colors.blue[100] : Colors.blue[50],
                    title: Text(filteredUsers.elementAt(index).name),
                    subtitle: Row(
                      children: [
                        Text(filteredUsers.elementAt(index).phoneNumber),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            filteredUsers.elementAt(index).email,
                            style: TextStyle(color: Colors.purple[600]),
                          ),
                        )
                      ],
                    ),
                    trailing: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0.5,
                              spreadRadius: 0.0,
                              offset: Offset(0.5, 0.5),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return UserDetails(
                              user: filteredUsers.elementAt(index),
                            );
                          },
                        ));
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
