import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/chat_provider.gen.dart';

@riverpod
class Chat extends _$Chat {
  @override
  ChatState build() {
    final initialState = ChatState(
      messageController: TextEditingController(),
      hasMessage: false,
    );

    // Add listener
    initialState.messageController.addListener(_handleTextChange);

    // Dispose controller when provider is disposed
    ref.onDispose(() {
      initialState.messageController.removeListener(_handleTextChange);
      initialState.messageController.dispose();
    });

    return initialState;
  }

  void _handleTextChange() {
    final hasText = state.messageController.text.trim().isNotEmpty;
    if (hasText != state.hasMessage) {
      state = state._updateWith(hasMessage: hasText);
    }
  }
}

class ChatState {
  ChatState({required this.messageController, this.hasMessage = false});
  final bool hasMessage;
  final TextEditingController messageController;

  // ignore: unused_element
  ChatState _updateWith({
    bool? hasMessage,
    TextEditingController? messageController,
  }) {
    return ChatState(
      hasMessage: hasMessage ?? this.hasMessage,
      messageController: messageController ?? this.messageController,
    );
  }
}
