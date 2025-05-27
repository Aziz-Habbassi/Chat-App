import 'dart:io';

import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key, required this.message, required this.porfilPicUrl});
  final String porfilPicUrl;
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 70),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(porfilPicUrl),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
                color: kSixColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
        ),
      ],
    );
  }
}
