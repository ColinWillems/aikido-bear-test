import 'package:get/get.dart';

class UrlService extends GetxService {
  final Map<String, String> pathMap = {"/": "/home"};
  void setUrlOverride(
      {required String originalPath, required replacementPath}) {
    pathMap[originalPath] = replacementPath;
  }

  String? getUrlOverride({required String originalPath}) {
    return pathMap[originalPath];
  }
}
