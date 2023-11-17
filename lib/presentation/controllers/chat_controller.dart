import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
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
    // Dispose controllers
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
          ChannelFilter(event: '*', schema: 'public', table: 'chats_messages'),
          (payload, [ref]) {
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
    // Pick images.
    final List<XFile> images = await imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        compressAndSendImage(image);
      }
    }
  }

  Future<void> takePhotos() async {
    // Capture an image.
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      compressAndSendImage(image);
    }
  }

  Future<void> compressAndSendImage(XFile image) async {
    try {
      File imageFile = File(image.path);
      //Create temporary file from XFile
      Directory dir = await getApplicationDocumentsDirectory();
      final tempImagePath = p.join(dir.path, 'temp-image.jpg');

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
        submitMessage(
            messageToSend: base64Image, messageType: MessageType.photo);
      }
    } catch (e) {
      debugPrint('Error compressAndSendImage: $e');
    }
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

  void submitMessage(
      {required String messageToSend, required MessageType messageType}) async {
    if (messageToSend.isEmpty) {
      return;
    }
    try {
      await supabaseProvider.sendMessage(
          chatsMessagesModel: ChatsMessagesModel(
              chatId: chatSummaryModel.chatId,
              userId: userController.profileDomain.value.id,
              userUuid: userController.profileDomain.value.userId,
              message: messageToSend,
              messageType: messageType.name));
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
