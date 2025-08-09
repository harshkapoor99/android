import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class BenefitRow extends StatelessWidget {
  final String text;
  const BenefitRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.icons.tablerHandFingerRight),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.appTextStyle.textSemibold.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
