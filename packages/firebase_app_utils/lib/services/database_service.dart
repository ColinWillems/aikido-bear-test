import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxService {
  final firestore = FirebaseFirestore.instance;
  Future<DatabaseService> init() async {
    return this;
  }
}
