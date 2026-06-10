import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final Map<String, dynamic> args;

  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isFocused = false;

  final List<Map<String, dynamic>> dummyMessages = [
    {"text": "Hey! How are you?", "isSender": false},
    {"text": "I'm good bro, what about you?", "isSender": true},
    {"text": "I'm also fine 👍", "isSender": false},
  ];

  @override
  void initState() {
    super.initState();

    args = Get.arguments ?? {};

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Widget buildInputField() {
    return TextField(
      controller: messageController,
      focusNode: focusNode,
      onTap: () {
        setState(() {});
      },
      onSubmitted: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: "Type a message...",
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (messageController.text.trim().isEmpty) return;

            setState(() {
              dummyMessages.add({
                "text": messageController.text.trim(),
                "isSender": true,
              });
            });

            messageController.clear();
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = args['name'] ?? 'Unknown';
    final image = args['image'] ?? '';
    final status = args['status']?.toString() ?? 'offline';

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
          ),
          title: Text(name),
          subtitle: Text(status),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(AppIcons.audioCall)),
          IconButton(onPressed: () {}, icon: const Icon(AppIcons.videoCall)),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: dummyMessages.length,
              itemBuilder: (context, index) {
                final msg = dummyMessages[index];

                return BubbleSpecialThree(
                  text: msg['text'],
                  isSender: msg['isSender'],
                  color: msg['isSender']
                      ? IGColors.blue
                      : IGColors.gray.withValues(alpha: 0.2),
                );
              },
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: buildInputField()),
        ],
      ),
    );
  }
}
