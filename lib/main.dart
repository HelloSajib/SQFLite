import 'package:flutter/material.dart';
import 'package:database/user_model.dart';
import 'user_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDatabase().createDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _phoneController = TextEditingController();

  List<User> users = [];

  void _loadUsers() async {
    final data = await UserDatabase().getData();
    setState(() {
      users = data;
    });
  }

  void _insertUser() async {
    final user = User(
      name: _nameController.text,
      position: _positionController.text,
      phone: int.tryParse(_phoneController.text) ?? 0,
    );
    await UserDatabase().insertUserData(user);
    _loadUsers();
  }

  void _updateUser() async {
    final user = User(
      name: _nameController.text,
      position: _positionController.text,
      phone: int.tryParse(_phoneController.text) ?? 0,
    );
    await UserDatabase().updateData(user);
    _loadUsers();
  }

  void _deleteUser() async {
    final phone = int.tryParse(_phoneController.text) ?? 0;
    await UserDatabase().deleteData(phone);
    _loadUsers();
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User DB Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _positionController, decoration: InputDecoration(labelText: 'Position')),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _insertUser, child: Text("Insert")),
                ElevatedButton(onPressed: _updateUser, child: Text("Update")),
                ElevatedButton(onPressed: _deleteUser, child: Text("Delete")),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final u = users[index];
                  return ListTile(
                    title: Text(u.name),
                    subtitle: Text('${u.position} - ${u.phone}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
