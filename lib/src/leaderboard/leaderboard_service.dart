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

      this.weeklyStats = DomainPage<PlayerStat>(items: weeklyStats, page: page);
      this.monthlyStats =
          DomainPage<PlayerStat>(items: monthlyStats, page: page);
      this.yearlyStats = DomainPage<PlayerStat>(items: yearlyStats, page: page);

      venues = (weeklyStats + monthlyStats + yearlyStats)
          .map((e) => e.venueAddress ?? 'Unknown')
          .toSet()
          .toList();

      notifyListeners();
      print(page);
    } finally {
      client.close();
    }
  }

  next(StatDuration duration, {int sport = 1}) async {
    page++;
    fetchStats(sport: sport);
  }

  previous(StatDuration duration, {int sport = 1}) async {
    page = (page - 1).clamp(1, 9007199254740991);
    fetchStats(sport: sport);
  }

  monthlyVenueStats(String venue) {
    final stats =
        monthlyStats?.items.where((e) => e.venueAddress == venue).toList() ??
            [];
    return DomainPage<PlayerStat>(items: stats, page: page);
  }

  weeklyVenueStats(String venue) {
    final stats =
        weeklyStats?.items.where((e) => e.venueAddress == venue).toList() ?? [];
    return DomainPage<PlayerStat>(items: stats, page: page);
  }

  yearlyVenueStats(String venue) {
    final stats =
        yearlyStats?.items.where((e) => e.venueAddress == venue).toList() ?? [];
    return DomainPage<PlayerStat>(items: stats, page: page);
  }
}

enum StatDuration { week, month, year }

/// A container for Pageables backed by [List]
class DomainPage<T> {
  /// Current page number
  int page;

  /// Total number of items in the data
  int? total;
  List<T> items;

  DomainPage({
    required this.page,
    this.total,
    this.items = const [],
  });

  /// Total number of items in the page
  int get count => items.length;
}

// ToDo: Move this to a constants file.
const baseURL = 'https://lineup.ae';
const apiURL = '$baseURL/LineupTesting/api/Listing';
const imagesURL = '$baseURL/LineupTesting/';
