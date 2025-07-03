import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/chat_bubble_audio.dart';
import 'package:guftagu_mobile/components/chat_bubble_file.dart';
import 'package:guftagu_mobile/components/chat_bubble_text.dart';
import 'package:guftagu_mobile/components/chat_bubble_typing.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/message_box.dart';
import 'package:guftagu_mobile/components/send_button.dart';
import 'package:guftagu_mobile/enums/chat_type.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends ConsumerStatefulWidget {
  ChatScreen({super.key});
  final _focusNodes = FocusNode();
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media, WidgetRef ref) async {
    if (media == ImageSource.camera) {
      getPermission(Permission.camera);
    } else {
      getPermission(Permission.storage);
    }
    var img = await picker.pickImage(source: media);
    if (img != null) {
      var image = File(img.path);
      // ref.read(characterCreationProvider.notifier).updateWith(uploadImage: img);
      ref.read(chatProvider.notifier).attachFile(image, isImage: true);
    }
  }

  void getDocument(WidgetRef ref) async {
    await getPermission(Permission.storage);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'csv', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      var pickedFile = File(result.files.single.path!);
      // You can compress or validate the document if needed
      ref.read(chatProvider.notifier).attachFile(pickedFile);
      debugPrint(
        "Document picked: ${pickedFile.path} ${lookupMimeType(pickedFile.path)}",
      );
    } else {
      debugPrint("No document selected.");
    }
  }

  void getAudio(WidgetRef ref) async {
    await getPermission(Permission.storage);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      File pickedAudio = File(result.files.single.path!);
      // You can process the audio here (e.g., upload or transcribe)
      // Example: ref.read(chatProvider.notifier).uploadAudio(pickedAudio);
      debugPrint("Audio picked: ${pickedAudio.path}");
    } else {
      debugPrint("No audio file selected.");
    }
  }

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    super.initState();
  }

  void init() {
    ref.read(chatProvider.notifier).fetchChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(chatProvider);
    var image =
        provider.character!.imageGallery
            .where((element) => element.selected == true)
            .first
            .url;
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (image == null) {
      image = provider.character!.imageGallery.first.url;
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(chatProvider.notifier).fetchChatList();
          ref.read(chatProvider.notifier).clearHistory();
        }
      },
      child: Scaffold(
        backgroundColor: context.colorExt.background,
        appBar: AppBar(
          backgroundColor: context.colorExt.background,
          // automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
            splashColor: Colors.transparent,
            icon: const Icon(Icons.chevron_left_rounded, size: 30),
            onPressed: () {
              context.nav.pop();
            },
          ),
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.nav.pushNamed(Routes.characterProfile);
                },
                child: Hero(
                  tag: "character_image",
                  child: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),

                      child: NetworkImageWithPlaceholder(
                        imageUrl: image,
                        placeholder: SvgPicture.asset(
                          Assets.svgs.icProfilePlaceholder,
                        ),
                        fit: BoxFit.cover,
                        errorWidget: SvgPicture.asset(
                          Assets.svgs.icProfilePlaceholder,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              10.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.character!.name,
                    style: context.appTextStyle.textBold,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                        ),
                      ),
                      5.pw,
                      Text(
                        "Online",
                        style: context.appTextStyle.text.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // SvgPicture.asset(Assets.svgs.icDiamonGold, height: 20),
              // 5.pw,
              // Text(
              //   '1200',
              //   style: context.appTextStyle.textBold.copyWith(fontSize: 12),
              // ),
              // 25.pw,
              // IconButton(
              //   onPressed: () => context.nav.pushNamed(Routes.call),
              //   icon: const Icon(Icons.call, color: Colors.white),
              // ),
              20.pw,
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => widget._focusNodes.unfocus(),
          child: Column(
            children: [
              Expanded(
                child:
                    provider.isFetchingHistory
                        ? const SizedBox.shrink() // Show nothing while fetching history
                        : ListView.builder(
                          reverse:
                              true, // Keep showing latest messages at the bottom
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          // Adjust itemCount based on whether typing indicator should be shown
                          itemCount:
                              provider.isTyping
                                  ? provider.messages.length +
                                      1 // +1 for the typing indicator
                                  : provider.messages.length,
                          itemBuilder: (context, index) {
                            // --- Handle typing indicator ---
                            if (provider.isTyping && index == 0) {
                              // Display Lottie animation when typing
                              return ChatBubbleTyping(
                                isMe: false,
                                imageUrl: image,
                              );
                            }
                            // --- End typing indicator ---

                            // Adjust index to get the correct message from the list
                            // This logic correctly accounts for the presence/absence of the typing indicator
                            final messageIndex =
                                provider.isTyping
                                    ?
                                    // provider.messages.length -
                                    //     1 -
                                    (index -
                                        1) // Adjust index when typing indicator is present
                                    :
                                    // provider.messages.length -
                                    //     1 -
                                    index; // Normal index when no typing indicator

                            final message = provider.messages[messageIndex];

                            bool showDateSeparator = false;
                            if (messageIndex == provider.messages.length - 1) {
                              showDateSeparator = true;
                            } else if (messageIndex <
                                provider.messages.length - 1) {
                              final prevMessage =
                                  provider.messages[messageIndex + 1];
                              showDateSeparator =
                                  !isSameDay(
                                    provider.messages[messageIndex].timestamp,
                                    prevMessage.timestamp,
                                  );
                            }

                            // Return the actual chat message bubble
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showDateSeparator
                                // && messageIndex < provider.messages.length - 1
                                )
                                  _buildDateSeparator(
                                    context,
                                    message.timestamp,
                                  ),
                                if (message.chatType == ChatType.audio.name)
                                  ChatBubbleAudio(
                                    message: message,
                                    isMe: message.isMe,
                                    imageUrl:
                                        image, // Pass the AI image url (used if isMe is false)
                                    time: message.timestamp.toLocal(),
                                    path: message.audioPath,
                                    url: message.voiceUrl,
                                  ),
                                if (message.chatType == ChatType.file.name ||
                                    message.chatType == ChatType.image.name)
                                  ChatBubbleFile(
                                    message: message,
                                    isMe: message.isMe,
                                    imageUrl:
                                        image, // Pass the AI image url (used if isMe is false)
                                    time: message.timestamp.toLocal(),
                                    path: message.filePath,
                                    url: message.fileUrl,
                                  ),
                                if (message.chatType == ChatType.text.name)
                                  ChatBubbleText(
                                    text: message.message!,
                                    isMe: message.isMe,
                                    imageUrl:
                                        image, // Pass the AI image url (used if isMe is false)
                                    time: message.timestamp.toLocal(),
                                  ),
                              ],
                            );
                          },
                        ),
              ),
              AnimatedContainer(
                duration: Durations.long2,
                height: provider.isFetchingHistory ? 25 : 0,
                child: const Text("Loading your chat history..."),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: MessageBox(
                          controller: ref.read(chatProvider).messageController,
                          hasMessage:
                              provider.hasMessage ||
                              provider.uploadFile != null,
                          recordingController: provider.recordController,
                          isRecordig: provider.isRecording,
                          focusNodes: widget._focusNodes,
                          onPlusPressed: () {
                            AppConstants.getPickImageAlert(
                              context: context,
                              pressCamera: () {
                                widget.getImage(ImageSource.camera, ref);
                                Navigator.of(context).pop();
                              },
                              pressGallery: () {
                                widget.getImage(ImageSource.gallery, ref);
                                Navigator.of(context).pop();
                              },
                              pressDocument: () async {
                                widget.getDocument(ref);
                                Navigator.of(context).pop();
                              },
                              pressAudio: () async {
                                widget.getAudio(ref);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          attachedFile: provider.uploadFile,
                          onFileRemovePressed:
                              provider.uploadFile != null
                                  ? ref.read(chatProvider.notifier).dettachFile
                                  : null,
                          isImage: provider.isAttachmentImage,
                        ),
                      ),
                    ),
                    10.pw,
                    AnimatedSendButton(
                      hasText:
                          provider.hasMessage || provider.uploadFile != null,
                      onPressed: () {
                        final chatNotifier = ref.read(chatProvider.notifier);

                        if (provider.uploadFile != null) {
                          chatNotifier.fileChatWithCharacter(
                            isImage: provider.isAttachmentImage,
                          );
                        } else if (provider.hasMessage) {
                          chatNotifier.chatWithCharacter();
                        } else {
                          chatNotifier.startOrStopRecording();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDateSeparator(BuildContext context, DateTime date) {
  // final formatted = DateFormat.yMMMd().format(date);
  final formatted = formatChatDivider(date);
  return Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorExt.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        formatted,
        style: context.appTextStyle.text.copyWith(fontSize: 10),
      ),
    ),
  );
}

bool isSameDay(DateTime d1, DateTime d2) {
  return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
}
