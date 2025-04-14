import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends ConsumerWidget {
  ChatScreen({super.key});
  final _focusNodes = FocusNode();
  final ImagePicker picker = ImagePicker();

  final List<Map<String, dynamic>> messages = [
    {'isMe': false, 'text': "Hey, what's up?"},
    {
      'isMe': true,
      'text': "Not much, just hanging out at home. How about you?",
    },
    {'isMe': false, 'text': "Hey, what's up?"},
    {
      'isMe': true,
      'text': "Not much, just hanging out at home. How about you?",
    },
    {
      'isMe': true,
      'text': "Not much, just hanging out at home. How about you?",
    },
  ];

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

  Future getImage(ImageSource media) async {
    if (media == ImageSource.camera) {
      getPermission(Permission.camera);
    } else {
      getPermission(Permission.storage);
    }
    var img = await picker.pickImage(source: media);
    if (img != null) {
      // var image = await compressImage(File(img.path));
      // var image = File(img.path);
      // if (image != null) {
      //   ref.read(profileServiceProvider).uploadImage = XFile(image.path);
      //   image = null;
      //   setState(() {});
      // }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(chatProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorExt.background,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.chevron_left_rounded, size: 30.w),
              onPressed: () {
                context.nav.pop();
              },
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: Assets.images.model.modImg1.provider(),
            ),
            10.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jaan", style: context.appTextStyle.textBold),
                Row(
                  children: [
                    5.pw,
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                    ),
                    5.pw,
                    Text(
                      "Online",
                      style: context.appTextStyle.text.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(Assets.svgs.icCoins, height: 20.w),
            5.pw,
            Text(
              '1200',
              style: context.appTextStyle.textBold.copyWith(fontSize: 12.sp),
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
        onTap: () => _focusNodes.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    text: messages[index]['text'],
                    isMe: messages[index]['isMe'],
                  );
                },
              ),
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
                        focusNodes: _focusNodes,
                        onPlusPressed: () {
                          AppConstants.getPickImageAlert(
                            context: context,
                            pressCamera: () {
                              getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                            pressGallery: () {
                              getImage(ImageSource.gallery);
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
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
        padding: EdgeInsets.only(left: 12.w),
        decoration: BoxDecoration(
          color: context.colorExt.border,
          borderRadius: BorderRadius.circular(
            widget.hasMessage || isFocused ? 10.r : 60.r,
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
              height: 16.w,
              width: 16.w,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.svgs.icChatPrefix,
                height: 16.w,
                width: 16.w,
              ),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                focusNode: widget.focusNodes,
                style: context.appTextStyle.textSmall.copyWith(fontSize: 12.sp),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    top: 5.w,
                    bottom: 5.w,
                    left: 8.w,
                  ),

                  hintText: "Start your dream chatting",
                  hintStyle: context.appTextStyle.textSmall.copyWith(
                    fontSize: 12.sp,
                    color: context.colorExt.textPrimary.withValues(alpha: 0.7),
                  ),
                  fillColor: context.colorExt.border,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              height: 40.w,
              width: widget.hasMessage ? 0 : 40.w,
              duration: Duration(milliseconds: 100),
              child: IconButton(
                onPressed: widget.onPlusPressed,
                icon: SvgPicture.asset(
                  Assets.svgs.icPlus,
                  height: 16.w,
                  width: 16.w,
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
      width: 45.w,
      height: 45.w,
      decoration: BoxDecoration(
        color: context.colorExt.border,
        borderRadius: BorderRadius.circular(100.w),
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
                  ? SvgPicture.asset(Assets.svgs.icSend, key: ValueKey("send"))
                  : SvgPicture.asset(Assets.svgs.icMic, key: ValueKey("mic")),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              margin: EdgeInsets.only(right: 10.w),
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                image: DecorationImage(
                  image: Assets.images.model.modImg1.provider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient:
                  isMe
                      ? const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      )
                      : null,
              color: isMe ? null : context.colorExt.border,
              borderRadius: BorderRadius.only(
                //
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w),
                bottomLeft: Radius.circular(isMe ? 10.w : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10.w),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
