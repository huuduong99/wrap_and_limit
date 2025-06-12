/*
 * Created by huuduong99 on 2025-06-12
 * Copyright (c) 2025
 * All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:wrap_and_limit/wrap_and_limit.dart';

void main() => runApp(const MyApp());

/// The main application widget that sets up the MaterialApp and displays a list of categories
/// using the `WrapAndLimit` widget to manage layout and overflow.
class MyApp extends StatelessWidget {
  /// Constructor for `MyApp`.
  const MyApp({super.key});

  /// A static list of category names to be displayed as chips.
  static const List<String> categories = [
    "Automotive",
    "Services",
    "Home and application",
    "Beauty and Care",
    "Fashion and Apparel",
    "Technology and Electronics",
    "Health and Wellness",
    "Food and Beverages",
    "Toys and Games",
    "Books and Entertainment",
  ];

  /// Builds the widget tree for the application.
  ///
  /// Returns a `MaterialApp` with a `Scaffold` containing an `AppBar` and a `Row`
  /// with a `WrapAndLimit` widget to display the categories.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wrap and More"),
        ),
        body: Row(
          children: [
            Expanded(
              child: WrapAndLimit(
                alignment: WrapAlignment.end,
                maxRow: 4,
                spacing: 5,
                runSpacing: 5,

                /// A widget to display when there are more children than the maximum rows allowed.
                /// Shows the number of remaining children as a chip.
                overflowWidget: (restChildrenCount) {
                  return MyChip(text: "+$restChildrenCount");
                },

                /// Maps the `categories` list to a list of `MyChip` widgets.
                children: categories
                    .map(
                      (e) => MyChip(text: e),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom widget that represents a chip with a text label.
class MyChip extends StatelessWidget {
  /// The text to display inside the chip.
  final String text;

  /// Constructor for `MyChip`.
  const MyChip({
    super.key,
    required this.text,
  });

  /// Builds the widget tree for the chip.
  ///
  /// Returns a `Container` with padding, a grey background, rounded corners,
  /// and white text displaying the chip's label.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
