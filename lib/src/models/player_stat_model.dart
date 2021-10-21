// To parse this JSON data, do
//
//     final playerStat = playerStatFromJson(jsonString);

import 'dart:convert';

PlayerStat playerStatFromJson(String str) => PlayerStat.fromJson(json.decode(str));

String? playerStatToJson(PlayerStat data) => json.encode(data.toJson());

class PlayerStat {
  PlayerStat({
    this.phoneNumber,
    this.userId,
    this.rankNum,
    this.name,
    this.played,
    this.mvp,
    this.df,
    this.won,
    this.tie,
    this.lost,
    this.score,
    this.assist,
    this.imageUrl,
    this.venueAddress,
  });

  String? phoneNumber;
  String? userId;
  int? rankNum;
  String? name;
  int? played;
  int? mvp;
  int? df;
  int? won;
  int? tie;
  int? lost;
  int? score;
  int? assist;
  String? imageUrl;
  String? venueAddress;

  PlayerStat copyWith({
    String? phoneNumber,
    String? userId,
    int? rankNum,
    String? name,
    int? played,
    int? mvp,
    int? df,
    int? won,
    int? tie,
    int? lost,
    int? score,
    int? assist,
    String? imageUrl,
    String? venueAddress,
  }) =>
      PlayerStat(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        userId: userId ?? this.userId,
        rankNum: rankNum ?? this.rankNum,
        name: name ?? this.name,
        played: played ?? this.played,
        mvp: mvp ?? this.mvp,
        df: df ?? this.df,
        won: won ?? this.won,
        tie: tie ?? this.tie,
        lost: lost ?? this.lost,
        score: score ?? this.score,
        assist: assist ?? this.assist,
        imageUrl: imageUrl ?? this.imageUrl,
        venueAddress: venueAddress ?? this.venueAddress,
      );

  factory PlayerStat.fromJson(Map<String, dynamic> json) => PlayerStat(
    phoneNumber: json["PhoneNumber"],
    userId: json["UserId"],
    rankNum: json["rankNum"] == null ? null : int.tryParse(json["rankNum"]),
    name: json["Name"],
    played: json["Played"] == null ? null : int.tryParse(json["Played"]),
    mvp: json["Mvp"] == null ? null : int.tryParse(json["Mvp"]),
    df: json["Df"] == null ? null : int.tryParse(json["Df"]),
    won: json["Won"] == null ? null : int.tryParse(json["Won"]),
    tie: json["Tie"] == null ? null : int.tryParse(json["Tie"]),
    lost: json["Lost"] == null ? null : int.tryParse(json["Lost"]),
    score: json["Score"] == null ? null : int.tryParse(json["Score"]),
    assist: json["Assist"] == null ? null : int.tryParse(json["Assist"]),
    imageUrl: json["ImageUrl"],
    venueAddress: json["VenueAddress"],
  );

  Map<String, dynamic> toJson() => {
    "PhoneNumber": phoneNumber,
    "UserId": userId,
    "rankNum": rankNum,
    "Name": name,
    "Played": played,
    "Mvp": mvp,
    "Df": df,
    "Won": won,
    "Tie": tie,
    "Lost": lost,
    "Score": score,
    "Assist": assist,
    "ImageUrl": imageUrl,
    "VenueAddress": venueAddress,
  };
}
