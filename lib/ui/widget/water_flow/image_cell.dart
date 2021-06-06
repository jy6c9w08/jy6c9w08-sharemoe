import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';

class ImageCell extends GetView<ImageController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();
  final Color _color = Color.fromARGB(
    255,
    Random.secure().nextInt(200),
    Random.secure().nextInt(200),
    Random.secure().nextInt(200),
  );

  ImageCell({Key? key, required this.tag}) : super(key: key);

  Widget dealImageState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Opacity(
          opacity: 0.3,
          child: Container(
            height: screen.screenWidth /
                2 /
                controller.illust.width.toDouble() *
                controller.illust.height.toDouble(),
            width: screen.screenWidth / 2,
            color: _color,
          ),
        );
      case LoadState.completed:
        controller.controller.forward();
        return FadeTransition(
          opacity: controller.controller,
          child: ExtendedRawImage(
            image: state.extendedImageInfo?.image,
          ),
        );
      case LoadState.failed:
        return Center(child: Text("加载失败"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ImageController>(
        tag: tag,
        builder: (_) {
          return ShaderMask(
            shaderCallback: (controller.isSelector.value)
                // 长按进入选择模式时，为选中的画作设置遮罩
                ? (bounds) => LinearGradient(
                        colors: [Colors.grey.shade600, Colors.grey.shade600])
                    .createShader(bounds)
                : (bounds) =>
                    LinearGradient(colors: [Colors.white, Colors.white])
                        .createShader(bounds),
            child: AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: ScreenUtil().setWidth(148) /
                    controller.illust.width.toDouble() *
                    controller.illust.height.toDouble(),
                minWidth: ScreenUtil().setWidth(148),
              ),
              duration: Duration(milliseconds: 350),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  // 若被选中，则添加边框
                  border: controller.isSelector.value
                      ? Border.all(
                          width: ScreenUtil().setWidth(3),
                          color: Colors.black38)
                      : Border.all(width: 0.0, color: Colors.white),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(15)))),
              child: Hero(
                tag: 'imageHero' + controller.illust.imageUrls[0].medium,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(12))),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          controller.isSelector.value =
                              !controller.isSelector.value;
                          controller.isSelector.value
                              ? Get.find<CollectionSelectorCollector>()
                                  .addIllustToCollectList(controller.illust)
                              : Get.find<CollectionSelectorCollector>()
                                  .removeIllustToSelectList(controller.illust);
                        },
                        onTap: () {
                          if (controller.isSelector.value) {
                            controller.isSelector.value =
                                !controller.isSelector.value;
                            Get.find<CollectionSelectorCollector>()
                                .removeIllustToSelectList(controller.illust);
                          } else if (Get.find<CollectionSelectorCollector>()
                                  .selectList
                                  .length !=
                              0) {
                            controller.isSelector.value =
                                !controller.isSelector.value;

                            Get.find<CollectionSelectorCollector>()
                                .addIllustToCollectList(controller.illust);
                          } else {
                            Get.toNamed(Routes.DETAIL,
                                arguments: controller.illust.id.toString(),
                                preventDuplicates: false);
                          }
                        },
                        child: ExtendedImage.network(
                          controller.illust.imageUrls[0].medium.replaceAll(
                              'https://i.pximg.net', 'https://acgpic.net'),
                          cache: true,
                          headers: {'Referer': 'https://m.sharemoe.net/'},
                          loadStateChanged: dealImageState,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GetX<GlobalController>(builder: (_) {
                          return _.isLogin.value
                              ? GetBuilder<ImageController>(
                                  tag: tag,
                                  id: 'mark',
                                  builder: (_) {
                                    return Material(
                                      child: IconButton(
                                        iconSize: 30,
                                        color: controller.illust.isLiked!
                                            ? Colors.red
                                            : Colors.grey,
                                        icon: Icon(Icons.favorite),
                                        onPressed: () {
                                          controller.markIllust();
                                        },
                                      ),
                                    );
                                  })
                              : Container();
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
