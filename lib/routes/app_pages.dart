import 'package:get/get.dart';

import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/bindings/login_binding.dart';
import 'package:sharemoe/bindings/search_binding.dart';
import 'package:sharemoe/ui/page/home_page.dart';
import 'package:sharemoe/ui/page/login/login_page.dart';
import 'package:sharemoe/ui/page/pic_detail/pic_detail_page.dart';
import 'package:sharemoe/ui/page/search/search_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: Routes.SEARCH,
        page: () => SearchPage(),
        binding: SearchBinding()),
    GetPage(
        name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(
      name: Routes.DETAIL,
      page: () => PicDetailPage(
        illust: Get.arguments,
      ),
    )
  ];
}
