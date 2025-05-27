import 'package:chatapp_supabase/constants/constants.dart';
import 'package:chatapp_supabase/models/message_model.dart';
import 'package:chatapp_supabase/models/profil_model.dart';
import 'package:chatapp_supabase/pages/loading_screen.dart';
import 'package:chatapp_supabase/widgets/chat_bubble.dart';
import 'package:chatapp_supabase/widgets/receving_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = "ChatPage";
  @override
  Widget build(BuildContext context) {
    SupabaseClient supabase = Supabase.instance.client;
    final messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id']).order('created_at');

    final Map<String, dynamic> user_profil =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ProfilModel user = user_profil['user'];
    final ScrollController scrollcntrl = ScrollController();

    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: messagesStream,
        builder: (BuildContext context, snapshot) {
          List<MessageModel> messagesList = [];

          if (snapshot.hasData) {
            for (final message in snapshot.data!) {
              messagesList.add(MessageModel.fromJson(message));
            }

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: kSecondColor,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: scrollcntrl,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          if (messagesList[index].sender_id == user.id) {
                            return ChatBubble(
                              porfilPicUrl: user.profilpicurl,
                              message: messagesList[index],
                            );
                          } else {
                            return RecevingChatBubble(
                              message: messagesList[index],
                              porfilPicUrl:
                                  get_sender_pic(messagesList[index].sender_id),
                            );
                          }
                        },
                      ),
                    ),
                    message_field(
                      name: user.name,
                      scroller: scrollcntrl,
                    )
                  ],
                ));
          } else {
            return LoadingScreen();
          }
        });
  }

  String get_sender_pic(String id) {
    final senderImage = Supabase.instance.client.storage
        .from('profil_pictures')
        .getPublicUrl(id);
    return senderImage;
  }
}

class message_field extends StatelessWidget {
  message_field({
    super.key,
    required this.name,
    required this.scroller,
  });
  String name;
  TextEditingController value = TextEditingController();
  ScrollController scroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: value,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 20),
                onPressed: () {
                  if (value.text.isNotEmpty) {
                    sendMessage(value.text, name);
                    value.clear();
                  }
                  scroller.jumpTo(scroller.position.minScrollExtent);
                },
                icon: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: kSixColor,
                )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kSixColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kForthColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kSixColor, width: 2))),
      ),
    );
  }

  void sendMessage(String text, String name) async {
    await Supabase.instance.client
        .from('messages')
        .insert({'sender_name': name, 'message': text});
  }
}
