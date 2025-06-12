/*
 * Created by huuduong99 on 2025-06-12
 * Copyright (c) 2025
 * All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrap_and_limit/src/measure_size.dart';
import 'package:wrap_and_limit/src/wrap_and_limit_controller.dart';

/// A Flutter widget that displays a list of child widgets in a `Wrap` layout, 
/// limits the number of rows displayed to a specified maximum (`maxRow`), 
/// and shows an overflow widget when the number of children exceeds the limit.
///
/// This widget is useful for scenarios where you want to display a limited 
/// number of rows in a flexible layout and provide a visual indication of 
/// additional content that is not displayed.
///
/// ### Parameters:
///
/// - `children`: A list of widgets to display in the `Wrap` layout.
/// - `maxRow`: The maximum number of rows to display in the `Wrap`. If the 
///   number of rows exceeds this value, the overflow widget will be displayed.
/// - `spacing`: The spacing between child widgets in the `Wrap`. Defaults to `4.0`.
/// - `runSpacing`: The spacing between rows in the `Wrap`. Defaults to `4.0`.
/// - `alignment`: The alignment of child widgets within each row. Defaults to `WrapAlignment.end`.
/// - `overflowWidget`: A function that takes the count of remaining children 
///   beyond the `maxRow` and returns a widget to display as the overflow indicator.
///
/// ### Behavior:
///
/// - The widget uses a `LayoutBuilder` to measure the available width and 
///   dynamically calculate the number of children that can fit within the 
///   specified `maxRow`.
/// - If the number of children exceeds the limit, the `overflowWidget` is 
///   displayed to indicate the overflow.
/// - The widget uses a `WrapAndLimitController` to manage the layout logic 
///   and notify listeners when the layout changes.
///
/// ### Example Usage:
///
/// ```dart
/// WrapAndLimit(
///   maxRow: 2,
///   spacing: 8.0,
///   runSpacing: 8.0,
///   alignment: WrapAlignment.start,
///   children: List.generate(10, (index) => Text('Item $index')),
///   overflowWidget: (remainingCount) => Text('+$remainingCount more'),
/// )
/// ```
///
/// In this example, the widget will display up to 2 rows of items, and if 
/// there are more items, it will show a text widget indicating the number of 
/// remaining items.
/// Widget that displays a list of children in a Wrap layout,
/// limits the number of rows displayed by `maxRow`, and shows an overflow widget when exceeded.
class WrapAndLimit extends StatefulWidget {
  const WrapAndLimit({
    required this.maxRow,
    required this.overflowWidget,
    required this.children,
    this.spacing = 4.0,
    this.runSpacing = 4.0,
    this.alignment = WrapAlignment.end,
    super.key,
  });

  /// The list of child widgets to display in the Wrap.
  final List<Widget> children;

  /// The maximum number of rows to display in the Wrap.
  final int maxRow;

  /// The spacing between child widgets in the Wrap.
  final double spacing;

  /// The spacing between rows in the Wrap.
  final double runSpacing;

  /// The `overflowWidget` parameter is a function that takes an integer as input, representing the number of remaining children beyond the `maxRow`, and returns a widget to display as the "overflow" representation.
  final Widget Function(int restChildrenCount) overflowWidget;

  /// Alignment of child widgets within each row
  final WrapAlignment alignment;

  @override
  State<WrapAndLimit> createState() => _WrapAndLimitState();
}

class _WrapAndLimitState extends State<WrapAndLimit> {
  late WrapAndLimitController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  /// Check and update the controller when the widget changes
  @override
  void didUpdateWidget(covariant WrapAndLimit oldWidget) {
    if (widget.maxRow != oldWidget.maxRow ||
        widget.spacing != oldWidget.spacing ||
        widget.runSpacing != oldWidget.runSpacing ||
        widget.children.length != oldWidget.children.length) {
      _initController();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Initialize the controller
  void _initController() {
    _controller = WrapAndLimitController(
      maxRow: widget.maxRow,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      childrenCount: widget.children.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Update the maximum width
        _controller.updateMaxWidth(constraints.maxWidth);
        return ChangeNotifierProvider<WrapAndLimitController>.value(
          value: _controller,
          child: Consumer<WrapAndLimitController>(
            builder: (context, controller, child) {
              // When the number of children to display has been calculated
              if (controller.isCounted) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Wrap(
                    spacing: widget.spacing,
                    runSpacing: widget.runSpacing,
                    alignment: widget.alignment,
                    children: [
                      // Display the children that fit within maxRow
                      ...widget.children.take(controller.showChildCount),
                      // Display the overflow widget if there is overflow
                      if (controller.hasOverflow)
                        widget.overflowWidget(
                          widget.children.length - controller.showChildCount,
                        ),
                    ],
                  ),
                );
              } else {
                // Measure the size of the child widgets and the overflow widget
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    key: controller.rowKey,
                    children: [
                      ...List.generate(widget.children.length, (index) {
                        return MeasureSize(
                          onChange: (Size size) {
                            controller.updateChildrenSize(index, size);
                          },
                          child: widget.children[index],
                        );
                      }),
                      MeasureSize(
                        child: widget.overflowWidget(0),
                        onChange: (size) {
                          controller.updateOverflowSize(size);
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
