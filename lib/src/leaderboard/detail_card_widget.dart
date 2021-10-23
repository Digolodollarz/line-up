
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lineup/src/models/player_stat_model.dart';
import 'package:provider/provider.dart';

import 'leaderboard_page.dart';
import 'leaderboard_service.dart';

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
          Row(
            children: [
              if(expanded && widget.stats.page > 1)
                TextButton(
                    onPressed: () {
                      Provider.of<LeaderboardService>(context, listen: false)
                          .previous(StatDuration.year);
                    },
                    child: Text('Previous')),
              if (expanded && widget.stats.count > 19)
                Spacer(),
              if (expanded && widget.stats.count > 19)
                TextButton(
                    onPressed: () {
                      Provider.of<LeaderboardService>(context, listen: false)
                          .next(StatDuration.year);
                    },
                    child: Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}