import 'package:get/get.dart';
import 'package:smaergym/core/controllers/exercise_controller.dart';
import 'package:smaergym/core/controllers/sections_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/user_courses_controller.dart';
class BindingsController extends Bindings {
  @override
  void dependencies() {
    Get.put<SectionsController>(SectionsController(), permanent: true);
        Get.put<ExerciseController>(ExerciseController(), permanent: true);
        Get.put<UserController>(UserController(), permanent: true);
       
  }
}
