class MessageData {
  final int senderId;
  int? lastMessageSenderId;
  String? message;
  final String senderName;
  DateTime? messageDate;
  String? dateMessage;
  String? profilePicture;
  bool? isRead;

  MessageData({
    required this.senderId,
    this.lastMessageSenderId,
    this.message,
    required this.senderName,
    this.messageDate,
    this.dateMessage,
    this.profilePicture,
    this.isRead,
  });
}
