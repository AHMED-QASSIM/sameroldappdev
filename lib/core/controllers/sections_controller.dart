import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:smaergym/core/services/section_services.dart';

class SectionsController extends GetxController {

RxList<SectionModel> sections = RxList<SectionModel>();


@override
  void onInit() {
    
    getSections();
    // TODO: implement onInit
    super.onInit();
  }


  getSections() async{
    var respone = await SectionServices().getSections();
    sections.add(
      SectionModel(
        id: "0",
        title: "الكل",
        selected: true
      )
    );
    sections.addAll(respone);
  }

}