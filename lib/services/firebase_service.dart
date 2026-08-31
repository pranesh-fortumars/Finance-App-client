import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/user_scheme.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._();
  FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _schemesRef => _firestore.collection('userSchemes');

  Future<List<User>> getUsers() async {
    final snapshot = await _usersRef.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> saveUser(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Future<void> saveUserScheme(UserScheme userScheme) async {
    await _schemesRef.doc(userScheme.id).set(userScheme.toMap());
  }

  Future<String> generateNextSerialNumber() async {
    final snapshot = await _usersRef.orderBy('createdAt', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) return 'CUST001';
    final lastUser = User.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    final number = int.tryParse(lastUser.serialNumber.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return 'CUST${(number + 1).toString().padLeft(3, '0')}';
  }
}
