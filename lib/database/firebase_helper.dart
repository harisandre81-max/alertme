import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseHelper._privateConstructor();
  static final FirebaseHelper instance = FirebaseHelper._privateConstructor();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 BUSCAR USUARIO POR EMAIL (LOGIN)
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  try {
    var query = await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;

      return {
        'firebaseId': doc.id,
        'nombre': doc['nombre'],
        'edad': doc['edad'],
        'direccion': doc['direccion'],
        'telefono': doc['telefono'],
        'email': doc['email'],
        'foto': doc['foto'],
      };
    }

    return null;
  } catch (e) {
    print("Error FirebaseHelper.getUserByEmail: $e");
    return null;
  }
}

  // 🔹 SUBIR / ACTUALIZAR USUARIO
  Future<void> subirUsuario(int usuarioId, Map<String, dynamic> usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuarioId.toString())
        .set({
      'nombre': usuario['nombre'],
      'edad': usuario['edad'],
      'direccion': usuario['direccion'],
      'telefono': usuario['telefono'],
      'email': usuario['email'],
      'foto': usuario['foto'],
    }, SetOptions(merge: true));
  }

  // 🔹 SUBIR / ACTUALIZAR CONTACTO
  Future<void> subirContacto(
      int usuarioId, int contactoId, Map<String, dynamic> contacto) async {
    await _firestore
        .collection('usuarios')
        .doc(usuarioId.toString())
        .collection('contactos')
        .doc(contactoId.toString())
        .set({
      'nombre': contacto['nombre'],
      'edad': contacto['edad'],
      'telefono': contacto['telefono'],
      'parentesco': contacto['parentesco'],
      'foto': contacto['foto'],
    }, SetOptions(merge: true));
  }
  Future<List<Map<String, dynamic>>> getContactosFirebase(String firebaseUserId) async {
  try {
    var query = await _firestore
        .collection('usuarios')
        .doc(firebaseUserId)
        .collection('contactos')
        .get();

    return query.docs.map((doc) {
      return {
        'firebaseId': doc.id,
        'nombre': doc['nombre'],
        'edad': doc['edad'],
        'telefono': doc['telefono'],
        'parentesco': doc['parentesco'],
        'foto': doc['foto'],
      };
    }).toList();
  } catch (e) {
    print("Error descargando contactos: $e");
    return [];
  }
}
}