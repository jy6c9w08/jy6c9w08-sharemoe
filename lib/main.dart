import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';

import 'basic/download_service.dart';
import 'data/model/image_download_info.dart';
import 'package:logger/logger.dart';
void main() async {
   configureDependencies();
  await HiveConfig.initHive();

/*   DownloadService downloadService=await DownloadService.create(getIt<Logger>());
   downloadService.download(ImageDownloadInfo(
      fileName:
     "test.jpg",
      illustId: 123,
      pageCount: 0  ,//TODO ,
      imageUrl: "https://o.acgpic.net/img-original/img/2021/06/22/00/00/09/90722077_p0.png"));*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ScreenUtilInit(
      designSize: Size(324, 576),
      builder: () => GetMaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        initialBinding: HomeBinding(),
        initialRoute: Routes.HOME,
        getPages: AppPages.pages,
        builder: BotToastInit(),
      ),
    );
  }
}
