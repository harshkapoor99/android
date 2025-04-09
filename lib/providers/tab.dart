import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/tab.gen.dart';

//
@Riverpod(keepAlive: true)
class IsHomeVisited extends _$IsHomeVisited {
  @override
  bool build() {
    return false;
  }

  void setHomeViewed() {
    state = true;
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
  }
}
