import 'package:flutter/foundation.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_summary_model.dart';
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
          .neq('user_id', '{$userUuid}')
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
      return ChatsMessagesModel.watchMessages(chatId);
    } catch (e) {
      debugPrint('Error on getChatsStream: $e');
      return const Stream.empty();
    }
  }

  @override
  Future<ChatSummaryModel?>? existsChatAlready(
      {required List<String> usersIds}) {
    try {
      return _supabaseClient
          .from('chat_summary')
          .select()
          .contains('user_ids', usersIds)
          .containedBy('user_ids', usersIds)
          .maybeSingle()
          .then((event) {
        if (event != null) {
          final chatSummaryMap = event as Map<String, dynamic>;
          return ChatSummaryModel.fromMap(chatSummaryMap);
        } else {
          return null;
        }
      });
    } catch (e) {
      debugPrint('Error on existsChatAlready: $e');
      return null;
    }
  }

  @override
  Stream<List<ChatSummaryModel>?> getChatsStream(String myUserId) {
    try {
      //commented because sql query not returning all rows
      // return ChatSummaryModel.watchChats(myUserId);

      return _supabaseClient
          .from('chat_summary')
          .select()
          .contains('user_ids', '{$myUserId}')
          .order('updated_at')
          .asStream()
          .map((event) {
        return event
            .map((record) {
              final recordAsMap = record as Map<String, dynamic>;
              return ChatSummaryModel.fromMap(recordAsMap);
            })
            .toList()
            .cast<ChatSummaryModel>();
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
      await ChatsMessagesModel.createMessage(chatsMessagesModel);
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

          for (var userId in usersIds) {
            await _supabaseClient.from('chats_users').insert(
              {'chat_id': chat['id'], 'user_id': userId},
            );
          }
        }
      });
    } catch (e) {
      debugPrint('Error on sendMessage: $e');
    }
  }
}
