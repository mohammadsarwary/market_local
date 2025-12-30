import 'package:get/get.dart';
import 'data/mock_data.dart';

class ChatController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  List<String> get tabs => ChatMockData.tabs;

  List<ChatConversation> get allChats => ChatMockData.conversations;

  List<ChatConversation> get filteredChats {
    if (selectedTabIndex.value == 0) return allChats;
    final tabName = tabs[selectedTabIndex.value].toLowerCase();
    if (tabName == 'archived') {
      return allChats.where((chat) => chat.type == ChatType.archived).toList();
    }
    final type = tabName == 'buying' ? ChatType.buying : ChatType.selling;
    return allChats.where((chat) => chat.type == type).toList();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
