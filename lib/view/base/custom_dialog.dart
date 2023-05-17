import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:zabayeh_aljazeera/helper/responsive_helper.dart';
import 'package:zabayeh_aljazeera/main.dart';

void showAnimatedDialog(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if(isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(CurvedAnimation(parent: a1, curve: Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: a1, curve: Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      }else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key key,
    @required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  })  : assert(turns != null),
        super(key: key, listenable: turns);

  Animation<double> get turns => listenable;

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}

void openDialog(Widget child, {bool isDismissible = true, bool isDialog = false, bool willPop = true}) {
  ResponsiveHelper.isMobile(Get.context) && isDialog ?
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    isScrollControlled: true,
    builder: (BuildContext context) => WillPopScope(child: child, onWillPop: ()async=> willPop),
    context: Get.context,
  ) :
  showAnimatedDialog(
    Get.context,
    Dialog(
      backgroundColor: Colors.transparent,
      child:   WillPopScope(child: child, onWillPop: ()async=> willPop),
    ),
    dismissible: isDismissible,
  );
}