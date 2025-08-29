// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_is_empty

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import 'package:smaergym/core/controllers/course_controller.dart';
import 'package:smaergym/core/controllers/user_controller.dart';
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/core/models/chat_model.dart';
import 'package:smaergym/core/models/user_model.dart';
import 'package:smaergym/core/widgets/no_data_widget.dart';
import 'package:smaergym/screens/chat/AudioRecorder.dart';
import 'package:smaergym/screens/chat/chat_puple.dart';

import '../../core/controllers/chats_controller.dart';
import '../../core/widgets/chat_detail_page_app_bar.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatPage extends StatefulWidget {
  final ChatModel? chatModel;

  ChatPage({this.chatModel});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatPage> {
  TextEditingController message = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  ChatsController chatsController = Get.put(ChatsController());
  
  UserCoursesController userCoursesController = Get.put(UserCoursesController());

  UserController userController = Get.find();
  late String pathToAudio;
  var _timerText = "";
  bool showPlayer = false;
  String? audioPath;
  bool isRecoring = false;
  var recordTime = null;

// final _key = GlobalKey<ExpandableFabState>();
  final ImagePicker _picker = ImagePicker();

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  pickImage(int source) async {
    var uploadimage = await _picker.pickImage(
        source: source == 1 ? ImageSource.gallery : ImageSource.camera);

    if (uploadimage != null) {
      final dir = await path_provider.getTemporaryDirectory();
      final timeStamp = DateTime.now().millisecond;
      final targetPath = dir.absolute.path + "/temp$timeStamp.jpg";

      testCompressAndGetFile(File(uploadimage.path), targetPath).then((value) {
        if (widget.chatModel != null) {
          chatsController.addChat(
              widget.chatModel!.user,
              widget.chatModel!.user_name,
              widget.chatModel!.user_image,
              widget.chatModel!.user_phone,
              "image",
              widget.chatModel?.subscription,
              message: value!,
              imageType: p.extension(value.path));
        } else {
          UserModel user = Get.find<UserController>().user.value;
          chatsController.addChat(
              user.id,
              user.name,
              user.image,
              user.phone,
              "image",
              userCoursesController.currentCourse.value.data()["subscription"],
              message: value!,
              imageType: p.extension(value.path));
        }

        Get.back();
        Uint8List bytes = value.readAsBytesSync();
        String base64Image = base64Encode(bytes);
        var imageType = p.extension(value.path);
        imageType = imageType.replaceAll('.', '');
      });
    }
    setState(() {});
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 95, minWidth: 1024, minHeight: 1000);
    return result;
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'doc', 'zip', 'rar', 'tar'],
        type: FileType.custom);

    if (result != null) {
      File file = File(result.files.single.path!);
      var extention = file.uri.toString().split("/").last;
      Get.back();

      if (widget.chatModel != null) {
        chatsController.addChat(
            widget.chatModel!.user,
            widget.chatModel!.user_name,
            widget.chatModel!.user_image,
            widget.chatModel!.user_phone,
            "file",
            widget.chatModel?.subscription,
            message: file,
            fileName: extention);
      } else {
        UserModel user = Get.find<UserController>().user.value;
        chatsController.addChat(
            user.id,
            user.name,
            user.image,
            user.phone,
            "file",
            userCoursesController.currentCourse.value.data()["subscription"],
            message: file,
            fileName: extention);
      }
    } else {
      // User canceled the picker
    }
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    showPlayer = false;
    if (widget.chatModel != null) {
      chatsController.getMessages(widget.chatModel!.user!);
    } else {
      chatsController.getMessages(userController.user.value.id);
    }

    if (widget.chatModel != null && userController.user.value.admin == true) {
      chatsController.readMeesage(widget.chatModel!.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ToastContext().init(context);

    return WillPopScope(
      onWillPop: () async {
        // Get.delete<ChatsController>();
        chatsController.messages.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.chatModel != null
            ? ChatDetailPageAppBar(
                name: widget.chatModel!.user_name!,
                image: widget.chatModel!.user_image!,
                phone: widget.chatModel!.user_phone!,
                isAdmin: true,
              )
            : ChatDetailPageAppBar(
                name: "كابتن سامر",
                image: "",
                phone: "",
                isAdmin: false,
                isFile: true,
              ),
        body: userCoursesController.currentCourse.value == null &&
                userController.user.value.admin == false
            ? Container(
                alignment: Alignment.center,
                child: NoData(
                  title: "انت لست مشترك مع الكابتن",
                ),
              )
            : userCoursesController.currentCourse.value != null &&
                    userCoursesController.currentCourse.value
                            .data()["status"] !=
                        3 &&
                    userCoursesController.currentCourse.value
                            .data()["status"] !=
                        4 &&
                    userController.user.value.admin == false
                ? Container(
                    alignment: Alignment.center,
                    child: NoData(
                      title: "يجب ان يكون لديك كورس فعال",
                    ),
                  )
                : userCoursesController.currentCourse.value != null &&
                        userCoursesController.currentCourse.value
                                .data()["status"] ==
                            4 &&
                        userController.user.value.admin == false
                    ? Container(
                        alignment: Alignment.center,
                        child: NoData(
                          title:
                              "لقد انتهى اشتراكك يرجى تجديد الاشتراك وتمتع بكافة الخدمات",
                        ),
                      )
                    : KeyboardVisibilityBuilder(
                        builder: (context, visibil) {
                          if (visibil) {
                            Future.delayed(Duration(milliseconds: 100))
                                .then((value) {
                              //  scrollDown();
                            });
                          }
                          return Obx(() => GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Stack(
                                children: [
                                  if (chatsController.messages.length == 0)
                                    Container(
                                      height: MediaQuery.of(context).size.width,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                              "assets/json/message.json",
                                              width: 220.sp),
                                          Text(
                                            "لا يوجد رسائل",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(height: 0.1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (chatsController.messages.length > 0)
                                    ListView.builder(
                                      controller: _scrollController,
                                      reverse: true,
                                      itemCount:
                                          chatsController.messages.length,
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 80),
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var timestamp = chatsController.messages[index].date ?? 0; // Should be an int
var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

print(DateFormat('yyyy-MM-dd – HH:mm').format(date));
                                        print(chatsController.messages.length);
                                        print(chatsController.messages[index].date.toString());
                                        return ChatBubble(
                                          chatMessage:
                                              chatsController.messages[index],
                                        );
                                      },
                                    ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      constraints: new BoxConstraints(
                                        maxHeight: 120.0,
                                      ),
                                      padding: EdgeInsets.only(
                                          right: 0, bottom: 0, left: 0),
                                      //  alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.only(bottom: 0),

                                      width: double.infinity,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Obx(() => Container(
                                                    child: TextField(
                                                      controller: message,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      minLines: 1,
                                                      maxLines: 5,
                                                      onChanged: (v) {
                                                        setState(() {});
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: chatsController
                                                                .loadfile.value
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Lottie.asset(
                                                                    "assets/json/uplading.json",
                                                                    width: 10,
                                                                    height: 10),
                                                              )
                                                            : IconButton(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20,
                                                                        left:
                                                                            8),
                                                                onPressed: () {
                                                                  Get.bottomSheet(
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(
                                                                                20),
                                                                            topRight: Radius.circular(
                                                                                20)),
                                                                        color: Theme.of(context)
                                                                            .scaffoldBackgroundColor),
                                                                    height:
                                                                        140.h,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              3,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              color: Colors.grey),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                pickImage(1);
                                                                              },
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 60,
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(
                                                                                      CupertinoIcons.photo,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    height: 60,
                                                                                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(100)),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    "معرض",
                                                                                    style: Theme.of(context).textTheme.titleMedium,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                pickImage(2);
                                                                              },
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 60,
                                                                                    alignment: Alignment.center,
                                                                                    child: Icon(
                                                                                      CupertinoIcons.camera,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    height: 60,
                                                                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(100)),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    "كامرة",
                                                                                    style: Theme.of(context).textTheme.titleMedium,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ));
                                                                },
                                                                icon: Icon(
                                                                    CupertinoIcons
                                                                        .camera)),
                                                        hintText:
                                                            recordTime != null
                                                                ? recordTime
                                                                : "اكتب رسالتك",
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 20,
                                                                bottom: 20,
                                                                right: 60,
                                                                left: 60),
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade500),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 10),
                                      child: message.text.isEmpty
                                          ? userController.user.value.admin ==
                                                  true
                                              ? FloatingActionButton.small(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  onPressed: () {},
                                                  child: AudioRecorder(
                                                    onRecrod: (time) {
                                                      setState(() {
                                                        recordTime = time;
                                                      });
                                                    },
                                                    onStop: (path) {
                                                      recordTime = null;
                                                      if (kDebugMode)
                                                        print(
                                                            'Recorded file path: $path');
                                                      setState(() {
                                                        audioPath = path;
                                                        showPlayer = true;
                                                      });

                                                      if (widget.chatModel !=
                                                          null) {
                                                        chatsController.addChat(
                                                            widget.chatModel!
                                                                .user,
                                                            widget.chatModel!
                                                                .user_name,
                                                            widget.chatModel!
                                                                .user_image,
                                                            widget.chatModel!
                                                                .user_phone,
                                                            "voice",
                                                            widget.chatModel
                                                                ?.subscription,
                                                            message: path);
                                                      } else {
                                                        UserModel user = Get.find<
                                                                UserController>()
                                                            .user
                                                            .value;
                                                        chatsController.addChat(
                                                          user.id,
                                                          user.name,
                                                          user.image,
                                                          user.phone,
                                                          "voice",
                                                          userCoursesController
                                                                  .currentCourse
                                                                  .value
                                                                  .data()[
                                                              "subscription"],
                                                          message: path,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                )
                                              : Container()
                                          : FloatingActionButton.small(
                                              onPressed: () {
                                                if (message.text.isNotEmpty &&
                                                    message.text.trim().length >
                                                        0) {
                                                  if (widget.chatModel ==
                                                      null) {
                                                    UserModel user = Get.find<
                                                            UserController>()
                                                        .user
                                                        .value;
                                                    chatsController
                                                        .addChat(
                                                            user.id,
                                                            user.name,
                                                            user.image,
                                                            user.phone,
                                                            "text",
                                                            userCoursesController
                                                                    .currentCourse
                                                                    .value
                                                                    .data()[
                                                                "subscription"],
                                                            message:
                                                                message.text);
                                                  } else {
                                                    chatsController.addChat(
                                                        widget.chatModel!.user,
                                                        widget.chatModel!
                                                            .user_name,
                                                        widget.chatModel!
                                                            .user_image,
                                                        widget.chatModel!
                                                            .user_phone,
                                                        "text",
                                                        widget.chatModel
                                                            ?.subscription,
                                                        message: message.text);
                                                  }
                                                  message.clear();
                                                }
                                              },
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 0,
                                            ),
                                    ),
                                  )
                                ],
                              )));
                        },
                      ),
      ),
    );
  }
}
