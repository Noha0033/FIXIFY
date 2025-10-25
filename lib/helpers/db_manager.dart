// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// class DBManager{
//
//
//   Future<Database> get connect async{
//     String _dbFolder=await getDatabasesPath();
//     String _dbName="app_database.db";
//    String finalPath= join(_dbFolder,_dbName);
//     return await openDatabase(finalPath,version: 1,
//         onCreate: (db,v){
//           String createToDoTable = """
//   CREATE TABLE todo (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     title TEXT NOT NULL,
//     description TEXT,
//     date TEXT
//   );
// """;
//       db.execute(createToDoTable);
//
//
//     });
//   }
//
//   Future<int>insertToTable(String tbl_name,Map<String,dynamic> data)async{
//     Database db=await connect;
//     return await db.insert(tbl_name, data);
//   }
//   updateTable(){}
//   deleteFromTable(){}
//   selectFromTable(){}
// }