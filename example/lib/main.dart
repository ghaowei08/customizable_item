import 'package:example/box.dart';
import 'package:flutter/material.dart';
import 'package:customizable_item/customizable_item.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Example(),
      ),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  List<Box> boxs = [
    Box(
      index: 1,
      item: Item(
        xPosition: 1,
        yPosition: 1,
        width: 5,
        height: 5,
        angle: 0,
      ),
      action: ItemAction.move,
    ),
    Box(
      index: 2,
      item: Item(
        xPosition: 10,
        yPosition: 10,
        width: 4,
        height: 4,
        angle: 0,
      ),
      action: ItemAction.move,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: Stack(
        children: [
          ...boxs.map(
            (e) {
              return CustomizableItem(
                index: e.index,
                item: Item(
                  xPosition: e.item.xPosition,
                  yPosition: e.item.yPosition,
                  width: e.item.width,
                  height: e.item.height,
                  angle: e.item.angle,
                ),
                itemAction: e.action,
                ratio: 25,
                updateAction: (int i, ItemAction action) {
                  setState(() {
                    switch (action) {
                      case ItemAction.move:
                      case ItemAction.edit:
                      case ItemAction.scale:
                        boxs = boxs
                            .map(
                              (box) => box.index == i
                                  ? Box(
                                      index: box.index,
                                      action: action,
                                      item: box.item)
                                  : box,
                            )
                            .toList();
                        break;
                      case ItemAction.delete:
                        boxs = boxs.where((box) => box.index != i).toList();
                        break;
                      default:
                        break;
                    }
                  });
                },
                addItem: (item) {},
                updateItem: (item) {},
                removeItem: (item) {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "Customizable Item ${e.index}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
