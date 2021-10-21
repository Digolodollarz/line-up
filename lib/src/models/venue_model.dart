// To parse this JSON data, do
//
//     final venue = venueFromJson(jsonString);

import 'dart:convert';

List<Venue> venueFromJson(String str) =>
    List<Venue>.from(json.decode(str).map((x) => Venue.fromJson(x)));

String? venueToJson(List<Venue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Venue {
  Venue({
    this.id,
    this.venueName,
    this.venueAddress,
    this.venueFullAddress,
    this.facilitiesAvailable,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.imgId,
    this.images,
  });

  int? id;
  String? venueName;
  String? venueAddress;
  String? venueFullAddress;
  FacilitiesAvailable? facilitiesAvailable;
  String? latitude;
  String? longitude;
  String? imageUrl;
  int? imgId;
  List<Image>? images;

  Venue copyWith({
    int? id,
    String? venueName,
    String? venueAddress,
    String? venueFullAddress,
    FacilitiesAvailable? facilitiesAvailable,
    String? latitude,
    String? longitude,
    String? imageUrl,
    int? imgId,
    List<Image>? images,
  }) =>
      Venue(
        id: id ?? this.id,
        venueName: venueName ?? this.venueName,
        venueAddress: venueAddress ?? this.venueAddress,
        venueFullAddress: venueFullAddress ?? this.venueFullAddress,
        facilitiesAvailable: facilitiesAvailable ?? this.facilitiesAvailable,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        imageUrl: imageUrl ?? this.imageUrl,
        imgId: imgId ?? this.imgId,
        images: images ?? this.images,
      );

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["Id"] == null ? null : json["Id"],
        venueName: json["VenueName"] == null ? null : json["VenueName"],
        venueAddress:
            json["VenueAddress"] == null ? null : json["VenueAddress"],
        venueFullAddress:
            json["VenueFullAddress"] == null ? null : json["VenueFullAddress"],
        facilitiesAvailable: json["FacilitiesAvailable"] == null
            ? null
            : facilitiesAvailableValues.map[json["FacilitiesAvailable"]],
        latitude: json["Latitude"] == null ? null : json["Latitude"],
        longitude: json["Longitude"] == null ? null : json["Longitude"],
        imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
        imgId: json["ImgId"] == null ? null : json["ImgId"],
        images: json["Images"] == null
            ? null
            : List<Image>.from(json["Images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "VenueName": venueName == null ? null : venueName,
        "VenueAddress": venueAddress == null ? null : venueAddress,
        "VenueFullAddress": venueFullAddress == null ? null : venueFullAddress,
        "FacilitiesAvailable": facilitiesAvailable == null
            ? null
            : facilitiesAvailableValues.reverse[facilitiesAvailable],
        "Latitude": latitude == null ? null : latitude,
        "Longitude": longitude == null ? null : longitude,
        "ImageUrl": imageUrl == null ? null : imageUrl,
        "ImgId": imgId == null ? null : imgId,
        "Images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

enum FacilitiesAvailable { EMPTY, PARKING }

final facilitiesAvailableValues = EnumValues(
    {"": FacilitiesAvailable.EMPTY, "parking": FacilitiesAvailable.PARKING});

class Image {
  Image({
    this.id,
    this.imageUrl,
    this.name,
    this.fileExtension,
  });

  int? id;
  String? imageUrl;
  dynamic name;
  dynamic fileExtension;

  Image copyWith({
    int? id,
    String? imageUrl,
    dynamic name,
    dynamic fileExtension,
  }) =>
      Image(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        fileExtension: fileExtension ?? this.fileExtension,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["Id"] == null ? null : json["Id"],
        imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
        name: json["Name"],
        fileExtension: json["FileExtension"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "ImageUrl": imageUrl == null ? null : imageUrl,
        "Name": name,
        "FileExtension": fileExtension,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
