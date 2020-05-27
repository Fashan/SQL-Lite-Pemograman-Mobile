import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DBhelper{
  Database _database;

  Future openDb() async{
    if(_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "kuliah.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            db.execute(
                "CREATE TABLE mahasiswa (id INTEGER PRIMARY KEY autoincrement, nama TEXT, nim TEXT)");
          }
      );
    }
  }
  Future<int> insertmahasiswa (Mahasiswa mahasiswa) async{
    await openDb();
    return _database.insert('mahasiswa', mahasiswa.toMap());
  }

  Future<List<Mahasiswa>> getMahasiswaList() async{
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('mahasiswa');
    return List.generate(maps.length, (i){
      return Mahasiswa(
          id: maps[i]['id'],
          nama: maps[i]['nama'],
          nim: maps[i]['nim']
      );
    });
  }

  Future<int> updateMahasiswa(Mahasiswa mahasiswa) async{
    await openDb();
    return await _database.update(
        'mahasiswa',
        mahasiswa.toMap(),
        where: "id = ?",
        whereArgs: [mahasiswa.id]);
  }

  Future<void> deleteMahasiswa(int id) async{
    await openDb();
    _database.delete('mahasiswa',where: "id = ?", whereArgs: [id]);

  }
}



class Mahasiswa {
  int id;
  String nama;
  String nim;

  Mahasiswa({
    @required this.nama,
    @required this.nim,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {'nama': nama, 'nim': nim,};
  }
}