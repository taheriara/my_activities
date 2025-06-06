import 'package:my_activities/db_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;
  Future<Database?> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await _databaseConnection.setDatabase();
  }

  //Read All Records
  report(sql) async {
    var db = await database;
    return await db?.rawQuery(sql, null);
  }

  //Insert Record
  insertData(table, data) async {
    var db = await database;
    return await db?.insert(table, data);
  }

  //Update Record
  updateData(table, data) async {
    var db = await database;
    return await db?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //Read All Records
  readData(table, where, orderString) async {
    var db = await database;
    return await db?.query(table, where: where, orderBy: orderString); // orderString: "id DESC"
  }

  //Read All Records
  readDataAll(table) async {
    var db = await database;
    return await db?.query(table);
  }

  //Read All Records
  readDataGroup(table, columns, groupBy) async {
    var db = await database;
    return await db?.query(table, columns: columns, groupBy: groupBy);
  }

  //Read All Records
  readDataPaging(table, orderString, page, limit) async {
    page -= 1;
    var db = await database;
    return await db?.query(table, orderBy: orderString, limit: limit, offset: page * limit); // orderString: "id DESC"
  }

// ------------------------ //
//   //Read All Records
//   searchQuestion(table, page, search) async {
//     page -= 1;
//     var db = await database;
//     return await db?.query(table,
//         orderBy: 'id DESC',
//         where: 'question LIKE ? OR answer LIKE ?',
//         whereArgs: ['%$search%', '%$search%'],
//         limit: 20,
//         offset: page * 20); // orderString: "id DESC"
//   }

  // Delete all Branch
  deleteAllRecords(table, where) async {
    var db = await database;
    return await db?.rawDelete('DELETE FROM $table $where');
  }

//   getLastId(table, where) async {
//     var db = await database;
//     return await db?.rawQuery("select max(id) as id from $table $where", null);
//   }

//   getMinId(table) async {
//     var db = await database;
//     return await db?.rawQuery("select max(id) as id from $table where answer !=''", null);
//   }

//   //Read a Single Record By ID
//   readDataById(table, itemId) async {
//     var db = await database;
//     return await db?.query(table, where: 'id=?', whereArgs: [itemId]);
//   }

//   //Read a Single Record By WHERE
//   readDataByWhere(table, where, whereArgs) async {
//     var db = await database;
//     return await db?.query(table, where: where, whereArgs: whereArgs);
//   }

//   //Update Record
//   updateData(table, data) async {
//     var db = await database;
//     return await db?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
//   }

//   //Update Record
//   updateDaily(table, data) async {
//     var db = await database;
//     return await db?.update(table, data, where: 'editTime=?', whereArgs: [data['editTime']]);
//   }

//   //Update Record
//   updateAllIsActive(table, isActive) async {
//     var db = await database;
//     return await db?.rawUpdate('UPDATE $table SET isActive = $isActive'); // isActive: 0 or 1
//   }

//   //Update Record
//   updateDataNoId(table, data) async {
//     var db = await database;
//     return await db?.update(table, data);
//   }

//   //Delete Record
//   deleteDataById(table, itemId) async {
//     var db = await database;
//     return await db?.rawDelete("delete from $table where id=$itemId");
//   }

//   //SAMPLE
//   // extera query:
//   resetNobatToId(table, loanNumber) async {
//     var db = await database;
//     // Insert some records in a transaction
//     return await db?.transaction((txn) async {
//       await txn.rawUpdate('UPDATE $table SET nobat = 0, pay = 0');
//       await txn.rawUpdate('UPDATE $table SET nobat = 1 where loanNumber=$loanNumber');
//     });
//   }

//   //SAMPLE
//   Future<dynamic> alterTable(String tableName, String columneName) async {
//     var dbClient = await database;
//     var count = await dbClient?.execute("ALTER TABLE $tableName ADD "
//         "COLUMN $columneName TEXT;");
//     //print(await dbClient?.query(tableName));
//     return count;
//   }

//   //SAMPLE
//   Future<int> countRecords(String tbl, String where) async {
//     var dbClient = await database;
//     var count = await dbClient?.rawQuery("SELECT COUNT(*) as i FROM $tbl where $where", null);

//     // var result = await _repository.getLastId('questions');
//     var value = count?.first;
//     int i = value?['i'] as int;
//     return i;
//     // print(await dbClient?.query(tbl));
//     // var value = count?.first;
//     // int i = value['i'] ?? 0;
//     // print(count);
//     // return count as int;
//   }

// //toggle boolean in SQLite
//   updateFavorite(String table, int id) async {
//     var db = await database;
//     return await db?.rawQuery("update $table set favorite=((favorite | 1) - (favorite & 1)) where id=$id", null);
//   }
}
