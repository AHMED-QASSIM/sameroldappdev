import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/controllers/notification_controller.dart';
import '../../core/models/notifications_model.dart';
import '../../core/widgets/no_data_widget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  NotificationController notificationController =
      Get.put(NotificationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "الاشعارات",
            style: TextStyle(fontSize: 18.sp),
          ),
          centerTitle: false,
       
        ),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.only(top: 0),
            child: notificationController.loaddata.value
                ? Center(
           child: LottieBuilder.asset("assets/json/nodata.json",width: 200.w,),
         )
                : notificationController.loaddata.value == false &&
               notificationController.notifications.length == 0
           ? Center(
               child: NoData(title: "لا يوجد اشعارات",),
             )
           : ListView.builder(
             padding: EdgeInsets.only(top: 10),
               itemCount: notificationController.notifications.length,
               itemBuilder: (context, pos) {
                 return notification(
                     notificationController.notifications[pos]);
               },
             ),
          ),
        )
    );
  }

  Widget notification(NotificationModel notificationModel) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Get.isDarkMode
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Colors.grey.shade100,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ],
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bell,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(
                            notificationModel.title!,
                            style: TextStyle(fontSize: 18.sp, height: 1.6,overflow: TextOverflow.ellipsis),
                          ),),
                          Text(
                              notificationModel.dateTime!
                                  .toDate()
                                  .year
                                  .toString() + "-" + notificationModel.dateTime!
                                  .toDate()
                                  .month
                                  .toString() + "-" + notificationModel.dateTime!
                                  .toDate()
                                  .day
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1.2,
                                  color: Colors.grey))
                        ],
                      ),
                      Text(
                        notificationModel.body!,
                        style: TextStyle(
                            fontSize: 14.sp, height: 1.5, color: Colors.grey),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
