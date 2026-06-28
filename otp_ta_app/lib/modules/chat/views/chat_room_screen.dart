import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/chat_model.dart';
import '../controllers/chat_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ChatRoomScreen extends GetView<ChatController> {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String roomId = args['roomId'] ?? '';
    final String otherUserName = args['otherUserName'] ?? 'Chat';
    final currentUserId = Get.find<AuthController>().currentUser.value?.uid ?? '';
    final isWeb = ResponsiveHelper.isDesktop(context);

    final TextEditingController messageController = TextEditingController();
    final RxBool isSearching = false.obs;
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          if (isSearching.value) {
            return TextField(
              controller: searchController,
              autofocus: true,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search messages...',
                border: InputBorder.none,
                hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary),
              ),
              onChanged: (val) {
                controller.searchInRoom(roomId, val);
              },
            );
          }
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.15),
                radius: 18,
                child: Text(
                  otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryLight),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Text(
                  otherUserName,
                  style: AppTextStyles.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }),
        actions: [
          Obx(() {
            if (isSearching.value) {
              return IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  isSearching.value = false;
                  searchController.clear();
                  controller.searchResults.clear();
                },
              );
            }
            return IconButton(
              icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              onPressed: () => isSearching.value = true,
            );
          }),
          // Basic Emergency Button (To be expanded in step 9.5)
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            onPressed: () {
              // Stub for triggering emergency
              controller.triggerEmergency(roomId, []); 
            },
          ),
          const SizedBox(width: AppDimensions.paddingS),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (isSearching.value && searchController.text.isNotEmpty) {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }
                    if (controller.searchResults.isEmpty) {
                      return const Center(child: Text('No results found.', style: AppTextStyles.bodyLarge));
                    }
                    return ListView.builder(
                      reverse: true, // show from bottom
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final msg = controller.searchResults[controller.searchResults.length - 1 - index];
                        return _MessageBubble(message: msg, isMe: msg.senderId == currentUserId);
                      },
                    );
                  }

                  return StreamBuilder<List<MessageModel>>(
                    stream: controller.watchMessages(roomId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Say hi to start the conversation!',
                            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary),
                          ),
                        );
                      }

                      final messages = snapshot.data!.reversed.toList(); // Reverse for ListView(reverse: true)

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == currentUserId;

                          // Automatically mark as read if it's not mine and status is not read
                          if (!isMe && msg.status != MessageStatus.read) {
                            controller.markAsRead(roomId, msg.messageId);
                          }

                          // Animate only the newest messages at the top of the reversed list
                          if (index == 0) {
                            return SlideInUp(
                              duration: const Duration(milliseconds: 300),
                              child: _MessageBubble(message: msg, isMe: isMe),
                            );
                          }
                          return _MessageBubble(message: msg, isMe: isMe);
                        },
                      );
                    },
                  );
                }),
              ),
              _buildMessageInput(roomId, messageController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(String roomId, TextEditingController messageController) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary),
              onPressed: () {
                // Future attachment logic
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: TextField(
                  controller: messageController,
                  style: AppTextStyles.bodyLarge,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () {
                  if (messageController.text.trim().isNotEmpty) {
                    controller.sendMessage(roomId, messageController.text);
                    messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surfaceOverlay,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimensions.radiusL),
            topRight: const Radius.circular(AppDimensions.radiusL),
            bottomLeft: Radius.circular(isMe ? AppDimensions.radiusL : 4),
            bottomRight: Radius.circular(isMe ? 4 : AppDimensions.radiusL),
          ),
          border: isMe ? null : Border.all(color: AppColors.glassBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeString,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isMe ? Colors.white70 : AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  _buildStatusIcon(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color iconColor;

    switch (message.status) {
      case MessageStatus.sent:
        iconData = Icons.check_rounded;
        iconColor = Colors.white70;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all_rounded;
        iconColor = Colors.white70;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all_rounded;
        iconColor = Colors.blueAccent.shade100; // Distinctive read color
        break;
    }

    return Icon(iconData, size: 14, color: iconColor);
  }
}
