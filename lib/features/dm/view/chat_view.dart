import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/dm/controller/dm_controller.dart';
import 'package:instagram/routes/app_routes.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final Map<String, dynamic> args;

  final TextEditingController messageController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  final DmController chatController = Get.put(DmController());
  final ScrollController scrollController = ScrollController();

  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    args = Get.arguments ?? {};

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });

      if (focusNode.hasFocus) {
        scrollToBottom();
      }
    });
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!scrollController.hasClients) return;

        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    super.dispose();
    scrollController.dispose();
  }

  Widget buildInputField(String receiverId) {
    return TextField(
      controller: messageController,
      focusNode: focusNode,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) async {
        await sendMessage(receiverId);
      },
      decoration: InputDecoration(
        hintText: "Type a message...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            await sendMessage(receiverId);
          },
        ),
      ),
    );
  }

  Future<void> sendMessage(String receiverId) async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    await chatController.sendMessage(receiverId: receiverId, message: text);

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final name = args['name'] ?? 'Unknown User';
    final image = args['image'] ?? '';
    final status = args['status']?.toString() ?? 'offline';
    final userId = args['userId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: ListTile(
          onTap: () {
            Get.toNamed(AppRoutes.publicProfile, arguments: userId);
          },
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
            child: image.isEmpty ? const Icon(Icons.person) : null,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: chatController.getMessages(userId),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }
                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });

                return ListView.builder(
                  controller: scrollController,

                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;

                    final currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;

                    final bool isSender = data['senderId'] == currentUserId;

                    return BubbleSpecialThree(
                      text: data['message'] ?? '',
                      isSender: isSender,
                      color: isSender
                          ? IGColors.blue
                          : IGColors.gray.withValues(alpha: 0.2),
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: isSender ? IGColors.bgLight : IGColors.bgDark,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20.h),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: buildInputField(userId),
            ),
          ),
        ],
      ),
    );
  }
}
