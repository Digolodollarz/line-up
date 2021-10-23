
import 'package:flutter/material.dart';
import 'package:lineup/src/leaderboard/leaderboard_service.dart';
import 'package:provider/provider.dart';

import 'detail_card_widget.dart';

const red = Color(0xffa30b00);
const lightGrey = Color(0xffdddddd);
const grey = Color(0xff888888);

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LeaderboardService>(
        create: (_) => LeaderboardService(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: const [Colors.black, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.3])),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Leaderboard',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.green,
                          ),
                          Text(
                            'Football',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<LeaderboardService>(
                        builder: (context, leaderboardService, _) {
                      if (leaderboardService.yearlyStats == null) {
                        return const CircularProgressIndicator();
                      }
                      final venues = leaderboardService.venues;
                      return Expanded(
                        child: DefaultTabController(
                          length: venues.length + 1,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabs: [const Text('All')] +
                                    venues.map((e) => Text(e)).toList(),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.grey),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: SingleChildScrollView(
                                            child: DefaultTextStyle(
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title:
                                                        leaderboardService.week,
                                                    stats: leaderboardService
                                                        .weeklyStats!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title: leaderboardService
                                                        .month,
                                                    stats: leaderboardService
                                                        .monthlyStats!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title:
                                                        leaderboardService.year,
                                                    stats: leaderboardService
                                                        .yearlyStats!,
                                                  ),
                                                  SizedBox(height: MediaQuery.of(context).padding.bottom)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ] +
                                      venues.map((venue) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.grey),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: SingleChildScrollView(
                                            child: DefaultTextStyle(
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title:
                                                        leaderboardService.week,
                                                    stats: leaderboardService
                                                        .weeklyVenueStats(
                                                            venue)!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title: leaderboardService
                                                        .month,
                                                    stats: leaderboardService
                                                        .monthlyVenueStats(
                                                            venue)!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title:
                                                        leaderboardService.year,
                                                    stats: leaderboardService
                                                        .yearlyVenueStats(
                                                            venue)!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            extendBody: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(32),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ABottomNavItem(
                          icon: Icons.home_outlined,
                          label: 'Home',
                        ),
                        ABottomNavItem(
                          icon: Icons.sticky_note_2_outlined,
                          label: 'Activities',
                        ),
                        ABottomNavItem(
                          icon: Icons.emoji_events_sharp,
                          label: 'Leaderboard',
                          selected: true,
                        ),
                        ABottomNavItem(
                          icon: Icons.person_outline,
                          label: 'Player Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}


class ABottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const ABottomNavItem(
      {Key? key,
      required this.icon,
      required this.label,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: selected ? Colors.green : Colors.black,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: selected ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
