import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';

class CarouselRepoImp {
  final BaseApiService _apiService = NetworkApiService();

  Future<CarouselSliderResponse> getCarouselSliders() async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.getCarouselSlider);
      return sliderResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
