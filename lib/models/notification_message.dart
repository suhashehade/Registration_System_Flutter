class NotificationMessage {
  final String title;
  final String body;
  final Map<String, dynamic> payload;

  NotificationMessage(
      {required this.title, required this.body, required this.payload});
}
