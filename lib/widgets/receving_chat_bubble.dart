import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/message_model.dart';
import 'package:flutter/material.dart';

class RecevingChatBubble extends StatelessWidget {
  const RecevingChatBubble(
      {super.key, required this.message, required this.porfilPicUrl});
  final MessageModel message;
  final String porfilPicUrl;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: kForthColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16))),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.sender_name,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              Text(
                message.message,
                style: TextStyle(color: kThirdColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 70),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(porfilPicUrl) == null
                ? null
                : NetworkImage(porfilPicUrl),
          ),
        ),
      ],
    );
  }
}
