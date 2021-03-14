import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/texts.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';

class CommentController extends GetxController with WidgetsBindingObserver {
  final int illustId;
  final commentList = Rx<List<Comment>>();
  final currentKeyboardHeight = Rx<double>(0.0);
  final memeBoxHeight = Rx<double>(
      picBox.get('keyboardHeight') != 0 ? picBox.get('keyboardHeight') : 250);
  final memeMap = Rx<Map>();
  final isMemeMode = Rx<bool>(false);
  final hintText = Rx<String>('');

  final TextZhCommentCell texts = TextZhCommentCell();

  ScrollController scrollController;

  String replyToName;
  int replyParentId;
  int replyToId;
  bool loadMoreAble = true;
  int currentPage = 1;
  int replyToCommentId;
  bool isReplyAble = true;

  // Map memeMap;

  TextEditingController textEditingController;
  FocusNode replyFocus;

  CommentController({this.illustId});

  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    textEditingController = TextEditingController();
    scrollController = ScrollController()..addListener(_autoLoading);
    replyFocus = FocusNode()..addListener(replyFocusListener);
    getCommentList().then((value) => commentList.value = value);
    getMeme();
    super.onInit();
  }

  @override
  void didChangeMetrics() {
    print('CommentListModel run didChangeMetrics');
    final renderObject = Get.context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    double keyHeight = widgetRect.bottom - keyboardTopPoints;

    if (keyHeight > 0) {
      currentKeyboardHeight.value = keyHeight;
      memeBoxHeight.value = keyHeight;
      picBox.put('keyboardHeight', memeBoxHeight.value);
      print('didChangeMetrics memeBoxHeight: $keyHeight');
    } else {
      currentKeyboardHeight.value = 0;
    }

    super.didChangeMetrics();
  }

  getMeme() {
    rootBundle.loadString('image/meme/meme.json').then((value) {
      memeMap.value = jsonDecode(value);
      // print(memeMap);
    });
  }

  Future<List<Comment>> getCommentList({currentPage = 1}) async {
    return await getIt<CommentRepository>()
        .queryGetComment(AppType.illusts, illustId, currentPage, 10);
  }

  replyFocusListener() {
    if (replyFocus.hasFocus) {
      // currentKeyboardHeight = prefs.getDouble('KeyboardHeight');
      // notifyListeners();
      print('replyFocus on focus');
      if (isMemeMode.value) isMemeMode.value = !isMemeMode.value;
      if (replyToName != '') {
        print('replyFocusListener: replyParentId is $replyParentId');
        hintText.value = '@$replyToName:';
      }
    } else if (!replyFocus.hasFocus) {
      print('replyFocus released');

      if (!isMemeMode.value) {
        replyToId = 0;
        replyToName = '';
        replyParentId = 0;
        hintText.value = texts.addCommentHint;
        // print(textEditingController.text);
      }
    }
  }

  _autoLoading() {
    if ((scrollController.position.extentAfter < 500) && loadMoreAble) {
      print("Load Comment");
      loadMoreAble = false;
      currentPage++;
      print('current page is $currentPage');
      getCommentList(currentPage: currentPage).then((value) {
        if (value != null) {
          commentList.value = commentList.value + value;
          loadMoreAble = true;
        }
      });
    }
  }

  reply() async {
    CancelFunc cancelLoading;
    if (picBox.get('auth') == '') {
      BotToast.showSimpleNotification(title: texts.pleaseLogin);
      return false;
    }

    if (textEditingController.text == '') {
      BotToast.showSimpleNotification(title: texts.commentCannotBeBlank);
      return false;
    }

    Map<String, dynamic> payload = {
      'content': textEditingController.text,
      'parentId': replyParentId.toString(),
      'replyFromName': picBox.get('name'),
      'replyTo': replyToId.toString(),
      'replyToName': replyToName,
      'replyToCommentId': replyToCommentId,
      'platform': 'Mobile 客户端'
    };

    // onReceiveProgress(int count, int total) {
    //   cancelLoading = BotToast.showLoading();
    // }

    await getIt<CommentRepository>().querySubmitComment(
      AppType.illusts,
      illustId,
      payload,
    );

    // cancelLoading();

    textEditingController.text = '';
    replyToId = 0;
    replyToCommentId = 0;
    replyParentId = 0;
    replyToName = '';
    hintText.value = texts.addCommentHint;

    getCommentList().then((value) => commentList.value = value);
  }
}