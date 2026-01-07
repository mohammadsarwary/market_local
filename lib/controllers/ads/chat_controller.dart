import 'package:get/get.dart';
import '../../utils/haptic_feedback.dart';
import 'chat_mock_data.dart';

/// Controller for managing chat functionality and conversations
/// 
/// This controller handles the chat screen state including:
/// - Tab selection (All, Buying, Selling, Archived)
/// - Conversation filtering based on selected tab
/// - Chat conversation management
class ChatController extends GetxController {
  /// Loading state for chat operations
  final RxBool isLoading = false.obs;

  /// Error state for chat operations
  final RxBool hasError = false.obs;

  /// Error message to display
  final RxString errorMessage = ''.obs;

  /// Currently selected tab index
  /// 
  /// Defaults to 0 (All chats). Use [changeTab] to update this value.
  final RxInt selectedTabIndex = 0.obs;

  /// List of available tab names
  /// 
  /// Returns mock data from [ChatMockData.tabs].
  List<String> get tabs => ChatMockData.tabs;

  /// List of all chat conversations
  /// 
  /// Returns mock data from [ChatMockData.conversations].
  List<ChatConversation> get allChats => ChatMockData.conversations;

  /// Filtered list of conversations based on selected tab
  /// 
  /// Returns conversations filtered by the currently selected tab.
  /// If "All" is selected, returns all conversations.
  /// Otherwise filters by chat type (buying, selling, or archived).
  /// 
  /// Returns:
  /// A list of [ChatConversation] objects matching the selected tab filter
  List<ChatConversation> get filteredChats {
    if (selectedTabIndex.value == 0) return allChats;
    final tabName = tabs[selectedTabIndex.value].toLowerCase();
    if (tabName == 'archived') {
      return allChats.where((chat) => chat.type == ChatType.archived).toList();
    }
    final type = tabName == 'buying' ? ChatType.buying : ChatType.selling;
    return allChats.where((chat) => chat.type == type).toList();
  }

  /// Changes the selected tab index
  /// 
  /// Updates the [selectedTabIndex] to the provided [index].
  /// This will automatically filter the conversations based on the new tab.
  /// 
  /// Parameters:
  /// - [index] The index of the tab to select from [tabs]
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  /// Loads chat conversations
  /// 
  /// Simulates loading chat data with loading and error states.
  /// In a real app, this would fetch conversations from an API.
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would fetch conversations from an API
      await HapticFeedback.success();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load conversations. Please try again.';
      await HapticFeedback.error();
    } finally {
      isLoading.value = false;
    }
  }

  /// Retries loading conversations
  /// 
  /// Clears error state and loads conversations again.
  Future<void> retryLoadConversations() async {
    await loadConversations();
  }
}
