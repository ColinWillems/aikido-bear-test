/// Country selection used by the contact / report-issue forms.
///
/// The selected country determines which sender mailbox is used when
/// dispatching the email through the `sendUserEmail` Firebase Function.
enum SupportCountry {
  unitedKingdom(
    code: "UK",
    label: "United Kingdom",
    senderEmail: "bear.uk@bearsnacks.com",
    senderName: "Bear Snacks UK",
  ),
  unitedStates(
    code: "US",
    label: "United States",
    senderEmail: "bear.us@bearsnacks.com",
    senderName: "Bear Snacks US",
  );

  const SupportCountry({
    required this.code,
    required this.label,
    required this.senderEmail,
    required this.senderName,
  });

  /// ISO-style short code (e.g. "UK", "US").
  final String code;

  /// Human-readable label shown in the dropdown.
  final String label;

  /// Sender mailbox used as the `from` address by the email function.
  final String senderEmail;

  /// Friendly sender name shown alongside [senderEmail].
  final String senderName;
}
