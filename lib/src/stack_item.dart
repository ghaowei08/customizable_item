import 'dart:math';
import 'package:customizable_item/src/item_action_enum.dart';
import 'package:flutter/material.dart';

class StackItem extends StatefulWidget {
  const StackItem({
    Key? key,
    required this.index,
    this.xPosition = 0,
    this.yPosition = 0,
    this.height = 1,
    this.width = 1,
    this.angle = 0,
    this.intervalDivision = 25,
    this.shape = BoxShape.rectangle,
    this.boxAction = ItemAction.move,
    this.child = const SizedBox(),
    required this.addItem,
    required this.updateItem,
    required this.removeItem,
  }) : super(key: key);

  final int index;
  final double xPosition;
  final double yPosition;
  final double width;
  final double height;
  final double angle;
  final double intervalDivision;
  final BoxShape shape;
  final ItemAction boxAction;
  final Function addItem;
  final Function updateItem;
  final Function removeItem;
  final Widget child;

  @override
  State<StackItem> createState() => _StackItemState();
}

class _StackItemState extends State<StackItem> {
  late double intervalDivision;
  late int indexOrigin;
  late double heightOrigin;
  late double widthOrigin;
  late double xPositionOrigin;
  late double yPositionOrigin;
  late double angleOrigin;
  late double rotateBtnSpace;
  late BoxShape shapeOrigin;
  late Widget child;

  @override
  void initState() {
    super.initState();
    indexOrigin = widget.index;
    heightOrigin = widget.height;
    widthOrigin = widget.width;
    xPositionOrigin = widget.xPosition;
    yPositionOrigin = widget.yPosition;
    angleOrigin = widget.angle;
  }

  @override
  Widget build(BuildContext context) {
    ItemAction actionOrigin = widget.boxAction;
    Widget childOrigin = widget.child;
    BoxShape shapeOrigin = widget.shape;
    double intervalDivision = widget.intervalDivision;
    double rotateBtnSpace = 2 * intervalDivision;

    void handleOnPanEnd() {
      widget.updateItem(
        indexOrigin,
        height: heightOrigin,
        width: widthOrigin,
        xPosition: xPositionOrigin,
        yPosition: yPositionOrigin,
        angle: angleOrigin,
        action: actionOrigin,
        shape: shapeOrigin,
      );
    }

    Widget child = GestureDetector(
      onDoubleTap: () {
        actionOrigin = ItemAction.edit;
        handleOnPanEnd();
      },
      onTapDown: (update) {
        actionOrigin = ItemAction.move;
        handleOnPanEnd();
      },
      child: Transform.rotate(
        angle: angleOrigin * pi / 180,
        alignment: Alignment.center,
        child: Container(
          height: heightOrigin * intervalDivision,
          width: widthOrigin * intervalDivision,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            shape: shapeOrigin,
          ),
          child: Center(
            child: childOrigin,
          ),
        ),
      ),
    );

    Widget editableContainer = Positioned(
        top: yPositionOrigin * intervalDivision,
        left: xPositionOrigin * intervalDivision,
        child: Column(
          children: [
            child,
            IconButton(
              onPressed: () {
                actionOrigin = ItemAction.rotate;
                handleOnPanEnd();
              },
              tooltip: "Rotate",
              icon: const Icon(
                Icons.rotate_left,
                size: 24,
                color: Color.fromARGB(255, 25, 212, 31),
              ),
            ),
            IconButton(
              onPressed: () {
                actionOrigin = ItemAction.scale;
                handleOnPanEnd();
              },
              tooltip: "Scale",
              icon: const Icon(
                Icons.pages_outlined,
                color: Colors.blue,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                actionOrigin = ItemAction.delete;
                handleOnPanEnd();
              },
              tooltip: "Delete",
              icon: const Icon(
                Icons.delete,
                size: 24,
                color: Colors.red,
              ),
            )
          ],
        ));

