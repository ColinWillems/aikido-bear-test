// ignore_for_file: unused_local_variable

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bear_adventure_app/app/modules/support/controllers/navigation/support_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class ReportIssueController extends GetxController {
  ReportIssueController(
      {required this.service,
      required this.urlService,
      required this.permissionsService});

  final ContactService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  final TextEditingController nameEditingController = TextEditingController(
    text: "",
  );

  final TextEditingController emailAddressEditingController =
      TextEditingController(
    text: "",
  );

  final TextEditingController subjectEditingController = TextEditingController(
    text: "",
  );

  final TextEditingController messageEditingController = TextEditingController(
    text: "",
  );

  final formKey = GlobalKey<FormState>();
  final stepsKey = GlobalKey<IntroductionScreenState>();

  final RxBool formIsValid = false.obs;
  final RxInt currentStep = 0.obs;
  final RxBool isLastStep = false.obs;
  final RxBool isFirstStep = true.obs;
  final Rx<SupportCountry?> country = Rx<SupportCountry?>(null);

  bool isFirstChange = true;

  String name = "";
  String email = "";
  String subject = "";
  String message = "";

  late final SupportNavigation navigation;

  @override
  void onInit() {
    navigation = SupportNavigation(
        urlService: urlService, permissionsService: permissionsService);

    nameEditingController.addListener(onFormChange);
    emailAddressEditingController.addListener(onFormChange);
    subjectEditingController.addListener(onFormChange);
    messageEditingController.addListener(onFormChange);
    super.onInit();
  }

  @override
  void onClose() {
    nameEditingController.removeListener(onFormChange);
    nameEditingController.dispose();
    emailAddressEditingController.removeListener(onFormChange);
    emailAddressEditingController.dispose();
    subjectEditingController.removeListener(onFormChange);
    subjectEditingController.dispose();
    messageEditingController.removeListener(onFormChange);
    messageEditingController.dispose();
    super.onClose();
  }

  void onFormChange() {
    var dirty = false;
    if (nameEditingController.text != name) {
      name = nameEditingController.text;
      dirty = true;
    }
    if (emailAddressEditingController.text != email) {
      email = emailAddressEditingController.text;
      dirty = true;
    }
    if (subjectEditingController.text != subject) {
      subject = subjectEditingController.text;
      dirty = true;
    }
    if (messageEditingController.text != message) {
      message = messageEditingController.text;
      dirty = true;
    }
    _revalidate();
  }

  void onCountryChanged(SupportCountry? value) {
    country.value = value;
    onFormChange();
  }

  Future<void> submitForm() async {
    final SupportCountry? selectedCountry = country.value;
    if (selectedCountry == null) return;

    final String messageToSend =
        "$message\n\nCountry: ${selectedCountry.label}\n\n${await BearApp.getAppVersion}${await BearApp.getDeviceInfo}";

    final String htmlMessage = messageToSend.splitMapJoin(
      RegExp(
        "[\n]+",
        multiLine: true,
        unicode: true,
      ),
      onMatch: (p0) => "",
      onNonMatch: (p0) => "<p>$p0</p>",
    );
    final bool success = await service.sendEmail(
        fromName: name,
        fromAddress: email,
        toName: BearApp.bearSupportName,
        toAddress: BearApp.bearSupportEmail,
        subject: "Issue report: $subject",
        plainMessage: messageToSend,
        htmlMessage: htmlMessage,
        senderEmail: selectedCountry.senderEmail,
        senderName: selectedCountry.senderName);
    if (success) {
      final OkCancelResult result = await Dialogs.showDialog(
        title: "Issue reported",
        message: "your issue was successfully reported.",
        path: "/support/report-issue/successfully-reported",
      );
      Get.close();
      navigation.goHome();
    } else {
      await Dialogs.showErrorDialog(
        "unable to send report. Please check your internet connection and try again.",
        "/support/report-issue/error-not-reported",
      );
    }
  }

  String? Function(String?)? getValidatorForField(
      String fieldName, TextInputType type) {
    String? emailValidator(String? value) {
      return (value == null || !value.isEmail)
          ? "$fieldName must be a valid email"
          : null;
    }

    String? nonEmptyValidator(String? value) {
      return (value == null || value.isEmpty)
          ? "$fieldName cannot be empty"
          : null;
    }

    Map<TextInputType, String? Function(String?)> validatorMap = {
      TextInputType.emailAddress: emailValidator,
      TextInputType.name: nonEmptyValidator,
      TextInputType.text: nonEmptyValidator,
      TextInputType.multiline: nonEmptyValidator,
    };

    return validatorMap[type] ?? nonEmptyValidator;
  }

  void previousStep() {
    stepsKey.currentState?.previous();
  }

  void nextStep() {
    stepsKey.currentState?.next();
  }

  void goToStep(int stepIndex) {
    stepsKey.currentState?.animateScroll(stepIndex);
  }

  void onStepChange(int newIndex) {
    int numPages = stepsKey.currentState?.getPagesLength() ?? 1;

    currentStep(newIndex);
    isFirstStep(currentStep() == 0);
    isLastStep(currentStep() == (numPages - 1));
    _revalidate();
  }

  void _revalidate() {
    Future.delayed(1.milliseconds, () {
      if (currentStep.value == 0) {
        formIsValid(country.value != null &&
            name.isNotEmpty &&
            email.isEmail);
      } else {
        formIsValid(subject.isNotEmpty && message.isNotEmpty);
      }
    });
  }
}
