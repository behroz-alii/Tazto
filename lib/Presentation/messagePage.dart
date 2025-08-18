import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderMessagesPage extends StatelessWidget {
  const OrderMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: demoOrderMessages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final message = demoOrderMessages[index];
          return OrderMessageCard(message: message);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Filter Messages'),
        children: [
          _buildFilterOption(context, 'All Orders'),
          _buildFilterOption(context, 'Active Orders'),
          _buildFilterOption(context, 'Past Orders'),
        ],
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String text) {
    return ListTile(
      title: Text(text),
      onTap: () => Navigator.pop(context),
    );
  }
}

class OrderMessageCard extends StatelessWidget {
  final OrderMessage message;

  const OrderMessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        backgroundImage: AssetImage(message.restaurantLogo),
      ),
      title: Text(
        message.restaurantName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order #${message.orderId}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            message.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            DateFormat('hh:mm a').format(message.time),
            style: TextStyle(
              color: message.isUnread ? Colors.orange : Colors.grey,
              fontSize: 12,
            ),
          ),
          if (message.isUnread)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderChatScreen(message: message),
        ),
      ),
    );
  }
}

class OrderChatScreen extends StatelessWidget {
  final OrderMessage message;

  const OrderChatScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.restaurantName),
            Text(
              'Order #${message.orderId}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: message.thread.length,
              itemBuilder: (context, index) {
                final msg = message.thread[index];
                return MessageBubble(
                  message: msg,
                  isCustomer: msg.senderType == SenderType.customer,
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.orange),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCustomer;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCustomer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCustomer ? Colors.orange[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.time),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
enum SenderType { restaurant, delivery, customer }

class ChatMessage {
  final String text;
  final DateTime time;
  final SenderType senderType;

  ChatMessage({
    required this.text,
    required this.senderType,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class OrderMessage {
  final String orderId;
  final String restaurantName;
  final String restaurantLogo;
  final String lastMessage;
  final DateTime time;
  final bool isUnread;
  final List<ChatMessage> thread;

  OrderMessage({
    required this.orderId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.lastMessage,
    required this.thread,
    DateTime? time,
    this.isUnread = false,
  }) : time = time ?? DateTime.now();
}

// Demo Data
final List<OrderMessage> demoOrderMessages = [
  OrderMessage(
    orderId: '789456',
    restaurantName: 'Pizza Hut',
    restaurantLogo: 'Assets/Pictures/PizzaHut.png',
    lastMessage: 'Your pizza is on the way!',
    isUnread: true,
    thread: [
      ChatMessage(
        text: 'Your order has been received',
        senderType: SenderType.restaurant,
        time: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ChatMessage(
        text: 'When will it arrive?',
        senderType: SenderType.customer,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        text: 'Your pizza is on the way!',
        senderType: SenderType.delivery,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
  ),
  OrderMessage(
    orderId: '123456',
    restaurantName: 'TacoBell',
    restaurantLogo: 'Assets/Pictures/TacoBell.png',
    lastMessage: 'Order delivered. Enjoy your meal!',
    thread: [
      ChatMessage(
        text: 'Your pizza will arrive in 20 mins',
        senderType: SenderType.delivery,
        time: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  ),
];