import 'dart:math';
import 'package:customizable_item/customizable_item.dart';
import 'package:flutter/material.dart';

class CustomizableItem extends StatefulWidget {
  final int index;
  final Item item;
  final double ratio;
  final ItemAction itemAction;
  final Function addItem;
  final Function updateItem;
  final Function removeItem;
  final Function updateAction;
  final Widget child;

  const CustomizableItem({
    Key? key,
    required this.index,
    required this.item,
    required this.itemAction,
    this.ratio = 25,
    required this.addItem,
    required this.updateItem,
    required this.removeItem,
    required this.updateAction,
    this.child = const SizedBox(),
  }) : super(key: key);

  @override
  State<CustomizableItem> createState() => _CustomizableItemState();
}

class _CustomizableItemState extends State<CustomizableItem> {
  late int indexOrigin;
  late double ratio;
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
    heightOrigin = widget.item.height;
    widthOrigin = widget.item.width;
    xPositionOrigin = widget.item.xPosition;
    yPositionOrigin = widget.item.yPosition;
    angleOrigin = widget.item.angle;
  }

  @override
  Widget build(BuildContext context) {
    ItemAction actionOrigin = widget.itemAction;
    Widget childOrigin = widget.child;
    double ratio = widget.ratio;
    double rotateBtnSpace = 2 * ratio;

    void handleOnPanEnd() {
      widget.updateItem(Item(
        height: heightOrigin,
        width: widthOrigin,
        xPosition: xPositionOrigin,
        yPosition: yPositionOrigin,
        angle: angleOrigin,
      ));
    }

    Widget child = GestureDetector(
      onDoubleTap: () {
        widget.updateAction(indexOrigin, ItemAction.edit);
      },
      onTapDown: (update) {
        widget.updateAction(indexOrigin, ItemAction.move);
      },
      child: Transform.rotate(
        angle: angleOrigin * pi / 180,
        alignment: Alignment.center,
        child: SizedBox(
          height: heightOrigin * ratio,
          width: widthOrigin * ratio,
          child: childOrigin,
        ),
      ),
    );

    Widget editableContainer = Positioned(
        top: yPositionOrigin * ratio,
        left: xPositionOrigin * ratio,
        child: Column(
          children: [
            child,
            IconButton(
              onPressed: () {
                widget.updateAction(indexOrigin, ItemAction.rotate);
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
                widget.updateAction(indexOrigin, ItemAction.scale);
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
                widget.updateAction(indexOrigin, ItemAction.delete);
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
      top: yPositionOrigin * ratio,
      left: xPositionOrigin * ratio,
      child: GestureDetector(
        onPanUpdate: (update) {
          setState(() {
            xPositionOrigin += (update.delta.dx / ratio);
            yPositionOrigin += (update.delta.dy / ratio);
          });
        },
        onPanEnd: (update) {
          handleOnPanEnd();
        },
        child: child,
      ),
    );

    Widget scaleableContainer = Positioned(
      top: (yPositionOrigin - 0.5) * ratio,
      left: (xPositionOrigin - 0.5) * ratio,
      child: SizedBox(
        height: (heightOrigin + 1) * ratio,
        width: (widthOrigin + 1) * ratio,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / ratio;
                      final dy = update.delta.dy / ratio;

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
                  onPanEnd: (update) {
                    handleOnPanEnd();
                  },
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / ratio;
                      final dy = update.delta.dy / ratio;

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
                  onPanEnd: (update) {
                    handleOnPanEnd();
                  },
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
                      final dx = update.delta.dx / ratio;
                      final dy = update.delta.dy / ratio;

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
                  onPanEnd: (update) {
                    handleOnPanEnd();
                  },
                  child: const Icon(
                    Icons.square,
                    size: 12,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onPanUpdate: (update) {
                    setState(() {
                      final dx = update.delta.dx / ratio;
                      final dy = update.delta.dy / ratio;

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
                  onPanEnd: (update) {
                    handleOnPanEnd();
                  },
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
      top: yPositionOrigin * ratio,
      left: xPositionOrigin * ratio,
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
                    (widthOrigin * ratio / 2) -
                    50 +
                    update.localPosition.dx;

                final diffY =
                    (heightOrigin * ratio / 2) + update.localPosition.dy;
                double angle = atan(diffY / diffX) * 180 / pi;
                if ((diffX < 0 && diffY > 0) || (diffX < 0 && diffY < 0)) {
                  angle += 180;
                } else if (diffX > 0 && diffY < 0) {
                  angle += 360;
                }
                angleOrigin = angle;
              });
            },
            onPanEnd: (update) {
              handleOnPanEnd();
            },
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
          return childOrigin;
      }
    }

    return containerMode(actionOrigin);
  }
}
