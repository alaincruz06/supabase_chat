import 'package:supabase_chat/data/models/chat_summary_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseProvider {
  Future<AuthResponse?> signIn(
      {required String username, required String password});
  Future<AuthResponse> signUp(
      {required String username,
      required String email,
      required String password});
  Future<void> signOut();
  Future<ProfileModel> getUser({required String userUuid});
  Stream<List<ProfileModel>>? getAvailableUsers({required String userUuid});
  Stream<List<ChatsMessagesModel>>? getMessagesStream({required int chatId});
  Future<ChatSummaryModel?>? existsChatAlready(
      {required List<String> usersIds});
  Future<void> createChat({required List<String> usersIds});
  Stream<List<ChatSummaryModel>?> getChatsStream(String myUserId);
  Future<void> sendMessage({required ChatsMessagesModel chatsMessagesModel});
}
