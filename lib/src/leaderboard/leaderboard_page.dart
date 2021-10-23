import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lineup/src/leaderboard/leaderboard_service.dart';
import 'package:lineup/src/models/player_stat_model.dart';
import 'package:provider/provider.dart';

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
                                tabs: [const Text('All')] + venues.map((e) => Text(e)).toList(),
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
                                                        .weeklyVenueStats(venue)!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title: leaderboardService
                                                        .month,
                                                    stats: leaderboardService
                                                        .monthlyVenueStats(venue)!,
                                                  ),
                                                  SizedBox(height: 16),
                                                  DetailCard(
                                                    title:
                                                        leaderboardService.year,
                                                    stats: leaderboardService
                                                        .yearlyVenueStats(venue)!,
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

class DetailCard extends StatefulWidget {
  final DomainPage<PlayerStat> stats;
  final String title;

  const DetailCard({Key? key, required this.stats, required this.title})
      : super(key: key);

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  bool expanded = false;
  late int length;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              expanded = !expanded;
            }),
            child: Container(
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    child: expanded
                        ? const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.green,
                            key: ValueKey(1),
                          )
                        : const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.green,
                            key: ValueKey(2),
                          ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 12 * 12,
                  child: Row(
                    children: [
                      Text('PL'),
                      Text('W'),
                      Text('A'),
                      Text('G'),
                      Text('DF'),
                      Text('MVP'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, pos) {
                final player = widget.stats.items[pos];

                return Row(
                  children: [
                    SizedBox(width: 10),
                    SizedBox(
                      child: Center(child: Text('${pos + 1}')),
                      width: 12 * 2,
                    ),
                    SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        backgroundImage: (player.imageUrl != null
                                ? CachedNetworkImageProvider(
                                    '$imagesURL/${player.imageUrl}')
                                : AssetImage('assets/img/p-placeholder.png'))
                            as ImageProvider,
                      ),
                    ),
                    Expanded(
                      child: Text('${player.name}'),
                    ),
                    SizedBox(
                      width: 12 * 12,
                      child: Row(
                        children: [
                          Text('${player.played}'),
                          Text('${player.won}'),
                          Text('${player.assist}'),
                          Text('${player.score}'),
                          Text('${player.df}'),
                          Text('${player.mvp}'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                );
              },
              itemCount: expanded
                  ? widget.stats.count
                  : 5.clamp(0, widget.stats.count),
            ),
          ),
        ],
      ),
    );
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
