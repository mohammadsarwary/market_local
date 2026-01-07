/// Enum for chat type
enum ChatType {
  buying,
  selling,
  archived,
}

/// Model for chat conversation
class ChatConversation {
  final String id;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final ChatType type;
  final bool isOnline;
  final String itemName;
  final String itemImage;
  final bool isRead;

  ChatConversation({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.type,
    this.isOnline = false,
    this.itemName = '',
    this.itemImage = '',
    this.isRead = true,
  });
  
  String get time => _formatTime(lastMessageTime);
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

/// Mock data for chat functionality
class ChatMockData {
  static const List<String> mockMessages = [
    'Is this still available?',
    'Yes, it is!',
    'Can you send more photos?',
    'Sure, I will send them shortly.',
  ];
  
  static const List<String> mockUsers = [
    'John Doe',
    'Jane Smith',
    'Bob Wilson',
  ];
  
  static const List<String> tabs = ['All', 'Buying', 'Selling'];
  
  static final List<ChatConversation> conversations = [
    ChatConversation(
      id: '1',
      userName: 'John Doe',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      lastMessage: 'Is this still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      type: ChatType.buying,
      isOnline: true,
    ),
    ChatConversation(
      id: '2',
      userName: 'Jane Smith',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      lastMessage: 'Yes, it is!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      type: ChatType.selling,
      isOnline: false,
    ),
    ChatConversation(
      id: '3',
      userName: 'Bob Wilson',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      lastMessage: 'Can you send more photos?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      type: ChatType.archived,
      isOnline: false,
    ),
  ];
}
