<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# wrap_and_limit

The wrap_and_limit library provides a custom Flutter widget called WrapAndLimit that allows you to display child widgets within a Wrap layout and handle cases where the number of children exceeds a specified maximum row count.

The `WrapAndLimit` widget lays out its children in a Wrap widget and
displays the specified `overflowWidget` when the children exceed the
maximum number of rows specified by the `maxRow` parameter. The number
of children to display is automatically determined based on the available
space within the Wrap.

You can use this widget to achieve:

- Limiting the number of rows
- Get the count of the remaining children

## Features

![example_image_1.png](https://raw.githubusercontent.com/huuduong99/wrap_and_limit/refs/heads/master/example_image_1.png)
![example_image_2.png](https://raw.githubusercontent.com/huuduong99/wrap_and_limit/refs/heads/master/example_image_2.png)
![example_image_3.png](https://raw.githubusercontent.com/huuduong99/wrap_and_limit/refs/heads/master/example_image_3.png)

## Getting started

In your flutter project `pubspec.yaml` add the dependency:

```yaml
dependencies:

  wrap_and_limit: ^[version]
```

## Usage
Now in your Dart code, you can use:

```dart
import 'package:wrap_and_limit/wrap_and_limit.dart';
```

Add `WrapAndLimit` in your `build` method.

```dart
WrapAndLimit(
   maxRow: 2,
   spacing: 8.0,
   runSpacing: 8.0,
   overflowWidget: (restChildrenCount) {
     return Text(
       '+ $restChildrenCount more',
       style: TextStyle(color: Colors.grey),
     );
   },
   children: [
     // Add your widgets here
   ],
 )
```

Full example:

```dart
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
          title: const Text("Wrap and Limit"),
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

```

## Important parameters and explanation

|Parameter|Explanation|
|-----|-----|
|key|Key for `WrapAndLimit`, used to call `WrapAndLimitState`|
|children| The list of child widgets to display in the Wrap.|
|maxRow| The maximum number of rows to display in the Wrap.|
|spacing|The spacing between child widgets in the Wrap.|
|runSpacing|The spacing between rows in the Wrap.|
|overflowWidget|The `overflowWidget` parameter is a function that takes an integer as input, representing the number of remaining children beyond the `maxRow`, and returns a widget to display as the "overflow" representation.|
|alignment|Alignment of child widgets within each row|



## Issue

Please file any issues, bugs or feature requests as an issue on our GitHub page.