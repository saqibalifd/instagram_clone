import 'package:get/get.dart';
import '../controllers/feed_controller.dart';

// ============================================================
//  WHAT GOES HERE
//  Registers FeedController (and any other feed-scoped
//  dependencies) via Get.lazyPut.
// ============================================================
class FeedBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<FeedController>(() => FeedController(Get.find()));
}
