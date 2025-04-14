import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/call_provider.gen.dart';

@riverpod
class Call extends _$Call {
  @override
  CallState build() {
    return CallState();
  }

  void toggleSpeaker() {
    state = state._updateWith(isSpeakerOn: !state.isSpeakerOn);
  }
}

class CallState {
  CallState({this.isSpeakerOn = false});

  final bool isSpeakerOn;

  // ignore: unused_element
  CallState _updateWith({bool? isSpeakerOn}) {
    return CallState(isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn);
  }
}
