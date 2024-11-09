class RouteModel {
  String? code;
  List<Routes>? routes;
  List<Waypoints>? waypoints;

  RouteModel({this.code, this.routes, this.waypoints});

  RouteModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = <Waypoints>[];
      json['waypoints'].forEach((v) {
        waypoints!.add(Waypoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    if (waypoints != null) {
      data['waypoints'] = waypoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Routes {
  String? geometry;
  List<Legs>? legs;
  int? distance;
  double? duration;
  String? weightName;
  double? weight;

  Routes(
      {this.geometry,
        this.legs,
        this.distance,
        this.duration,
        this.weightName,
        this.weight});

  Routes.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(Legs.fromJson(v));
      });
    }
    distance = json['distance'];
    duration = json['duration'];
    weightName = json['weight_name'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geometry'] = geometry;
    if (legs != null) {
      data['legs'] = legs!.map((v) => v.toJson()).toList();
    }
    data['distance'] = distance;
    data['duration'] = duration;
    data['weight_name'] = weightName;
    data['weight'] = weight;
    return data;
  }
}

class Legs {
  int? distance;
  double? duration;
  String? summary;
  double? weight;

  Legs({this.distance, this.duration, this.summary, this.weight});

  Legs.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
    summary = json['summary'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['duration'] = duration;
    data['summary'] = summary;
    data['weight'] = weight;
    return data;
  }
}

class Waypoints {
  String? hint;
  double? distance;
  String? name;
  List<double>? location;

  Waypoints({this.hint, this.distance, this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    distance = json['distance'];
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hint'] = hint;
    data['distance'] = distance;
    data['name'] = name;
    data['location'] = location;
    return data;
  }
}
