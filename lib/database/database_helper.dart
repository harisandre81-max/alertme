import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // 🔹 Activar foreign keys
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  // 🔹 Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first; // devuelve todo el usuario
    } else {
      return null;
    }
  }

  // 🔹 Crear tablas
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        edad INTEGER NOT NULL,
        direccion TEXT NOT NULL,
        telefono TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE contactos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        edad INTEGER NOT NULL,
        telefono TEXT NOT NULL,
        parentesco TEXT NOT NULL,
        FOREIGN KEY(usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
      )
    ''');
  }

  // 🔹 Insertar usuario
  Future<int> insertUsuario(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('usuarios', row);
  }

  // 🔹 Insertar contacto
  Future<int?> insertContactoLimitado(Map<String, dynamic> row) async {
  final db = await database;
  int usuarioId = row['usuario_id'];

  // 1️⃣ Contar cuántos contactos tiene este usuario
  final count = Sqflite.firstIntValue(await db.rawQuery(
    'SELECT COUNT(*) FROM contactos WHERE usuario_id = ?',
    [usuarioId],
  ));

  // 2️⃣ Limitar a 3 contactos
  if (count != null && count >= 3) {
    print("El usuario ya tiene 3 contactos, no se puede agregar más");
    return null; // o lanzar un error
  }

  // 3️⃣ Insertar normalmente
  return await db.insert('contactos', row);
}


  // 🔹 Obtener contactos de un usuario
  Future<List<Map<String, dynamic>>> getContactos(int usuarioId) async {
    final db = await database;
    return await db.query(
      'contactos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
  }
  // 🔹 Obtener usuario por ID
Future<Map<String, dynamic>?> loginById(int id) async {
  final db = await instance.database;
  final result = await db.query(
    'usuarios',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (result.isNotEmpty) return result.first;
  return null;
}

// 🔹 Actualizar usuario por ID
Future<int> updateUsuario(int id, Map<String, dynamic> row) async {
  final db = await database;
  return await db.update(
    'usuarios',
    row,
    where: 'id = ?',
    whereArgs: [id],
  );
}

}
