import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
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
      // var image = await compressImage(File(img.path));
      // ref.read(characterCreationProvider.notifier).updateWith(uploadImage: img);
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
          ref.read(chatProvider.notifier).clearHistory();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.colorExt.background,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 30),
                onPressed: () {
                  context.nav.pop();
                },
              );
            },
          ),
          title: Row(
            children: [
              CircleAvatar(backgroundImage: Image.network(image).image),
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
                      5.pw,
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
              SvgPicture.asset(Assets.svgs.icCoins, height: 20),
              5.pw,
              Text(
                '1200',
                style: context.appTextStyle.textBold.copyWith(fontSize: 12),
              ),
              25.pw,
              IconButton(
                onPressed: () => context.nav.pushNamed(Routes.call),
                icon: const Icon(Icons.call, color: Colors.white),
              ),
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
                                    ? provider.messages.length -
                                        1 -
                                        (index -
                                            1) // Adjust index when typing indicator is present
                                    : provider.messages.length -
                                        1 -
                                        index; // Normal index when no typing indicator

                            // Return the actual chat message bubble
                            return ChatBubble(
                              text: provider.messages[messageIndex].text,
                              isMe: provider.messages[messageIndex].isMe,
                              imageUrl:
                                  image, // Pass the AI image url (used if isMe is false)
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
                            );
                          },
                        ),
                      ),
                    ),
                    10.pw,
                    AnimatedSendButton(
                      hasText: provider.hasMessage,
                      onPressed: () {
                        ref.read(chatProvider.notifier).chatWithCharacter();
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

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    this.controller,
    this.focusNodes,
    required this.hasMessage,
    this.onStarPressed,
    this.onPlusPressed,
  });

  final bool hasMessage;
  final FocusNode? focusNodes;
  final TextEditingController? controller;
  final VoidCallback? onStarPressed;
  final VoidCallback? onPlusPressed;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          isFocused = value;
        });
      },
      child: AnimatedContainer(
        duration: Durations.short2,
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: context.colorExt.border,
          borderRadius: BorderRadius.circular(
            widget.hasMessage || isFocused ? 10 : 60,
          ),
          border: Border.all(
            color:
                isFocused ? context.colorExt.primary : context.colorExt.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.svgs.icChatPrefix,
                height: 16,
                width: 16,
              ),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                focusNode: widget.focusNodes,
                style: context.appTextStyle.textSmall,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 8,
                  ),

                  hintText: "Start your dream chatting",
                  hintStyle: context.appTextStyle.textSmall.copyWith(
                    fontSize: 12,
                    color: context.colorExt.textPrimary.withValues(alpha: 0.7),
                  ),
                  fillColor: context.colorExt.border,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              height: 40,
              width: widget.hasMessage ? 0 : 40,
              duration: const Duration(milliseconds: 100),
              child: IconButton(
                onPressed: widget.onPlusPressed,
                icon: SvgPicture.asset(
                  Assets.svgs.icPlus,
                  height: 16,
                  width: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSendButton extends StatelessWidget {
  final bool hasText;
  final VoidCallback onPressed;

  const AnimatedSendButton({
    required this.hasText,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: context.colorExt.border,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child:
              hasText
                  ? SvgPicture.asset(
                    Assets.svgs.icSend,
                    key: const ValueKey("send"),
                  )
                  : SvgPicture.asset(
                    Assets.svgs.icMic,
                    key: const ValueKey("mic"),
                  ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final String imageUrl;
  final bool showTyping;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    this.showTyping = false,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Key textKey = UniqueKey();
  void _deselectText() {
    setState(() {
      textKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isMe)
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: Image.network(widget.imageUrl).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient:
                  widget.isMe
                      ? const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      )
                      : null,
              color: widget.isMe ? null : context.colorExt.border,
              borderRadius: BorderRadius.only(
                //
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(widget.isMe ? 10 : 0),
                bottomRight: Radius.circular(widget.isMe ? 0 : 10),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: SelectableText(
              key: textKey,
              widget.text,
              style: context.appTextStyle.textSemibold.copyWith(
                fontSize: 14,
                color: Colors.white,
                fontStyle:
                    widget.showTyping ? FontStyle.italic : FontStyle.normal,
              ),
              contextMenuBuilder:
                  (
                    context,
                    editableTextState,
                  ) => AdaptiveTextSelectionToolbar.buttonItems(
                    buttonItems: [
                      ContextMenuButtonItem(
                        label: 'Copy',
                        onPressed: () {
                          // Handle copy action
                          Clipboard.setData(ClipboardData(text: widget.text));
                          _deselectText();
                        },
                      ),
                    ],
                    anchors: TextSelectionToolbarAnchors(
                      primaryAnchor:
                          editableTextState.contextMenuAnchors.primaryAnchor -
                          const Offset(0, 0),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
