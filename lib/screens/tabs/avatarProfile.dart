import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import '../../components/labeled_text_field.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

import '../../providers/chat_provider.dart'; // If .pw is here

const Color darkBackgroundColor = Color(0xFF0A0A0A);
const Color inputBackgroundColor = Color(0xFF23222F);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Colors.grey;
const Color iconColor = Colors.white;
const Gradient editIconGradient = LinearGradient(
  colors: [Colors.blueAccent, Colors.purpleAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Helper class for Bottom Navigation Bar items
class BottomBarIconLabel {
  BottomBarIconLabel({required this.assetName, required this.label});
  String assetName;
  String label;
}

class AvatarProfile extends ConsumerStatefulWidget {
  const AvatarProfile({super.key});

  @override
  ConsumerState<AvatarProfile> createState() => _AvatarProfile();
}

class _AvatarProfile extends ConsumerState<AvatarProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(chatProvider);
    var image =
        provider.character!.imageGallery
            .where((element) => element.selected == true)
            .first
            .url;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: primaryTextColor),
        title: Row(
          children: [
            SvgPicture.asset(Assets.svgs.logo, height: 50, width: 50),
            5.pw,
            Text(
              'Guftagu',
              style: const TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: CircleAvatar(
                  radius:80,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Name: ${provider.character!.name}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "Age: ${provider.character!.age}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "Gender: ${provider.character!.gender}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "Country: ${provider.character!.countryId}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "City: ${provider.character!.cityId}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "VoiceId: ${provider.character!.voiceId}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "PersonalityId: ${provider.character!.personalityId}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "RelationshipId: ${provider.character!.relationshipId}",
                style: context.appTextStyle.textBold,
              ),
              const SizedBox(height: 40),
              Text(
                "BehaviourIds: ${provider.character!.behaviourIds}",
                style: context.appTextStyle.textBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
