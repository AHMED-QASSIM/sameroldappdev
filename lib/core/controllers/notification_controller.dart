import 'package:get/get.dart';
import 'package:smaergym/core/services/user_courses_services.dart';

import '../models/notifications_model.dart';

class NotificationController extends GetxController {

  RxList<NotificationModel> notifications = RxList<NotificationModel>();
  var loaddata = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getNotifications();
    super.onInit();
  }

  getNotifications() async{
    loaddata.value = true;
    var request = await UserCoursesServices().getNotifications();

    notifications.bindStream(request);

    loaddata.value = false;
  }


}
