import 'package:customizable_item/customizable_item.dart';
import 'package:flutter/material.dart';

class Item {
  final double xPosition;
  final double yPosition;
  final double width;
  final double height;
  final double angle;

  Item({
    required this.xPosition,
    required this.yPosition,
    required this.width,
    required this.height,
    required this.angle,
  });

  Item copyWith({
    int? index,
    double? xPosition,
    double? yPosition,
    double? width,
    double? height,
    double? angle,
  }) {
    return Item(
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
    );
  }
}
