/// An enumeration which represents the direction of the auto scrolling.
///
/// This enumeration is used to determine which cursor to display,
/// when auto scrolling is engaged.
///
enum AutoScrollDirection {
  /// No scrolling
  none,

  /// Scrolling upwards
  up,

  /// Scrolling upwards and right
  upAndRight,

  /// Scrolling upwards and left
  upAndLeft,

  /// Scrolling downwards
  down,

  /// Scrolling downwards and right
  downAndRight,

  /// Scrolling downwards and left
  downAndLeft,

  /// Scrolling right
  right,

  /// Scrolling left
  left;
}
