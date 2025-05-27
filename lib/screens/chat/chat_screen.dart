import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/chat_bubble.dart';
import 'package:guftagu_mobile/components/message_box.dart';
import 'package:guftagu_mobile/components/send_button.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:lottie/lottie.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:guftagu_mobile/utils/file_compressor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends ConsumerStatefulWidget {
  ChatScreen({super.key});
  final _focusNodes = FocusNode();
  final ImagePicker picker = ImagePicker();

  getPermission(Permission permission) async {
    var checkStatus = await permission.status;

    if (checkStatus.isGranted) {
      return;
    } else {
      var status = await permission.request();
      if (status.isGranted) {
      } else if (status.isDenied) {
        getPermission(permission);
      } else {
        openAppSettings();
        // EasyLoading.showError('Allow the permission');
      }
    }
  }

  Future getImage(ImageSource media, WidgetRef ref) async {
    if (media == ImageSource.camera) {
      getPermission(Permission.camera);
    } else {
      getPermission(Permission.storage);
    }
    var img = await picker.pickImage(source: media);
    if (img != null) {
      var image = await compressImage(File(img.path));
      if (image != null) {
        // ref.read(characterCreationProvider.notifier).updateWith(uploadImage: img);
        // ref
        //     .read(characterCreationProvider.notifier)
        //     .uploadImage(image: XFile(image.path));
        image = null;
      }
    }
  }

  void getDocument(File file, WidgetRef ref) async {
    await getPermission(Permission.storage);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      File pickedFile = File(result.files.single.path!);
      // You can compress or validate the document if needed
      // Example: ref.read(chatProvider.notifier).uploadDocument(pickedFile);
      debugPrint("Document picked: ${pickedFile.path}");
    } else {
      debugPrint("No document selected.");
    }
  }

  void getAudio(File file, WidgetRef ref) async {
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
                child: CircleAvatar(backgroundImage: NetworkImage(image)),
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
                              return Align(
                                alignment:
                                    Alignment
                                        .centerLeft, // Align like incoming messages
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .end, // Align avatar bottom with animation
                                  children: [
                                    // Display the AI's avatar
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                        bottom: 5,
                                      ), // Add bottom margin to align
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image:
                                              Image.network(
                                                image,
                                              ).image, // Use the existing image url variable
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Display the Lottie animation
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      // Optional background/padding for Lottie:
                                      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                      // decoration: BoxDecoration(
                                      //    color: context.colorExt.border,
                                      //    borderRadius: BorderRadius.circular(10),
                                      // ),
                                      child: Lottie.asset(
                                        'assets/animations/du.json', // <-- *** ADJUST THIS PATH TO YOUR FILE ***
                                        width: 60, // Adjust width as needed
                                        height: 40, // Adjust height as needed
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
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

                            bool showDateSeparator = false;
                            if (messageIndex == provider.messages.length - 1) {
                              showDateSeparator = true;
                            } else if (messageIndex <
                                provider.messages.length - 1) {
                              final prevMessage =
                                  provider.messages[messageIndex + 1];
                              showDateSeparator =
                                  !isSameDay(
                                    provider.messages[messageIndex].time,
                                    prevMessage.time,
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
                                    provider.messages[messageIndex].time,
                                  ),
                                ChatBubble(
                                  text: provider.messages[messageIndex].text,
                                  isMe: provider.messages[messageIndex].isMe,
                                  imageUrl:
                                      image, // Pass the AI image url (used if isMe is false)
                                  time:
                                      provider.messages[messageIndex].time
                                          .toLocal(),
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
                          hasMessage: provider.hasMessage,
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
                                Navigator.of(context).pop();
                                widget.getDocument(File(''), ref);
                              },
                              pressAudio: () async {
                                Navigator.of(context).pop();
                                widget.getAudio(File(''), ref);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    10.pw,
                    AnimatedSendButton(
                      hasText: provider.hasMessage,
                      onPressed: () {
                        final chatNotifier = ref.read(chatProvider.notifier);

                        if (provider.hasMessage) {
                          chatNotifier.chatWithCharacter();
                        } else {
                          chatNotifier.sendStaticVoiceMessage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
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
        color: context.colorExt.border,
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
