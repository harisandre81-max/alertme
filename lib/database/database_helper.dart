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
      foto TEXT DEFAULT 'assets/avatar.png',
      sync INTEGER DEFAULT 0
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
      sync INTEGER DEFAULT 0,
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

// Actualizar usuario y marcar para sincronización
Future<int> updateUsuario(int id, Map<String, dynamic> row) async {
  final db = await database;
  row['sync'] = 0; // marca como pendiente
  return await db.update(
    'usuarios',
    row,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Actualizar contacto y marcar para sincronización
Future<int> updateContact(int id, Map<String, dynamic> values) async {
  final db = await database;
  values['sync'] = 0; // marca como pendiente
  return await db.update(
    'contactos',
    values,
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<Map<String, dynamic>?> loginWithEmail(String email) async {
  final db = await instance.database;

  final result = await db.query(
    'usuarios',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return result.first;
  }

  return null;
}
// 🔹 Ver si hay datos pendientes de usuario
Future<bool> hayDatosPendientesUsuario(int usuarioId) async {
  final db = await database;
  final result = await db.query(
    'usuarios',
    where: 'id = ? AND sync = 0',
    whereArgs: [usuarioId],
  );
  return result.isNotEmpty;
}

// 🔹 Obtener datos pendientes de usuario
Future<List<Map<String, dynamic>>> getUsuariosPendientes(int usuarioId) async {
  final db = await database;
  return await db.query(
    'usuarios',
    where: 'id = ? AND sync = 0',
    whereArgs: [usuarioId],
  );
}

// 🔹 Marcar usuario como sincronizado
Future<void> marcarUsuarioSincronizado(int usuarioId) async {
  final db = await database;
  await db.update(
    'usuarios',
    {'sync': 1},
    where: 'id = ?',
    whereArgs: [usuarioId],
  );
}

// 🔹 Ver si hay contactos pendientes
Future<bool> hayContactosPendientes(int usuarioId) async {
  final db = await database;
  final result = await db.query(
    'contactos',
    where: 'usuario_id = ? AND sync = 0',
    whereArgs: [usuarioId],
  );
  return result.isNotEmpty;
}

// 🔹 Obtener contactos pendientes
Future<List<Map<String, dynamic>>> getContactosPendientes(int usuarioId) async {
  final db = await database;
  return await db.query(
    'contactos',
    where: 'usuario_id = ? AND sync = 0',
    whereArgs: [usuarioId],
  );
}

// 🔹 Marcar contacto como sincronizado
Future<void> marcarContactoSincronizado(int contactoId) async {
  final db = await database;
  await db.update(
    'contactos',
    {'sync': 1},
    where: 'id = ?',
    whereArgs: [contactoId],
  );
}
Future<int> updateUsuarioFoto(int id, String fotoPath) async {
  final db = await database;

  return await db.update(
    'usuarios',
    {
      'foto': fotoPath,
      'sync': 0
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<Map<String, dynamic>> getUsuario(int id) async {

  final db = await database;

  final result = await db.query(
    'usuarios',
    where: 'id = ?',
    whereArgs: [id],
  );

  return result.first;

}
}
