import 'dart:collection';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/service/chat_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/message_model.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/provider/voice_record_provider.dart';
import '../../../core/service/database_service.dart';
import '../../../utils/helpers/custom_audio_player.dart';

part 'parts/chat_detail_appbar.dart';
part 'parts/chat_detail_popup_button.dart';
part 'parts/chat_detail_message_row.dart';
part 'parts/chat_stream.dart';
part 'parts/message_list.dart';
part 'parts/show_pick_image_dialog.dart';

class ChatPage extends StatefulWidget {
  final UserModel getDetails;
  const ChatPage({required this.getDetails, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final TextEditingController _chat = TextEditingController();

  @override
  void initState() {
    super.initState();

    voiceRecorderInit();
  }

  void voiceRecorderInit() {
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context, listen: false);
    voiceRecordProvider.init();
  }



  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context);
    ChatDetailProvider chatDetailProvider =
        Provider.of<ChatDetailProvider>(context);
    return Scaffold(
      appBar: _ChatDetailAppBar(
          userProvider: userProvider, getDetails: widget.getDetails),
      body: Column(
        children: [
          _ChatStream(
            userProvider: userProvider,
            chatDetailProvider: chatDetailProvider,
            getDetails: widget.getDetails,
          ),
          if (chatDetailProvider.showVoiceRecord)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      chatDetailProvider.showVoiceRecord =
                          !chatDetailProvider.showVoiceRecord;
                      voiceRecordProvider.recorderTxt = '00:00';
                      voiceRecordProvider.isRecording = false;
                      voiceRecordProvider.recordingEnded = false;
                      voiceRecordProvider.notify();
                      chatDetailProvider.notify();
                    },
                    child: const Icon(Icons.close),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(voiceRecordProvider.recorderTxt),
                      ),
                    ),
                  )),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                     onPressed: ()async{
                       await voiceRecordProvider.sendVoiceMessage(
                          context, widget.getDetails);
                     },
                      icon:voiceRecordProvider.isRecordingMessageSending ?
                      const CircularProgressIndicator()
                       : Icon(
                        
                        voiceRecordProvider.recordingEnded
                            ? Icons.send
                            : voiceRecordProvider.isRecording
                                ? Icons.stop
                                : Icons.mic_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!chatDetailProvider.showVoiceRecord)
            _ChatDetailMessageRow(
                chatDetailProvider: chatDetailProvider,
                widget: widget,
                userProvider: userProvider)
        ],
      ),
    );
  }
}
