import 'package:lamis/data/remote/remote.dart';
import 'package:lamis/models/models.dart';
import 'package:lamis/repos/repos.dart';

class AddressRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<GeneralResponse?> addAddress(
      {String? address,
      int? country,
      int? state,
      int? city,
      String? zipCode,
      String? phoneNumber}) async {
    try {
      Map<String, String> body = {
        "user_id": UserRepo().user.id.toString(),
        "address": address ?? '',
        "country_id": '$country',
        "state_id": '$state',
        "city_id": '$city',
        "postal_code": zipCode ?? '',
        "phone": phoneNumber ?? ''
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.addAddress, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CountryResponse?> countriesList() async {
    try {
      dynamic response = await _apiService.getRequest(ApiEndPoints.countries);
      return countryResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AddressResponse?> getAddresses() async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated(ApiEndPoints.getUserAddresses);
      return addressResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> postSelectAddress(int addId) async {
    try {
      Map<String, String> body = {
        "user_id": UserRepo().user.id.toString(),
        "address_id": addId.toString()
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.sendNewAddress, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<MyStateResponse?> statesList(int countryId) async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated("${ApiEndPoints.stateByCountry}$countryId");
      return myStateResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CityResponse?> citiesList(int stateId) async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated("${ApiEndPoints.citiesByState}$stateId");
      return cityResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> updateAddress(
      {int? id,
      String? address,
      int? countryId,
      int? stateId,
      int? cityId,
      String? postalCode,
      String? phone}) async {
    try {
      Map<String, String> body = {
        "id": "$id",
        "address": "$address",
        "country_id": "$countryId",
        "state_id": "$stateId",
        "city_id": "$cityId",
        "postal_code": "$postalCode",
        "phone": "$phone"
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.updateAddress, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteAddress({int? id}) async {
    try {
      dynamic response = await _apiService
          .getRequestAuthenticated(ApiEndPoints.deleteAddress + id.toString());
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> updateMapAddress(
      {int? id, double? lan, double? lat}) async {
    try {
      Map<String, String> body = {
        "id": id.toString(),
        "latitude": lat.toString(),
        "longitude": lan.toString()
      };
      dynamic response = await _apiService.postRequestAuthenticated(
          ApiEndPoints.shippingAddressMap, body);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> changeCountry() async {
    try {
      dynamic response =
          await _apiService.getRequest(ApiEndPoints.changeCountry);
      return generalResponseFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