    Widget moveableContainer = Positioned(
      top: yPositionOrigin * intervalDivision,
      left: xPositionOrigin * intervalDivision,
      child: GestureDetector(
        onPanUpdate: (update) {
          setState(() {
            xPositionOrigin += (update.delta.dx / intervalDivision);
            yPositionOrigin += (update.delta.dy / intervalDivision);
          });
        },
        onPanEnd: (update) => handleOnPanEnd,
        child: child,
      ),
    );

    Widget scaleableContainer = Positioned(
      top: (yPositionOrigin - 0.5) * intervalDivision,
      left: (xPositionOrigin - 0.5) * intervalDivision,
      child: SizedBox(
        height: (heightOrigin + 1) * intervalDivision,
        width: (widthOrigin + 1) * intervalDivision,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / intervalDivision;
                      final dy = update.delta.dy / intervalDivision;

                      if (widthOrigin - dx < 1) {
                        widthOrigin = 1;
                      } else {
                        widthOrigin -= dx;
                        xPositionOrigin += dx;
                      }
                      if (heightOrigin - dy < 1) {
                        heightOrigin = 1;
                      } else {
                        heightOrigin -= dy;
                        yPositionOrigin += dy;
                      }
                    });
                  },
                  onPanEnd: (update) => handleOnPanEnd,
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / intervalDivision;
                      final dy = update.delta.dy / intervalDivision;

                      if (widthOrigin + dx < 1) {
                        widthOrigin = 1;
                      } else {
                        widthOrigin += dx;
                      }

                      if (heightOrigin - dy < 1) {
                        heightOrigin = 1;
                      } else {
                        yPositionOrigin += dy;
                        heightOrigin -= dy;
                      }
                    });
                  },
                  onPanEnd: (update) => handleOnPanEnd,
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            child,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / intervalDivision;
                      final dy = update.delta.dy / intervalDivision;

                      if (widthOrigin - dx < 1) {
                        widthOrigin = 1;
                      } else {
                        widthOrigin -= dx;
                        xPositionOrigin += dx;
                      }
                      if (heightOrigin + dy > 1) {
                        heightOrigin += dy;
                      } else {
                        heightOrigin = 1;
                      }
                    });
                  },
                  onPanEnd: (update) => handleOnPanEnd,
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / intervalDivision;
                      final dy = update.delta.dy / intervalDivision;

                      if (widthOrigin + dx < 1) {
                        widthOrigin = 1;
                      } else {
                        widthOrigin += dx;
                      }
                      if (heightOrigin + dy < 1) {
                        heightOrigin = 1;
                      } else {
                        heightOrigin += dy;
                      }
                    });
                  },
                  onPanEnd: (update) => handleOnPanEnd,
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget rotateableContainer = Positioned(
      top: yPositionOrigin * intervalDivision,
      left: xPositionOrigin * intervalDivision,
      child: Row(
        children: [
          child,
          SizedBox(
            width: rotateBtnSpace,
          ),
          GestureDetector(
            onPanUpdate: (update) {
              setState(() {
                final diffX = rotateBtnSpace +
                    (widthOrigin * intervalDivision / 2) -
                    50 +
                    update.localPosition.dx;

                final diffY = (heightOrigin * intervalDivision / 2) +
                    update.localPosition.dy;
                double angle = atan(diffY / diffX) * 180 / pi;
                if ((diffX < 0 && diffY > 0) || (diffX < 0 && diffY < 0)) {
                  angle += 180;
                } else if (diffX > 0 && diffY < 0) {
                  angle += 360;
                }
                angleOrigin = angle;
              });
            },
            onPanEnd: (update) => handleOnPanEnd,
            child: const Icon(
              Icons.circle,
              color: Colors.lightGreen,
              size: 12,
            ),
          ),
        ],
      ),
    );

    Widget containerMode(ItemAction action) {
      switch (action) {
        case ItemAction.edit:
          return editableContainer;
        case ItemAction.scale:
          return scaleableContainer;
        case ItemAction.rotate:
          return rotateableContainer;
        case ItemAction.move:
          return moveableContainer;
        default:
          return const SizedBox();
      }
    }

    return containerMode(actionOrigin);
  }
}
