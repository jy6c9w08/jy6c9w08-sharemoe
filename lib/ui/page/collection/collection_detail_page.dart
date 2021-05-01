import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';

class CollectionDetailPage extends GetView<CollectionDetailController> {
  // final int collectionId;
  // final Collection collection;
  final screen = ScreenUtil();

  // CollectionDetailPage({Key key, this.collectionId, this.collection})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.collection(
        title: controller.collection.title,
      ),
      body: WaterFlow.collection(
        topWidget: collectionDetailBody(),
        collectionId: controller.collection.id,
      ),
    );
  }

  Widget collectionDetailBody() {
    return GetBuilder<CollectionDetailController>(
        id: 'title',
        builder: (_) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: screen.setWidth(18),
                    top: screen.setHeight(18),
                    bottom: screen.setHeight(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screen.setWidth(25),
                      width: screen.setWidth(25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: screen.setWidth(1), color: Colors.grey[300]),
                      ),
                      margin: EdgeInsets.only(
                        right: screen.setWidth(18),
                      ),
                      child: Container(
                        height: screen.setHeight(30),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: ScreenUtil().setWidth(2),
                                color: Colors.grey[300])),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(500))),
                          child: ExtendedImage.network(
                            picBox.get('avatarLink'),
                            fit: BoxFit.cover,
                            // height: screen.setHeight(25),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: screen.setWidth(231)),
                      child: GetBuilder<CollectionDetailController>(
                          // id: 'detailBody',
                          builder: (_) {
                        return Text(
                          _.collection.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screen.setSp(14)),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: screen.setWidth(18),
                    right: screen.setWidth(18),
                    bottom: screen.setHeight(12)),
                child: Text(
                  controller.collection.caption,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: screen.setSp(12)),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      left: screen.setWidth(18),
                      right: screen.setWidth(18),
                      bottom: screen.setHeight(12)),
                  child: Wrap(
                    children: List.generate(
                        controller.collection.tagList.length,
                        (index) => tagLink(
                            controller.collection.tagList[index].tagName)),
                  )),
              // Flexible(
              //   // constraints: BoxConstraints(maxHeight: screen.setHeight(360),),
              //   child: PicPage.collection(collectionId: basicData['id'].toString()),
              // )
            ],
          );
        });
  }

  Widget tagLink(String tag) {
    return Container(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(2)),
        child: Text(
          '#$tag',
          style: TextStyle(
              color: Colors.orange[300],
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12)),
        ));
  }
}