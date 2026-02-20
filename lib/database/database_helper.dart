import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

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
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    final user = result.first;

    final storedHash = user['password'] as String;

if (BCrypt.checkpw(password, storedHash)) {
  return user;
}

  }

  return null; // usuario no encontrado o contraseña incorrecta
}


  // 🔹 Crear tablas--BASE DE DATOS
Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      edad INTEGER NOT NULL,
      direccion TEXT NOT NULL,
      telefono TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      foto TEXT DEFAULT 'assets/avatar.png'
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
      foto TEXT DEFAULT 'assets/avatar.png',
      FOREIGN KEY(usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
    )
  ''');

  // 🔹 Insertar usuario admin de prueba
  final hashedPassword = BCrypt.hashpw('admin123%', BCrypt.gensalt());

  int adminId = await db.insert('usuarios', {
    'nombre': 'admin',
    'edad': 14,
    'direccion': 'Villa Union',
    'telefono': '555555555',
    'email': 'admin81@gmail.com',
    'password': hashedPassword,
  });

  // 🔹 Insertar contacto de prueba
  await db.insert('contactos', {
    'usuario_id': adminId,
    'nombre': 'randomcontact',
    'edad': 28,
    'telefono': '6751107805',
    'parentesco': 'padre',
  });
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
// 🔹 Actualizar contacto por ID
Future<int> updateContact(int id, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update(
      'contactos',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
