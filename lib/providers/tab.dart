import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/tab.gen.dart';

//
@Riverpod(keepAlive: true)
class IsHomeVisited extends _$IsHomeVisited {
  @override
  bool build() {
    return ref.read(hiveServiceProvider.notifier).getHasStartedChat();
  }
}

@riverpod
class TabIndex extends _$TabIndex {
  @override
  int build() {
    return 0;
  }

  void changeTab(int index) {
    state = index;
    if (index == 0) {
      ref.read(chatProvider.notifier).fetchChatList();
    }
  }
}
