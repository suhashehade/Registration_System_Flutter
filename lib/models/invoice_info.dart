class InvoiceInfo {
  final DateTime date;
  final DateTime dueDate;
  final String number;
  final List termsAndConditions;

  InvoiceInfo(
      {required this.date,
      required this.dueDate,
      required this.number,
      required this.termsAndConditions});
}
