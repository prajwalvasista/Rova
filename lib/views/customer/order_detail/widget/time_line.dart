import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/views/customer/order_detail/widget/event.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;
  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    this.eventCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: const LineStyle(
          color: AppColors.black,
        ),
        indicatorStyle: IndicatorStyle(
          width: 25,
          color:  Colors.green ,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: Colors.white,
          ),
        ),
        endChild: Event(
          child: eventCard,
        ),
      ),
    );
  }
}