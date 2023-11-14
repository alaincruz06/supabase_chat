import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_chat/core/constants.dart';
import 'package:supabase_chat/core/extensions.dart';
import 'package:supabase_chat/core/function_utils.dart';
import 'package:supabase_chat/data/datasources/providers/supabase_provider.dart';
import 'package:supabase_chat/data/models/chat_summary_model.dart';
import 'package:supabase_chat/data/models/chats_messages.dart';
import 'package:supabase_chat/data/models/profile_model.dart';
import 'package:supabase_chat/presentation/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  ChatController({
    required this.supabaseProvider,
    required this.supabaseClient,
    required this.userController,
  });
  //#region Variables

  final UserController userController;
  final SupabaseProvider supabaseProvider;
  final SupabaseClient supabaseClient;
  late RealtimeChannel realtimeChannel;
  StreamSubscription<List<ChatsMessagesModel>>? chatMessagesSubscription;
  RxList<ChatsMessagesModel> messages = <ChatsMessagesModel>[].obs;
  RxString activeUserId = ''.obs;
  RxDouble maxExtent = 0.0.obs;

  //image imagePicker
  final ImagePicker imagePicker = ImagePicker();
  final ScrollController messagesScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  //late vars
  late ChatSummaryModel chatSummaryModel;

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    activeUserId.value = userController.profileDomain.value.userId;
    chatSummaryModel = Get.arguments['chatSummmary'] as ChatSummaryModel;
    await getMessages();

    // Add listener to the list
    messages.listen((p0) {
      goToBottom();
    });
  }

  @override
  void dispose() {
    chatMessagesSubscription?.cancel();
    messagesScrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  //#endregion

  //#region Functions

  Future<void> getMessages() async {
    try {
      realtimeChannel = supabaseClient.channel('public:chats_messages').on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
              event: 'INSERT',
              schema: 'public',
              table: 'chats_messages'), (payload, [ref]) {
        loadMessagesStream();
      });
      realtimeChannel.subscribe();
      loadMessagesStream();
    } catch (e) {
      debugPrint('Error on getMessages: $e');
    }
  }

  void loadMessagesStream() {
    try {
      chatMessagesSubscription = supabaseProvider
          .getMessagesStream(chatId: chatSummaryModel.chatId)
          ?.listen((chatsData) {
        messages.value = chatsData.obs;
      });
    } catch (e) {
      debugPrint('Error on loadMessagesStream: $e');
    }
  }

  Future<ProfileModel> getUser(ChatsMessagesModel chat) async {
    return await supabaseProvider.getUser(userUuid: chat.userUuid);
  }

  Future<void> pickPhotos() async {
    try {
      // Pick an image.
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = File(image.path);
        //Create temporary file from XFile
        Directory dir = await getApplicationDocumentsDirectory();
        final tempImagePath = join(dir.path, 'temp-image.jpg');

        //Compress image from file and return XFile?
        XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
          imageFile.absolute.path,
          tempImagePath,
          quality: 88,
          minWidth: 1280,
          minHeight: 720,
        );
        if (compressedImage != null) {
          //Encode image to base64
          String base64Image = await FunctionUtils.base64encodedImageFromPath(
              compressedImage.path);
          await supabaseProvider.sendMessage(
              chatsMessagesModel: ChatsMessagesModel(
                  chatId: chatSummaryModel.chatId,
                  userId: userController.profileDomain.value.id,
                  userUuid: userController.profileDomain.value.userId,
                  message: base64Image,
                  messageType: MessageType.photo.name));
          textController.clear();
          //Delete temporary file
          // File(tempImagePath).delete();
          await getMessages();
        }
      }
    } catch (e) {
      debugPrint('Error pickPhotos: $e');
    }
/* // Capture a photo.
    final XFile? photo =
        await imagePicker.pickImage(source: ImageSource.camera);
// Pick a video.
    final XFile? galleryVideo =
        await imagePicker.pickVideo(source: ImageSource.gallery);
// Capture a video.
    final XFile? cameraVideo =
        await imagePicker.pickVideo(source: ImageSource.camera);
// Pick multiple images.
    final List<XFile> images = await imagePicker.pickMultiImage();
// Pick singe image or video.
    final XFile? media = await imagePicker.pickMedia();
// Pick multiple images and videos.
    final List<XFile> medias = await imagePicker.pickMultipleMedia(); */
  }

  void goToBottom() {
    if (messagesScrollController.hasClients) {
      messagesScrollController.animateTo(
        maxExtent.value,
        duration: const Duration(microseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void submitMessage() async {
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      //TODO differents messageTypes
      await supabaseProvider.sendMessage(
          chatsMessagesModel: ChatsMessagesModel(
              chatId: chatSummaryModel.chatId,
              userId: userController.profileDomain.value.id,
              userUuid: userController.profileDomain.value.userId,
              message: text,
              messageType: MessageType.text.name));
      textController.clear();
      await getMessages();
    } on PostgrestException catch (error) {
      Get.context!.showErrorSnackBar(message: error.message);
    } catch (_) {
      Get.context!.showErrorSnackBar(message: 'app.unexpectedErrorMessage'.tr);
    }
  }

  //#endregion
}
