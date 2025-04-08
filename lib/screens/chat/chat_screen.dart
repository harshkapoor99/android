import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final _focusNodes = FocusNode();

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

  @override
  Widget build(BuildContext context) {
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
                      // height: 45.w,
                      child: TextField(
                        // maxLines: null,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        focusNode: _focusNodes,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 12.w,
                              top: 10.w,
                              bottom: 10.w,
                            ),
                            child: SvgPicture.asset(
                              Assets.svgs.icChatPrefix,
                              height: 10.w,
                              width: 10.w,
                            ),
                          ),
                          hintText: "Start your dream chatting",
                          hintStyle: context.appTextStyle.textSmall.copyWith(
                            color: context.colorExt.textPrimary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          filled: true,
                          fillColor: context.colorExt.border,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  10.pw,
                  Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      color: context.colorExt.border,
                      borderRadius: BorderRadius.circular(100.w),
                    ),
                    child: const Icon(Icons.mic, color: Colors.white),
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
