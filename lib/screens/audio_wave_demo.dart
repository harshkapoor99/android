import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/audio_player.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class AudioWaveDemo extends ConsumerWidget {
  const AudioWaveDemo({super.key});

  get itemCount => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterData = ref.watch(masterDataProvider);
    if (masterData.voices.isEmpty) {
      return const Text("No Voices found");
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Audio List')),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.colorExt.border,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListView.separated(
            itemCount: masterData.voices.length,
            itemBuilder: (context, index) {
              return AudioPlayerWidget(
                audio: masterData.voices[index],
                isNetworkUrl: true,
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
