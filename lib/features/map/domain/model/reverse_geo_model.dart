class ReverseGeoModel {
  Place? place;
  int? status;

  ReverseGeoModel({this.place, this.status});

  ReverseGeoModel.fromJson(Map<String, dynamic> json) {
    place = json['place'] != null ? Place.fromJson(json['place']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (place != null) {
      data['place'] = place!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Place {
  int? id;
  double? distanceWithinMeters;
  String? address;
  String? area;
  String? city;
  String? postCode;
  String? addressBn;
  String? areaBn;
  String? cityBn;
  String? country;
  String? division;
  String? district;
  String? subDistrict;
  Null pauroshova;
  Null union;
  String? locationType;
  AddressComponents? addressComponents;
  AreaComponents? areaComponents;

  Place(
      {this.id,
        this.distanceWithinMeters,
        this.address,
        this.area,
        this.city,
        this.postCode,
        this.addressBn,
        this.areaBn,
        this.cityBn,
        this.country,
        this.division,
        this.district,
        this.subDistrict,
        this.pauroshova,
        this.union,
        this.locationType,
        this.addressComponents,
        this.areaComponents});

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    distanceWithinMeters = double.tryParse(json['distance_within_meters'].toString());
    address = json['address'];
    area = json['area'];
    city = json['city'];
    postCode = json['postCode'];
    addressBn = json['address_bn'];
    areaBn = json['area_bn'];
    cityBn = json['city_bn'];
    country = json['country'];
    division = json['division'];
    district = json['district'];
    subDistrict = json['sub_district'];
    pauroshova = json['pauroshova'];
    union = json['union'];
    locationType = json['location_type'];
    addressComponents = json['address_components'] != null
        ? AddressComponents.fromJson(json['address_components'])
        : null;
    areaComponents = json['area_components'] != null
        ? AreaComponents.fromJson(json['area_components'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['distance_within_meters'] = distanceWithinMeters;
    data['address'] = address;
    data['area'] = area;
    data['city'] = city;
    data['postCode'] = postCode;
    data['address_bn'] = addressBn;
    data['area_bn'] = areaBn;
    data['city_bn'] = cityBn;
    data['country'] = country;
    data['division'] = division;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['pauroshova'] = pauroshova;
    data['union'] = union;
    data['location_type'] = locationType;
    if (addressComponents != null) {
      data['address_components'] = addressComponents!.toJson();
    }
    if (areaComponents != null) {
      data['area_components'] = areaComponents!.toJson();
    }
    return data;
  }
}

class AddressComponents {
  Null placeName;
  String? house;
  String? road;

  AddressComponents({this.placeName, this.house, this.road});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    placeName = json['place_name'];
    house = json['house'];
    road = json['road'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_name'] = placeName;
    data['house'] = house;
    data['road'] = road;
    return data;
  }
}

class AreaComponents {
  String? area;
  String? subArea;

  AreaComponents({this.area, this.subArea});

  AreaComponents.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    subArea = json['sub_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    data['sub_area'] = subArea;
    return data;
  }
}
