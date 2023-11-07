import 'package:flutter/foundation.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_messages_info_view_model.dart';
import 'package:supabase_chat/data/models/chat_summary_view_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/data/models/chats_model.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProviderImpl extends SupabaseProvider {
  SupabaseProviderImpl({
    SupabaseClient? supabase,
  }) : _supabaseClient = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabaseClient;

  @override
  Future<AuthResponse?> signIn(
      {required String username, required String password}) async {
    try {
      return await _supabaseClient.auth.signInWithPassword(
        email: username,
        password: password,
      );
    } catch (e) {
      debugPrint('Error on signIn: $e');
      return null;
    }
  }

  @override
  Future<AuthResponse> signUp(
      {required String username,
      required String email,
      required String password}) async {
    return await _supabaseClient.auth
        .signUp(email: email, password: password, data: {'username': username});
  }

  @override
  Future<ProfileModel> getUser({required String userUuid}) async {
    final Map<String, dynamic> response = await _supabaseClient
        .from('profiles')
        .select()
        .eq('user_id', userUuid)
        .single();
    return ProfileModel.fromMap(response);
  }

  @override
  Stream<List<ProfileModel>>? getAvailableUsers({required String userUuid}) {
    try {
      return _supabaseClient
          .from('profiles')
          .select()
          .neq('user_ids', '{$userUuid}')
          .asStream()
          .map((event) {
        return event
            .map((record) {
              final recordAsMap = record as Map<String, dynamic>;
              return ProfileModel.fromMap(recordAsMap);
            })
            .toList()
            .cast<ProfileModel>();
      });
    } catch (e) {
      debugPrint('Error on getAvailableUsers: $e');
      return const Stream.empty();
    }
  }

  @override
  Stream<List<ChatsMessagesModel>>? getMessagesStream({required int chatId}) {
    try {
      return _supabaseClient
          .from('chats_messages')
          .select()
          .eq('chat_id', chatId)
          .asStream()
          .map((event) {
        return event
            .map((record) {
              final recordAsMap = record as Map<String, dynamic>;
              return ChatsMessagesModel.fromMap(recordAsMap);
            })
            .toList()
            .cast<ChatsMessagesModel>();
      });
    } catch (e) {
      debugPrint('Error on getChatsStream: $e');
      return const Stream.empty();
    }
  }

  @override
  Future<ChatSummaryViewModel?> existsChatAlready(
      {required List<String> usersIds}) {
    return _supabaseClient
        .from('chat_summary_view')
        .select()
        .eq('usernames', usersIds)
        .maybeSingle()
        .then((event) {
      if (event.isNotEmpty) {
        final chatSummaryMap = event as Map<String, dynamic>;
        return ChatSummaryViewModel.fromMap(chatSummaryMap);
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<ChatSummaryViewModel>?> getChatsStream(String myUserId) {
    try {
      return _supabaseClient
          .from('chat_summary_view')
          .select()
          .contains('user_ids', '{$myUserId}')
          .asStream()
          .map((event) {
        return event
            .map((record) {
              final recordAsMap = record as Map<String, dynamic>;
              return ChatSummaryViewModel.fromMap(recordAsMap);
            })
            .toList()
            .cast<ChatSummaryViewModel>();
      });
    } catch (e) {
      debugPrint('Error on getChatsStream: $e');
      return const Stream.empty();
    }
  }

  @override
  Future<void> sendMessage(
      {required ChatsMessagesModel chatsMessagesModel}) async {
    try {
      await _supabaseClient
          .from('chats_messages')
          .insert(chatsMessagesModel.toJson());
    } catch (e) {
      debugPrint('Error on sendMessage: $e');
    }
  }

  @override
  Future<void> createChat({required List<String> usersIds}) async {
    try {
      var emptyChat = ChatsModel(
        lastMessage: '',
        messageType: '',
      );
      await _supabaseClient
          .from('chats')
          .insert(emptyChat.toJson())
          .select()
          .single()
          .then((event) async {
        if (event.isNotEmpty) {
          final chat = event as Map<String, dynamic>;

          await _supabaseClient.from('chats_users').insert(usersIds.map((e) => [
                {'chat_id': chat['id'], 'user_id': e},
              ]));
        }
      });
    } catch (e) {
      debugPrint('Error on sendMessage: $e');
    }
  }
}