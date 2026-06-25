import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class ContactService extends GetxService {
  ContactService();
  static const String gitHubOrganisationName =
      String.fromEnvironment('GH_ORG', defaultValue: '');
  static const String gitHubRepositoryName =
      String.fromEnvironment('GH_REPO', defaultValue: '');
  static const String gitHubUsername =
      String.fromEnvironment('GH_USER', defaultValue: '');
  static const String gitHubAccessToken =
      String.fromEnvironment('GH_TOKEN', defaultValue: '');
  static const String gitHubUrl = "https://api.github.com/repos";

  /// Sends an email via the [sendUserEmail] Firebase Cloud Function.
  ///
  /// The [toAddress] / [toName] are the recipient (e.g. support inbox).
  /// The [fromAddress] / [fromName] are set as Reply-To so the support team
  /// can reply directly to the user.
  /// [senderEmail] / [senderName] optionally override the mailbox used as the
  /// `from` address by the Cloud Function (e.g. UK vs US sender).
  ///
  /// Returns `true` on success, or `false` on failure.
  Future<bool> sendEmail({
    required String fromName,
    required String fromAddress,
    required String toName,
    required String toAddress,
    required String subject,
    required String plainMessage,
    required String htmlMessage,
    String? senderEmail,
    String? senderName,
  }) async {
    try {
      final callable = FirebaseFunctions.instanceFor(region: "europe-west1")
          .httpsCallable('sendUserEmail');
      final Map<String, dynamic> payload = <String, dynamic>{
        'to': toAddress,
        'toName': toName,
        'replyTo': fromAddress,
        'replyToName': fromName,
        'subject': subject,
        'content': plainMessage,
        'htmlContent': htmlMessage,
      };
      if (senderEmail != null && senderEmail.isNotEmpty) {
        payload['senderEmail'] = senderEmail;
      }
      if (senderName != null && senderName.isNotEmpty) {
        payload['senderName'] = senderName;
      }
      final result = await callable.call<Map<Object?, Object?>>(payload);
      if (result.data['success'] == true) return true;
      return false;
    } on FirebaseFunctionsException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reportIssue({
    required String fromName,
    required String fromAddress,
    required String summary,
    required String description,
  }) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer $gitHubAccessToken",
      "Content-Type": "application/vnd.github+json",
    };
    final String userEmailText = (fromAddress.isNotEmpty == true)
        ? '\n\n Originally created by $fromName <$fromAddress>'
        : '';
    const String url =
        '$gitHubUrl/$gitHubOrganisationName/$gitHubRepositoryName/issues';
    try {
      var bodyData = {
        "title": summary,
        "body": description + userEmailText,
        "labels": ["bug"]
      };

      /// return 201 usually
      var response = await post(Uri.parse(url),
          headers: headers, body: json.encode(bodyData));
      if ([200, 201, 202].contains(response.statusCode)) {
        return true;
      } else {
        var res = json.decode(response.body);
        if (res['errors'] != null) {
          return false;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }
}
