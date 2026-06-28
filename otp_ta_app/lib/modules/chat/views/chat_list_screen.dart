import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class ChatListScreen extends GetView<ChatController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Get.find<AuthController>().currentUser.value?.uid ?? '';
    final isWeb = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Active Conversations',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: StreamBuilder<List<ChatRoomModel>>(
            stream: controller.watchUserRooms(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 72,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text('No Active Chats', style: AppTextStyles.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Your inbox is completely clear.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              final rooms = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                itemCount: rooms.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppDimensions.paddingM),
                itemBuilder: (context, index) {
                  final room = rooms[index];

                  // Identify the other participant
                  final otherUserId = room.participants.firstWhere(
                    (id) => id != currentUserId,
                    orElse: () => currentUserId,
                  );

                  return FadeInUp(
                    duration: const Duration(milliseconds: 300),
                    delay: Duration(milliseconds: index * 50),
                    child: _ChatRoomTile(room: room, otherUserId: otherUserId),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final String otherUserId;

  const _ChatRoomTile({required this.room, required this.otherUserId});

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!;
      }
    } catch (_) {}
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserDetails(),
      builder: (context, snapshot) {
        final userData = snapshot.data ?? {};
        final displayName =
            userData['displayName'] ?? userData['email'] ?? 'Unknown User';
        final role = userData['role'] ?? 'Patient';

        final bool isEmergency = room.hasEmergency;
        final timeString = DateFormat('h:mm a').format(room.lastMessageTime);

        return Card(
          color: AppColors.surfaceElevated,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            side: BorderSide(
              color: isEmergency ? AppColors.error : AppColors.glassBorder,
              width: isEmergency ? 1.5 : 1.0,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            onTap: () {
              Get.toNamed(
                '/chat-room',
                arguments: {
                  'roomId': room.roomId,
                  'otherUserId': otherUserId,
                  'otherUserName': displayName,
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isEmergency
                          ? AppColors.errorLight.withValues(alpha: 0.2)
                          : AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: isEmergency
                              ? AppColors.errorLight
                              : AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingL),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: isEmergency
                                      ? AppColors.errorLight
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              timeString,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isEmergency
                                    ? AppColors.errorLight
                                    : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceOverlay,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                role.toString().toUpperCase(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondaryLight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                room.lastMessage.isEmpty
                                    ? 'No messages yet'
                                    : room.lastMessage,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
