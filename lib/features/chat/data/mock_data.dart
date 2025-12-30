/// Mock data for Chat feature
class ChatMockData {
  ChatMockData._();

  static const List<String> tabs = ['All', 'Buying', 'Selling', 'Archived'];

  static final List<ChatConversation> conversations = [
    ChatConversation(
      id: '1',
      userName: 'Alex D.',
      itemName: 'Vintage Bike',
      lastMessage: 'Is this still available? I can pick it up today.',
      time: '10:42 AM',
      unreadCount: 2,
      isOnline: true,
      userAvatar: 'https://i.pravatar.cc/150?u=1',
      itemImage: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.selling,
    ),
    ChatConversation(
      id: '2',
      userName: 'Sarah M.',
      itemName: 'West Elm Sofa',
      lastMessage: 'Great, see you at 5 PM then!',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
      userAvatar: 'https://i.pravatar.cc/150?u=2',
      itemImage: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.buying,
    ),
    ChatConversation(
      id: '3',
      userName: 'Mike T.',
      itemName: 'iPhone 13 Pro',
      lastMessage: 'Would you take \$600 for it?',
      time: 'Tue',
      unreadCount: 0,
      isRead: true,
      isOnline: false,
      userAvatar: 'https://i.pravatar.cc/150?u=3',
      itemImage: 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.selling,
    ),
    ChatConversation(
      id: '4',
      userName: 'Julianne',
      itemName: 'Sony A7III',
      lastMessage: 'Can you send more photos of the lens?',
      time: 'Mon',
      unreadCount: 1,
      isOnline: false,
      userAvatar: 'https://i.pravatar.cc/150?u=4',
      itemImage: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.buying,
    ),
    ChatConversation(
      id: '5',
      userName: 'David K.',
      itemName: 'Coffee Table',
      lastMessage: 'Address is 123 Main St. When can you come?',
      time: 'Last Week',
      unreadCount: 0,
      isRead: false,
      isOnline: false,
      userAvatar: 'https://i.pravatar.cc/150?u=5',
      itemImage: 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.buying,
    ),
    ChatConversation(
      id: '6',
      userName: 'Emily R.',
      itemName: 'Plants Bundle',
      lastMessage: 'Thanks! Enjoy your new plants 🌱',
      time: '2 Weeks ago',
      unreadCount: 0,
      isOnline: true,
      userAvatar: 'https://i.pravatar.cc/150?u=6',
      itemImage: 'https://images.unsplash.com/photo-1459156212016-c812468e2115?auto=format&fit=crop&q=80&w=150&h=150',
      type: ChatType.selling,
    ),
  ];
}

/// Chat conversation model
class ChatConversation {
  final String id;
  final String userName;
  final String itemName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isRead;
  final String userAvatar;
  final String itemImage;
  final ChatType type;

  const ChatConversation({
    required this.id,
    required this.userName,
    required this.itemName,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isRead = false,
    required this.userAvatar,
    required this.itemImage,
    required this.type,
  });
}

/// Chat type enum
enum ChatType {
  buying,
  selling,
  archived,
}
