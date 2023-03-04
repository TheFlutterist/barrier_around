![barrier_around_header](https://user-images.githubusercontent.com/36412259/222873183-41b81ec4-90bd-4545-8a29-ab76acb5b40a.png)

# Barrier Around

[![pub package](https://img.shields.io/pub/v/barrier_around.svg)](https://pub.dev/packages/barrier_around)

A Flutter package that creates a barrier around any widget, no matter where it is.

## What problem does it solve?

Sometimes we need to highlight or showcase a specific widget, that's an easy task if the widget is a direct child of a Stack, but what if we want to create a barrier around a specific widget, which is inside, for example, a Column. We can try to calculate positions and sizes, but that can get really messy, really fast.

![View demo video](https://user-images.githubusercontent.com/36412259/222872699-232b9f01-7785-45e8-9bae-0a0ebe759300.mp4)

## Usage

To use this plugin, add `barrier_around` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Example

Create a GlobalKey in order to identify which widget you want to create the barrier around.

```dart
final GlobalKey _barrierKey = GlobalKey();
```

Wrap the widget you want to create the barrier around, and wrap it with a `BarrierAround` widget.

Assign the GlobalKey to the `BarrierAround` widget.

```dart
BarrierAround(
    key: _barrierKey,
    child: yourWidget
)
```

Whenever you want to show the barrier, just call:

```dart
BarrierAroundManager.showBarrier(_barrierKey);
```

To dismiss the barrier, just tap on it, this behavior is enabled by default. If you want the barrier to not dismiss on tap, you can set `dismissOnBarrierTap` to `false` in the `BarrierAround` widget.

If you want to dismiss the barrier from other place, just call:

```dart
BarrierAroundManager.dismissBarrier(_barrierKey);
```

### Barrier customization

| Name                | Type            | Description                                                                     | Default                       |
| ------------------- | --------------- | ------------------------------------------------------------------------------- | ----------------------------- |
| barrierBorderRadius | `BorderRadius?` | If your widget has a border radius, this is the place to put it                 | `null`                        |
| barrierColor        | `Color`         | Color of the barrier                                                            | `Colors.black45`              |
| barrierOpacity      | `double`        | Barrier opacity                                                                 | `0.75`                        |
| barrierBlur         | `double?`       | Barrier blur sigmaX and sigmaY                                                  | `null`                        |
| targetPadding       | `EdgeInsets`    | Padding around target widget                                                    | `EdgeInsets.zero`             |
| onBarrierTap        | `VoidCallback?` | Callback for the tap event on the barrier                                       | `null`                        |
| dismissOnBarrierTap | `bool`          | If barrier must dismiss when user taps on it                                    | `true`                        |
| animateBarrier      | `bool`          | If show/dismiss of the barrier is animated                                      | `true`                        |
| animationDuration   | `Duration`      | If animateBarrier is `true`, you can specify here the duration of the animation | `Duration(milliseconds: 150)` |

### Suggestions and contributions

If you have any suggestion around code improvement, bug fixes, new features, or you want to contribute in any way, feel free to raise an issue in [Github](https://github.com/FlutteristDev/barrier_around) or DM me in [Twitter](https://twitter.com/FlutteristDev).
