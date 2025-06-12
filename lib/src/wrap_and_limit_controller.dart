/*
 * Created by huuduong99 on 2025-06-12
 * Copyright (c) 2025
 * All rights reserved.
 *
 */

import 'dart:math';

import 'package:flutter/material.dart';

/// A controller that manages the logic for displaying child widgets within a 
/// `Wrap` layout, ensuring that the number of rows does not exceed a specified 
/// maximum (`maxRow`). It calculates the number of child widgets to display, 
/// handles overflow logic, and notifies the UI when updates are required.
///
/// This controller is useful for scenarios where you need to limit the number 
/// of rows in a `Wrap` layout and display an overflow widget when the content 
/// exceeds the available space.
///
/// ### Features:
/// - Tracks the sizes of child widgets and an overflow widget.
/// - Calculates the number of child widgets that can fit within the specified 
///   maximum rows and width.
/// - Determines whether an overflow widget needs to be displayed.
/// - Notifies listeners when the layout needs to be updated.
///
/// ### Properties:
/// - `maxRow`: The maximum number of rows allowed in the `Wrap`.
/// - `spacing`: Horizontal spacing between child widgets.
/// - `runSpacing`: Vertical spacing between rows.
/// - `childrenCount`: Total number of child widgets.
/// - `rowKey`: A `GlobalKey` used for measuring the initial row.
/// - `isCounted`: Indicates whether the number of children has been calculated.
/// - `isRendered`: Indicates whether the row has been rendered for measurement.
/// - `showChildCount`: The number of child widgets to display.
/// - `hasOverflow`: Indicates whether there is overflow (i.e., the overflow 
///   widget needs to be displayed).
/// - `maxWidth`: The maximum width of the `Wrap`.
/// - `rowHeight`: The height of the current row.
///
/// ### Methods:
/// - `updateChildrenSize(int index, Size size)`: Updates the size of a specific 
///   child widget after measurement.
/// - `updateOverflowSize(Size size)`: Updates the size of the overflow widget 
///   after measurement.
/// - `updateMaxWidth(double maxWidth)`: Updates the maximum width of the `Wrap` 
///   layout.
/// - `_calculateVisibleChildren()`: Calculates the number of child widgets that 
///   can be displayed within the specified constraints and determines whether 
///   the overflow widget needs to be displayed.
///
/// ### Usage:
/// Instantiate the `WrapAndLimitController` with the required parameters, and 
/// use it to manage the layout of child widgets in a `Wrap`. Update the sizes 
/// of child widgets and the overflow widget as they are measured, and listen 
/// for changes to update the UI accordingly.
/// Controller that handles the logic for calculating the number of child widgets to display,
/// checking for overflow, and notifying the UI to update.
class WrapAndLimitController extends ChangeNotifier {
  final int maxRow;
  final double spacing;
  final double runSpacing;
  final int childrenCount;

  /// Key to measure the initial Row
  final GlobalKey rowKey = GlobalKey();

  /// List of sizes for each child widget
  late List<Size> _childrenSizes;

  /// Size of the overflow widget
  Size _overflowSize = Size.zero;

  bool _isCounted = false;
  bool _isRendered = false;
  int _showChildCount = 0;
  double rowHeight = 0;
  double _maxWidth = 0;
  bool _hasOverflow = false;

  /// Whether the number of children has been calculated
  bool get isCounted => _isCounted;

  /// Whether the Row has been rendered for measurement
  bool get isRendered => _isRendered;

  /// Number of child widgets to display
  int get showChildCount => _showChildCount;

  /// Whether there is overflow (display the overflow widget)
  bool get hasOverflow => _hasOverflow;

  /// Maximum width of the Wrap
  double get maxWidth => _maxWidth;

  WrapAndLimitController({
    required this.maxRow,
    required this.spacing,
    required this.runSpacing,
    required this.childrenCount,
  }) {
    _childrenSizes = List.filled(childrenCount, Size.zero);
  }

  /// Update the size of each child widget after measurement
  void updateChildrenSize(int index, Size size) {
    _childrenSizes[index] = size;
    _calculateVisibleChildren();
  }

  /// Update the size of the overflow widget after measurement
  void updateOverflowSize(Size size) {
    _overflowSize = size;
    _calculateVisibleChildren();
  }

  /// Update the maximum width from the LayoutBuilder
  void updateMaxWidth(double maxWidth) {
    if (_maxWidth != maxWidth) {
      _maxWidth = maxWidth;
      _calculateVisibleChildren();
    }
  }

  /// Calculate the number of child widgets that can be displayed within maxRow,
  /// and check if the overflow widget needs to be displayed.
  void _calculateVisibleChildren() {
    // Wait until all child and overflow sizes are measured
    if (_maxWidth == 0 ||
        _childrenSizes.contains(Size.zero) ||
        _overflowSize == Size.zero) {
      return;
    }

    double currentRowWidth = 0;
    int currentRow = 1;
    int count = 0;
    double maxHeightPerRow = 0;
    _hasOverflow = false;

    for (var size in _childrenSizes) {
      if (currentRow > maxRow) break;

      // If the child widget exceeds the width, move to the next row
      if (currentRowWidth + size.width > _maxWidth) {
        currentRow++;
        if (currentRow > maxRow) break;
        currentRowWidth = 0;
      }

      currentRowWidth += size.width + spacing;
      maxHeightPerRow = max(maxHeightPerRow, size.height);
      count++;
    }

    // Check the overflow widget
    if (count < childrenCount) {
      if (currentRowWidth + _overflowSize.width > _maxWidth) {
        // If the overflow widget does not fit in the current row
        if (currentRow < maxRow) {
          currentRow++;
          if (currentRow <= maxRow) {
            currentRowWidth = _overflowSize.width + spacing;
          } else {
            count--; // Move back 1 child widget to make room for overflow
          }
        } else {
          count--;
        }
      } else {
        currentRowWidth += _overflowSize.width + spacing;
      }
      _hasOverflow = true;
    }

    rowHeight = maxHeightPerRow;
    _showChildCount = count;
    _isCounted = true;
    _isRendered = true;
    notifyListeners();
  }
}
