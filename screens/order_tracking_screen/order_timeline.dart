import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeline extends StatelessWidget {
  final String status;
  final bool isFirst;
  final bool isLast;
  final bool isActive;

  const OrderTimeline({
    Key? key,
    required this.status,
    this.isFirst = false,
    this.isLast = false,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isActive ? Colors.blueAccent : Colors.grey[300]!,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isActive ? Colors.blueAccent : Colors.grey[300]!,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: isActive ? Colors.blueAccent : Colors.grey[300]!,
        iconStyle: IconStyle(
          iconData: isActive ? Icons.check : Icons.circle,
          color: Colors.white,
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.blueAccent : Colors.grey[300]!,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
