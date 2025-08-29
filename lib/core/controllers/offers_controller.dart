import 'package:get/get.dart';
import 'package:smaergym/core/models/offer_model.dart';
import 'package:smaergym/core/services/section_services.dart';

class OfferController extends GetxController {

var loadOffers = true.obs;
RxList<OfferModel> offers = RxList<OfferModel>();

  @override
  void onInit() {

    getOffers();
    super.onInit();
  }

  getOffers() async{
    offers.clear();
    loadOffers.value = true;
    var respone = await SectionServices().getOffers();
    offers.addAll(respone);
    loadOffers.value = false;
  }


}