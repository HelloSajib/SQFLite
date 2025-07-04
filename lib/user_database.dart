import 'package:database/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  UserDatabase._internal();

  static final UserDatabase _instance = UserDatabase._internal();

  factory UserDatabase()=> _instance;

  Database? database;

  Future<void> createDatabase() async {
    if(database != null) return;
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "user.db");
    database = await openDatabase(path,version: 1,onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE User(
        key INTEGER PRIMARY KEY,
        name TEXT,
        position TEXT,
        phone INTEGER
      )'''
    );
  }

  Future<void> insertUserData(User user) async {
    // await database!.insert("User", user.toJson());
    await database!.rawInsert(
      'INSERT INTO User(name, position, phone) VALUES (?, ?, ?)',
      [user.name, user.position,user.phone]
    );
  }

  Future<List<User>> getData() async {
    // final users = await database!.query("User");
    // return users.map((data)=> User.fromJson(data)).toList();
    final users = await database!.rawQuery(
      'SELECT * FROM User'
    );
    return users.map((data)=> User.fromJson(data)).toList();
  }

  Future<void> updateData(User user) async {
    // await database!.update(
    //     "User", user.toJson(), where: "phone =?", whereArgs: [user.phone]);
    await database!.rawUpdate(
      'UPDATE User SET name = ?, position = ? WHERE phone = ?',
      [user.name, user.position, user.phone]
    );
  }

  Future<void> deleteData(int phone) async {
    //await database!.delete("User",where: "phone =?", whereArgs: [phone]);
    await database!.rawDelete(
      'DELETE FROM User WHERE phone = ?',
      [phone]
    );
  }

}

