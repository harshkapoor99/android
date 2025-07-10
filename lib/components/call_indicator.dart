import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/timer_widget.dart';
import 'package:guftagu_mobile/providers/call_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class CallIndicator extends ConsumerWidget {
  const CallIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var callStartTime = ref.watch(
      callProvider.select((value) => value.callStartTime),
    );
    var name = ref.watch(callProvider.select((value) => value.character?.name));
    if (callStartTime != null) {
      return GestureDetector(
        onTap: () => context.nav.pushNamed(Routes.call),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: context.colorExt.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                "Ongoing call with $name",
                style: context.appTextStyle.textSmall,
              ),

              Consumer(
                builder: (context, ref, child) {
                  return TimerWidget(startTime: callStartTime);
                },
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
