# Auto Scrolling

[![Pub](https://img.shields.io/pub/v/auto_scrolling.svg)](https://pub.dev/packages/auto_scrolling)

This package provides a widget that enhances scrollable widgets by enabling auto-scrolling, a common feature in desktop and web applications.

## Features

This package supports two built-in methods to activate auto-scrolling:

**Middle Mouse Click (Press & Release)**
- Click the middle mouse button (scroll wheel) once to activate auto-scrolling.
- Move the cursor in the desired direction to scroll.
- Click any mouse button to exit auto-scrolling mode.


**Middle Mouse Click & Drag**
- Press and hold the middle mouse button (scroll wheel) to activate auto-scrolling.
- Drag the cursor in the desired direction to scroll.
- Release the middle mouse button to exit auto-scrolling mode.

## Platform Support

This is supported for all relevant platforms. However, auto scroll shouldn't be used on Mobile platforms.

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ❌    | ❌  |  ✅   | ✅  |  ✅   |   ✅    |


## Getting started

### Install

Add the package to your dependencies, see [how under `Installing`](https://pub.dev/packages/auto_scrolling/install).

### Usage

Simply wrap your scrollable such as ListView, SingleChildScrollView, etc. With the AutoScroll widget as such:

```dart
AutoScroll(
  controller: controller,
  child: ListView.builder(
    controller: controller,
    itemCount: ...,
    itemBuilder: ...,
  ),
),
```

_Notice that the `AutoScroll` widget requires the same `ScrollController` as your scrollable._

The `AutoScroll` widget only supports single direction scrolling, to enable auto scroll on a view with both horizontal and vertical scrollables, use the `MultiAxisAutoScroll` widget like this:

```dart
MultiAxisAutoScroll(
  verticalController: verticalController,
  horizontalController: horizontalController,
  child: ...,
),
```

_Notice again, that the vertical and horizontal controller should be the same as those attached to your scrollables._