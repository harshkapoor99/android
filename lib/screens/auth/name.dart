import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/bluring_image_cluster.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _focusNodes = [FocusNode()];

  void updateName() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(authProvider.notifier).updateName().then((value) {
      if (value.isSuccess) {
        context.nav.pushNamed(Routes.interest);
      } else {
        AppConstants.showSnackbar(message: value.message, isSuccess: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Assets.images.bgGrad.image(width: double.infinity),
            BluringImageCluster(focusNodes: _focusNodes),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Your Name',
                      style: AppTextStyle(context).title,
                    ),
                  ),
                  50.ph,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Name", style: AppTextStyle(context).labelText),
                  ),
                  10.ph,
                  TextInputWidget(
                    controller: provider.nameController,
                    focusNode: _focusNodes[0],
                    textCapitalization: TextCapitalization.words,
                  ),
                  30.ph,
                  GradientButton(
                    title: "Continue",
                    showLoading: ref.read(authProvider).isLoading,
                    onTap: () => updateName(),
                  ),
                  200.ph,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
