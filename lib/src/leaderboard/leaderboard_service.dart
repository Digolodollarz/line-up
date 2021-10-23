import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lineup/src/models/player_stat_model.dart';
import 'package:http/http.dart' as http;

/// Provider for player statistics
///
///
class LeaderboardService with ChangeNotifier {
  DomainPage<PlayerStat>? weeklyStats;
  DomainPage<PlayerStat>? monthlyStats;
  DomainPage<PlayerStat>? yearlyStats;

  /// This guy will have to move somewhere else.
  List<String> venues = [];

  final nhasi = DateTime.now();

  late String week =
      'Week (${nhasi.day - 7} ${nhasi.month} - ${nhasi.day} ${nhasi.month})';
  late String month = 'Month - ${nhasi.month}';
  late String year = 'Year - ${nhasi.year}';

  int page = 1;
  int count = 20;

  LeaderboardService() {
    getAll();
  }

  /// Convenience method to initialise a class properties.
  getAll() {
    fetchStats();
  }

  /// fetch player statistics
  ///
  /// [sport] - The ID for the sport you are fetching stats for
  fetchStats({int sport = 1}) async {
    final url = '$apiURL/GetPlayerStatsTest/All/$page/$count/$sport';
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(url));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final List weeklyStatsJson = decodedResponse['WeeklyStats'] ?? [];
      final List monthlyStatsJson = decodedResponse['MonthlyStats'] ??
          decodedResponse['MonthLyStats'] ??
          [];
      final List yearlyStatsJson = decodedResponse['YearlyStats'] ?? [];

      final weeklyStats =
          weeklyStatsJson.map((stat) => PlayerStat.fromJson(stat)).toList();
      final monthlyStats =
          monthlyStatsJson.map((stat) => PlayerStat.fromJson(stat)).toList();
      final yearlyStats =
          yearlyStatsJson.map((stat) => PlayerStat.fromJson(stat)).toList();

      this.weeklyStats =
          DomainPage<PlayerStat>(items: weeklyStats, count: weeklyStats.length);
      this.monthlyStats = DomainPage<PlayerStat>(
          items: monthlyStats, count: monthlyStats.length);
      this.yearlyStats =
          DomainPage<PlayerStat>(items: yearlyStats, count: yearlyStats.length);

      venues = (weeklyStats + monthlyStats + yearlyStats)
          .map((e) => e.venueAddress?? 'Unknown')
          .toSet()
          .toList();

      notifyListeners();
    } finally {
      client.close();
    }
  }

  monthlyVenueStats(String venue) {
    final stats =
        monthlyStats?.items.where((e) => e.venueAddress == venue).toList() ??
            [];
    return DomainPage<PlayerStat>(items: stats, count: stats.length);
  }

  weeklyVenueStats(String venue) {
    final stats =
        weeklyStats?.items.where((e) => e.venueAddress == venue).toList() ?? [];
    return DomainPage<PlayerStat>(items: stats, count: stats.length);
  }

  yearlyVenueStats(String venue) {
    final stats =
        yearlyStats?.items.where((e) => e.venueAddress == venue).toList() ?? [];
    return DomainPage<PlayerStat>(items: stats, count: stats.length);
  }
}

/// A container for Pageables backed by [List]
class DomainPage<T> {
  int page;
  int count;
  int? total;
  List<T> items;

  DomainPage({
    this.page = 0,
    this.count = 0,
    this.total,
    this.items = const [],
  });
}

// ToDo: Move this to a constants file.
const baseURL = 'https://lineup.ae';
const apiURL = '$baseURL/LineupTesting/api/Listing';
const imagesURL = '$baseURL/LineupTesting/';
