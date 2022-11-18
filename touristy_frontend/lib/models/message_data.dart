class MessageData {
  final int senderId;
  final int lastMessageSenderId;
  final String message;
  final String senderName;
  final DateTime messageDate;
  final String dateMessage;
  final String profilePicture;
  final bool isRead;

  MessageData({
    required this.senderId,
    required this.lastMessageSenderId,
    required this.message,
    required this.senderName,
    required this.messageDate,
    required this.dateMessage,
    required this.profilePicture,
    required this.isRead,
  });
}
