import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingUtil {
  static void show() {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.none,

      indicator: LoadingAnimationWidget.flickr(
        leftDotColor: IGColors.pink,
        rightDotColor: IGColors.blue,
        size: 40,
      ),
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
