class MessageModel {
  String message;
  String sender_name;
  String sender_id;
  MessageModel(this.message, this.sender_name, this.sender_id);
  factory MessageModel.fromJson(jsonDAta) {
    return MessageModel(
        jsonDAta['message'], jsonDAta['sender_name'], jsonDAta['sender_id']);
  }
}
