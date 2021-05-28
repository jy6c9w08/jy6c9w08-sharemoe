import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ImageController extends GetxController with SingleGetTickerProviderMixin {
  late bool isLiked;
  late int illustId;

  final isSelector = Rx<bool>(false);

  // final  illust=Rx<Illust>();
  late AnimationController controller;

  ImageController({required this.illustId});

  @override
  void onInit() {
    controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    super.onInit();
  }

  markIllust() async {
    Map<String, String> body = {
      'userId': picBox.get('id').toString(),
      'illustId': illustId.toString(),
      'username': picBox.get('name')
    };
    if (isLiked) {
      await getIt<UserRepository>().queryUserCancelMarkIllust(body);
    } else {
      await getIt<UserRepository>().queryUserMarkIllust(body);
    }

    isLiked = !isLiked;

    update(['mark']);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
