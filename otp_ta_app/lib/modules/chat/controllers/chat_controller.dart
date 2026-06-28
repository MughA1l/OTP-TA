import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final IChatRepository _chatRepository;

  ChatController({required IChatRepository chatRepository}) : _chatRepository = chatRepository;

  final RxBool isLoading = false.obs;
  final RxBool isEmergencyActive = false.obs;
  final RxList<MessageModel> searchResults = <MessageModel>[].obs;

  /// Ensures a chat room is established between patient and doctor.
  /// Room ID format: patientId_doctorId
  Future<String?> startChat(String patientId, String doctorId) async {
    isLoading.value = true;
    final roomId = '${patientId}_$doctorId';
    final result = await _chatRepository.createRoomIfNotExists(roomId, [patientId, doctorId]);
    isLoading.value = false;
    
    return result.fold(
      (failure) {
        SnackbarHelper.showError('Error', failure.message);
        return null;
      },
      (_) => roomId,
    );
  }

  /// Sends a new text/file message to the specified room.
  Future<void> sendMessage(String roomId, String text, {List<String> sharedFiles = const []}) async {
    final currentUserId = Get.find<AuthController>().currentUser.value?.uid ?? '';
    if (currentUserId.isEmpty) return;

    final msg = MessageModel(
      messageId: '',
      senderId: currentUserId,
      text: text.trim(),
      status: MessageStatus.sent,
      timestamp: DateTime.now(),
      sharedFiles: sharedFiles,
    );

    final result = await _chatRepository.sendMessage(roomId, msg);
    result.fold(
      (failure) => SnackbarHelper.showError('Delivery Failed', failure.message),
      (_) {
        // Message sent successfully
      },
    );
  }

  /// Streams real-time messages for the chat room UI.
  Stream<List<MessageModel>> watchMessages(String roomId) {
    return _chatRepository.watchMessages(roomId);
  }

  /// Streams real-time active chat rooms for the current user's inbox list.
  Stream<List<ChatRoomModel>> watchUserRooms() {
    final currentUserId = Get.find<AuthController>().currentUser.value?.uid ?? '';
    return _chatRepository.watchUserRooms(currentUserId);
  }

  /// Marks a specific message as read (SRS-90).
  Future<void> markAsRead(String roomId, String messageId) async {
    await _chatRepository.markAsRead(roomId, messageId);
  }

  /// Executes local search inside a specific chat room.
  Future<void> searchInRoom(String roomId, String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    
    isLoading.value = true;
    final result = await _chatRepository.searchMessages(roomId, query.trim());
    result.fold(
      (failure) => SnackbarHelper.showError('Search Failed', failure.message),
      (messages) {
        searchResults.value = messages;
      },
    );
    isLoading.value = false;
  }

  /// Triggers the emergency alarm and notifies the entire surgical team via FCM (SRS-92).
  Future<void> triggerEmergency(String roomId, List<String> surgicalTeamTokens) async {
    isEmergencyActive.value = true;
    SnackbarHelper.showSuccess('Emergency Alert', 'Dispatching emergency signal to surgical team...', isDismissible: false);
    
    final result = await _chatRepository.triggerEmergencyAlert(roomId, surgicalTeamTokens);
    result.fold(
      (failure) {
        SnackbarHelper.showError('Emergency Alert Failed', failure.message);
        isEmergencyActive.value = false;
      },
      (_) {
        SnackbarHelper.showSuccess('Signal Dispatched', 'All relevant personnel have been notified.');
        isEmergencyActive.value = false; // Reset after dispatch
      },
    );
  }
}
