import 'dart:collection';
import 'dart:io';

import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/models/user_model.dart';
import 'package:app_chat/core/provider/chat_detail_provider.dart';
import 'package:app_chat/core/service/chat_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/models/message_model.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/provider/voice_record_provider.dart';
import '../../../core/service/database_service.dart';
import '../../../utils/helpers/custom_audio_player.dart';

part 'modules/chat_detail_appbar.dart';
part 'modules/chat_detail_popup_button.dart';
part 'modules/chat_detail_message_row.dart';
part 'modules/chat_stream.dart';
part 'modules/message_list.dart';
part 'modules/show_pick_image_dialog.dart';
part 'modules/map_image_thumbnail.dart';
part 'modules/map_page.dart';
part 'modules/show_stacked_image_preview.dart';
part 'modules/show_stacked_map_preview.dart';

class ChatPage extends StatefulWidget {
  final UserModel getDetails;
  const ChatPage({required this.getDetails, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
          if (chatDetailProvider.showVoiceRecord &&
              !chatDetailProvider.isMapReadyToSend)
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
                          gradient: LinearGradient(colors: [
                            Theme.of(context).errorColor,
                            Colors.orange
                          ]),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          voiceRecordProvider.recorderTxt,
                          style: TextStyle(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  )),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).iconTheme.color,
                    child: IconButton(
                      onPressed: () async {
                        await voiceRecordProvider.sendVoiceMessage(
                            context, widget.getDetails);
                      },
                      icon: voiceRecordProvider.isRecordingMessageSending
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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
          if (!chatDetailProvider.showVoiceRecord &&
              !chatDetailProvider.isMapReadyToSend)
            _ChatDetailMessageRow(
                chatDetailProvider: chatDetailProvider,
                widget: widget,
                userProvider: userProvider),
          Offstage(
            offstage: !chatDetailProvider.emojiShowing,
            child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  textEditingController: chatDetailProvider.chatController,
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
