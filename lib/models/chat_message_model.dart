class ChatMessageModel {
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessageModel({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return ChatMessageModel(
      sender: map['sender'],
      text: map['text'],
      timestamp: DateTime.parse(
        map['timestamp'],
      ),
    );
  }
}