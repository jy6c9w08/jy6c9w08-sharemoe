import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';


class ImageController extends GetxController with SingleGetTickerProviderMixin {
  final Illust illust;
  static final UserService userService=getIt<UserService>();
  static final UserRepository userRepository=getIt<UserRepository>();

  final isSelector = Rx<bool>(false);
  ImageController({required this.illust, illustId});
  late AnimationController imageLoadAnimationController;
  @override
  void onInit() {
    imageLoadAnimationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    super.onInit();
  }

  Future<bool> markIllust(bool isLiked) async {
    Map<String, String> body = {
      'userId': userService.userInfo()!.id.toString(),
      'illustId': illust.id.toString(),
      'username': userService.userInfo()!.username
    };
    if (isLiked) {
      await userRepository.queryUserCancelMarkIllust(body);
    } else {
      await userRepository.queryUserMarkIllust(body);
    }
    illust.isLiked = !illust.isLiked!;
    update(['mark']);
    return !isLiked;
  }

  @override
  void onClose() {
    imageLoadAnimationController.dispose();
    super.onClose();
  }
}
