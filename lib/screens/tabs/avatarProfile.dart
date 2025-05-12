import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/configs/theme.dart';
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
        title: Builder(
          builder: (context) {
            double horizontalPadding =
                MediaQuery.of(context).size.width * 0.175;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Character Profile",
                style: TextStyle(
                  color: Color(0xFFC9C9C9),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            );
          },
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
                child: Container(
                  width: 164,
                  height: 164,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF00FFED), width: 1.96),
                    borderRadius: BorderRadius.circular(19.64),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                return Container(
                  width: screenWidth * 0.98,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23222F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAlignedRow("Name", provider.character!.name),
                      const SizedBox(height: 16),
                      _buildAlignedRow("Age", provider.character!.age.toString()),
                      const SizedBox(height: 16),
                      _buildAlignedRow("Gender", provider.character!.gender),
                      const SizedBox(height: 16),
                      _buildAlignedRow("Country", provider.character!.countryId),
                      const SizedBox(height: 16),
                      _buildAlignedRow("State", provider.character!.countryId),
                      const SizedBox(height: 16),
                      _buildAlignedRow("City", provider.character!.cityId),
                    ],
                  ),
                );
              },
            ),
          ),
              const SizedBox(height: 20),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    return Container(
                      width: screenWidth * 0.98,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23222F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildProfileField("Sexual Orientation", provider.character!.style),
                          const SizedBox(height: 16),
                          buildProfileField("Voice", provider.character!.voiceId),
                          const SizedBox(height: 16),
                          buildProfileField("Language", provider.character!.languageId),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    return Container(
                      width: screenWidth * 0.98,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23222F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildProfileField("What type of category fits your companion", provider.character!.creatorId),
                          const SizedBox(height: 16),
                          buildProfileField("What’s your companion’s relationship to you", provider.character!.relationshipId),
                          const SizedBox(height: 16),
                          buildProfileField("What's your companion's personality type", provider.character!.personalityId),
                          const SizedBox(height: 16),
                          buildProfileField(
                            "Which behaviour’s match your companion",
                            provider.character!.behaviourIds.join(", "),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    return Container(
                      width: screenWidth * 0.98,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23222F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildProfileField("Image description (if any)", provider.character!.refImageDescription ?? "N/A"),
                          const SizedBox(height: 16),
                          buildProfileField("Back Story if any (300 words)", provider.character!.refImageBackstory ?? "N/A"),
                          const SizedBox(height: 16),
                          buildProfileField("Prompts", provider.character!.prompt),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD3D3D3),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF333147),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: context.appTextStyle.textSemibold,
          ),
        ),
      ],
    );
  }


  Widget _buildAlignedRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD3D3D3),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(
            color: Color(0xFFD3D3D3),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: context.appTextStyle.textSemibold,
          ),
        ),
      ],
    );
  }

}
