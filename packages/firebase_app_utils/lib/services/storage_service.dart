import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final storage = FirebaseStorage.instance;
  Future<StorageService> init() async {
    return this;
  }
}
