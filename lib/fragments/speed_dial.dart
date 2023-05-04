import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AsyncChildrenBuilder = Future<List<SpeedDialChild>> Function(BuildContext context);

/// Builds the Speed Dial
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  /// The tooltip of this `SpeedDial`
  final String? tooltip;

  /// The hero tag used for the fab inside this `SpeedDial`
  final String? heroTag;

  /// The color of the background of this `SpeedDial`
  final Color? backgroundColor;

  /// The color of the foreground of this `SpeedDial`
  final Color? foregroundColor;

  /// The color of the background of this `SpeedDial` when it is open
  final Color? activeBackgroundColor;

  /// The color of the foreground of this `SpeedDial` when it is open
  final Color? activeForegroundColor;

  /// The intensity of the shadow for this `SpeedDial`
  final double elevation;

  /// The size for this `SpeedDial` button
  final Size buttonSize;

  /// The size for this `SpeedDial` children
  final Size childrenButtonSize;

  /// The shape of this `SpeedDial`
  final ShapeBorder shape;

  /// The gradient decoration for this `SpeedDial`
  final Gradient? gradient;

  /// The shape of the gradient decoration for this `SpeedDial`
  final BoxShape gradientBoxShape;

  /// Whether speedDial initialize with open state or not, defaults to false.
  final bool isOpenOnStart;

  /// Whether to close the dial on pop if it's open.
  final bool closeDialOnPop;

  /// The color of the background overlay.
  final Color? overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  /// This is only applied to [animatedIcon].
  final IconThemeData? animatedIconTheme;

  /// The icon of the main button, ignored if [animatedIcon] is non [null].
  final IconData? icon;

  /// The active icon of the main button, Defaults to icon if not specified, ignored if [animatedIcon] is non [null].
  final IconData? activeIcon;

  /// If true then rotation animation will be used when animating b/w activeIcon and icon.
  final bool useRotationAnimation;

  /// The angle of the iconRotation
  final double animationAngle;

  /// The theme for the icon generally includes color and size.
  /// The iconTheme is only applied to [child] and [activeChild] or [icon] and [activeIcon].
  final IconThemeData? iconTheme;

  /// The label of the main button.
  final Widget? label;

  /// The active label of the main button, Defaults to label if not specified.
  final Widget? activeLabel;

  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
  final Widget Function(Widget, Animation<double>)? labelTransitionBuilder;

  /// Repopulate children every time just before opening the dial. If you provide [onOpenBuilder]
  /// then you must also provide a non-const [children] (e.g. `children: []`) since [children] is
  /// const by default and cannot be modified.
  final AsyncChildrenBuilder? onOpenBuilder;

  /// Executed when the dial is opened.
  final VoidCallback? onOpen;

  /// Executed when the dial is closed.
  final VoidCallback? onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback? onPress;

  /// If true tapping on speed dial's children will not close the dial anymore.
  final bool closeManually;

  /// If true overlay is rendered.
  final bool renderOverlay;

  /// Open or close the dial via a notification
  final ValueNotifier<bool>? openCloseDial;

  /// The duration of the animation or the duration till which animation is played.
  final Duration animationDuration;

  /// The margin of each child
  final EdgeInsets childMargin;

  /// The padding of each child
  final EdgeInsets childPadding;

  /// Add a space at between speed dial and children
  final double? spacing;

  /// Add a space between each children
  final double? spaceBetweenChildren;

  /// The direction of the children. Default is [SpeedDialDirection.up]
  final SpeedDialDirection direction;

  /// If Provided then it will replace the default Floating Action Button
  /// and will show the Widget Specified as dialRoot instead, it will also
  /// ignore backgroundColor, foregroundColor or any other property
  /// that was specific to FAB before like onPress, you will have to provide
  /// it again to your dialRoot button.
  final Widget Function(BuildContext context, bool open, VoidCallback toggleChildren)? dialRoot;

  /// This is the child of the FAB, if specified it will ignore icon, activeIcon.
  final Widget? child;

  /// This is the active child of the FAB, if specified it will animate b/w this
  /// and the child.
  final Widget? activeChild;

  final bool switchLabelPosition;

  /// This is the animation of the child of the FAB, if specified it will animate b/w this
  final Curve? animationCurve;

  /// Use mini fab for the speed dial
  final bool mini;

  const SpeedDial({
    Key? key,
    this.children = const [],
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.gradient,
    this.gradientBoxShape = BoxShape.rectangle,
    this.elevation = 6.0,
    this.buttonSize = const Size(56.0, 56.0),
    this.childrenButtonSize = const Size(56.0, 56.0),
    this.dialRoot,
    this.mini = false,
    this.overlayOpacity = 0.8,
    this.overlayColor,
    this.tooltip,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.icon,
    this.activeIcon,
    this.child,
    this.activeChild,
    this.switchLabelPosition = false,
    this.useRotationAnimation = true,
    this.animationAngle = pi / 2,
    this.iconTheme,
    this.label,
    this.activeLabel,
    this.labelTransitionBuilder,
    this.onOpenBuilder,
    this.onOpen,
    this.onClose,
    this.direction = SpeedDialDirection.up,
    this.closeManually = false,
    this.renderOverlay = true,
    this.shape = const StadiumBorder(),
    this.curve = Curves.fastOutSlowIn,
    this.onPress,
    this.animationDuration = const Duration(milliseconds: 150),
    this.openCloseDial,
    this.isOpenOnStart = false,
    this.closeDialOnPop = true,
    this.childMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.childPadding = const EdgeInsets.symmetric(vertical: 5),
    this.spaceBetweenChildren,
    this.spacing,
    this.animationCurve,
  }) : super(key: key);

  @override
  State createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );
  bool _open = false;
  OverlayEntry? overlayEntry;
  OverlayEntry? backgroundOverlay;
  final LayerLink _layerLink = LayerLink();
  final dialKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    super.initState();
    widget.openCloseDial?.addListener(_onOpenCloseDial);
    Future.delayed(Duration.zero, () async {
      if (mounted && widget.isOpenOnStart) _toggleChildren();
    });
    _checkChildren();
  }

  @override
  void dispose() {
    if (widget.renderOverlay && backgroundOverlay != null) {
      if (backgroundOverlay!.mounted) backgroundOverlay!.remove();
      backgroundOverlay!.dispose();
    }
    if (overlayEntry != null) {
      if (overlayEntry!.mounted) overlayEntry!.remove();
      overlayEntry!.dispose();
    }
    _controller.dispose();
    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    super.dispose();
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = widget.animationDuration;
    }

    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    widget.openCloseDial?.addListener(_onOpenCloseDial);
    super.didUpdateWidget(oldWidget);
  }

  void _checkChildren() {
    if (widget.children.length > 5) {
      debugPrint(
        'Warning ! You are using more than 5 children, '
        'which is not compliant with Material design'
        ' specs.',
      );
    }
  }

  void _onOpenCloseDial() {
    final show = widget.openCloseDial?.value;
    if (!mounted) return;
    if (_open != show) {
      _toggleChildren();
    }
  }

  void _toggleChildren() async {
    if (!mounted) return;

    final opening = !_open;
    if (opening && widget.onOpenBuilder != null) {
      widget.children.clear();
      final widgets = await widget.onOpenBuilder!(context);
      widget.children.addAll(widgets);
      _checkChildren();
    }

    if (widget.children.isNotEmpty) {
      toggleOverlay();
      widget.openCloseDial?.value = opening;
      opening ? widget.onOpen?.call() : widget.onClose?.call();
    } else {
      widget.onOpen?.call();
    }
  }

  toggleOverlay() {
    if (_open) {
      _controller.reverse().whenComplete(() {
        overlayEntry?.remove();
        if (widget.renderOverlay && backgroundOverlay != null && backgroundOverlay!.mounted) {
          backgroundOverlay?.remove();
        }
      });
    } else {
      if (_controller.isAnimating) {
        // overlayEntry?.remove();
        // backgroundOverlay?.remove();
        return;
      }
      overlayEntry = OverlayEntry(
        builder: (ctx) => _ChildrensOverlay(
          widget: widget,
          dialKey: dialKey,
          layerLink: _layerLink,
          controller: _controller,
          toggleChildren: _toggleChildren,
          animationCurve: widget.animationCurve,
        ),
      );
      if (widget.renderOverlay) {
        backgroundOverlay = OverlayEntry(
          builder: (ctx) {
            bool dark = Theme.of(ctx).brightness == Brightness.dark;
            return BackgroundOverlay(
              dialKey: dialKey,
              layerLink: _layerLink,
              closeManually: widget.closeManually,
              tooltip: widget.tooltip,
              shape: widget.shape,
              onTap: _toggleChildren,
              // (_open && !widget.closeManually) ? _toggleChildren : null,
              animation: _controller,
              color: widget.overlayColor ?? (dark ? Colors.grey[900] : Colors.white)!,
              opacity: widget.overlayOpacity,
            );
          },
        );
      }

      if (!mounted) return;

      _controller.forward();
      if (widget.renderOverlay) Overlay.of(context).insert(backgroundOverlay!);
      Overlay.of(context).insert(overlayEntry!);
    }

    if (!mounted) return;
    setState(() {
      _open = !_open;
    });
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? Container(
            decoration: BoxDecoration(
              shape: widget.gradientBoxShape,
              gradient: widget.gradient,
            ),
            child: Center(
              child: AnimatedIcon(
                icon: widget.animatedIcon!,
                progress: _controller,
                color: widget.animatedIconTheme?.color,
                size: widget.animatedIconTheme?.size,
              ),
            ),
          )
        : AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) => Transform.rotate(
              angle: (widget.activeChild != null || widget.activeIcon != null) &&
                      widget.useRotationAnimation
                  ? _controller.value * widget.animationAngle
                  : 0,
              child: AnimatedSwitcher(
                  duration: widget.animationDuration,
                  child: (widget.child != null && _controller.value < 0.4)
                      ? widget.child
                      : (widget.activeIcon == null && widget.activeChild == null ||
                              _controller.value < 0.4)
                          ? Container(
                              decoration: BoxDecoration(
                                shape: widget.gradientBoxShape,
                                gradient: widget.gradient,
                              ),
                              child: Center(
                                child: widget.icon != null
                                    ? Icon(
                                        widget.icon,
                                        key: const ValueKey<int>(0),
                                        color: widget.iconTheme?.color,
                                        size: widget.iconTheme?.size,
                                      )
                                    : widget.child,
                              ),
                            )
                          : Transform.rotate(
                              angle: widget.useRotationAnimation ? -pi * 1 / 2 : 0,
                              child: widget.activeChild ??
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: widget.gradientBoxShape,
                                      gradient: widget.gradient,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        widget.activeIcon,
                                        key: const ValueKey<int>(1),
                                        color: widget.iconTheme?.color,
                                        size: widget.iconTheme?.size,
                                      ),
                                    ),
                                  ),
                            )),
            ),
          );

    var label = AnimatedSwitcher(
      duration: widget.animationDuration,
      transitionBuilder: widget.labelTransitionBuilder ??
          (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
      child: (!_open || widget.activeLabel == null) ? widget.label : widget.activeLabel,
    );

    final backgroundColorTween = ColorTween(
        begin: widget.backgroundColor, end: widget.activeBackgroundColor ?? widget.backgroundColor);
    final foregroundColorTween = ColorTween(
        begin: widget.foregroundColor, end: widget.activeForegroundColor ?? widget.foregroundColor);

    var animatedFloatingButton = AnimatedBuilder(
      animation: _controller,
      builder: (context, ch) => CompositedTransformTarget(
          link: _layerLink,
          key: dialKey,
          child: AnimatedFloatingButton(
            visible: widget.visible,
            tooltip: widget.tooltip,
            mini: widget.mini,
            dialRoot:
                widget.dialRoot != null ? widget.dialRoot!(context, _open, _toggleChildren) : null,
            backgroundColor: widget.backgroundColor != null
                ? backgroundColorTween.lerp(_controller.value)
                : null,
            foregroundColor: widget.foregroundColor != null
                ? foregroundColorTween.lerp(_controller.value)
                : null,
            elevation: widget.elevation,
            onLongPress: _toggleChildren,
            callback: (_open || widget.onPress == null) ? _toggleChildren : widget.onPress,
            size: widget.buttonSize,
            label: widget.label != null ? label : null,
            heroTag: widget.heroTag,
            shape: widget.shape,
            child: child,
          )),
    );

    return animatedFloatingButton;
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb || !Platform.isIOS) && widget.closeDialOnPop
        ? WillPopScope(
            child: _renderButton(),
            onWillPop: () async {
              if (_open) {
                _toggleChildren();
                return false;
              }
              return true;
            },
          )
        : _renderButton();
  }
}

class _ChildrensOverlay extends StatelessWidget {
  const _ChildrensOverlay({
    Key? key,
    required this.widget,
    required this.layerLink,
    required this.dialKey,
    required this.controller,
    required this.toggleChildren,
    this.animationCurve,
  }) : super(key: key);

  final SpeedDial widget;
  final GlobalKey<State<StatefulWidget>> dialKey;
  final LayerLink layerLink;
  final AnimationController controller;
  final Function toggleChildren;
  final Curve? animationCurve;

  List<Widget> _getChildrenList() {
    return widget.children
        .map((SpeedDialChild child) {
          int index = widget.children.indexOf(child);

          return AnimatedChild(
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  index / widget.children.length,
                  1.0,
                  curve: widget.animationCurve ?? Curves.ease,
                ),
              ),
            ),
            index: index,
            margin: widget.spaceBetweenChildren != null
                ? EdgeInsets.fromLTRB(
                    widget.direction.isRight ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isDown ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isLeft ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isUp ? widget.spaceBetweenChildren! : 0,
                  )
                : null,
            btnKey: child.key,
            useColumn: widget.direction.isLeft || widget.direction.isRight,
            visible: child.visible,
            switchLabelPosition: widget.switchLabelPosition,
            backgroundColor: child.backgroundColor,
            foregroundColor: child.foregroundColor,
            elevation: child.elevation,
            buttonSize: widget.childrenButtonSize,
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            labelShadow: child.labelShadow,
            onTap: child.onTap,
            onLongPress: child.onLongPress,
            toggleChildren: () {
              if (!widget.closeManually) toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null ? '${widget.heroTag}-child-$index' : null,
            childMargin: widget.childMargin,
            childPadding: widget.childPadding,
            child: child.child,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            child: CompositedTransformFollower(
          followerAnchor: widget.direction.isDown
              ? widget.switchLabelPosition
                  ? Alignment.topLeft
                  : Alignment.topRight
              : widget.direction.isUp
                  ? widget.switchLabelPosition
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight
                  : widget.direction.isLeft
                      ? Alignment.centerRight
                      : widget.direction.isRight
                          ? Alignment.centerLeft
                          : Alignment.center,
          offset: widget.direction.isDown
              ? Offset(
                  (widget.switchLabelPosition || dialKey.globalPaintBounds == null
                          ? 0
                          : dialKey.globalPaintBounds!.size.width) +
                      max(widget.childrenButtonSize.height - 56, 0) / 2,
                  dialKey.globalPaintBounds!.size.height)
              : widget.direction.isUp
                  ? Offset(
                      (widget.switchLabelPosition || dialKey.globalPaintBounds == null
                              ? 0
                              : dialKey.globalPaintBounds!.size.width) +
                          max(widget.childrenButtonSize.width - 56, 0) / 2,
                      0)
                  : widget.direction.isLeft
                      ? Offset(
                          -10.0,
                          dialKey.globalPaintBounds == null
                              ? 0
                              : dialKey.globalPaintBounds!.size.height / 2)
                      : widget.direction.isRight && dialKey.globalPaintBounds != null
                          ? Offset(dialKey.globalPaintBounds!.size.width + 12,
                              dialKey.globalPaintBounds!.size.height / 2)
                          : const Offset(-10.0, 0.0),
          link: layerLink,
          showWhenUnlinked: false,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.direction.isUp || widget.direction.isDown
                    ? max(widget.buttonSize.width - 56, 0) / 2
                    : 0,
              ),
              margin: widget.spacing != null
                  ? EdgeInsets.fromLTRB(
                      widget.direction.isRight ? widget.spacing! : 0,
                      widget.direction.isDown ? widget.spacing! : 0,
                      widget.direction.isLeft ? widget.spacing! : 0,
                      widget.direction.isUp ? widget.spacing! : 0,
                    )
                  : null,
              child: _buildColumnOrRow(
                widget.direction.isUp || widget.direction.isDown,
                crossAxisAlignment:
                    widget.switchLabelPosition ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: widget.direction.isDown || widget.direction.isRight
                    ? _getChildrenList().reversed.toList()
                    : _getChildrenList(),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

Widget _buildColumnOrRow(bool isColumn,
    {CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    required List<Widget> children,
    MainAxisSize? mainAxisSize}) {
  return isColumn
      ? Column(
          mainAxisSize: mainAxisSize ?? MainAxisSize.max,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: children,
        )
      : Row(
          mainAxisSize: mainAxisSize ?? MainAxisSize.max,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: children,
        );
}

class AnimatedChild extends AnimatedWidget {
  final int? index;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Size buttonSize;
  final Widget? child;
  final List<BoxShadow>? labelShadow;
  final Key? btnKey;

  final String? label;
  final TextStyle? labelStyle;
  final Color? labelBackgroundColor;
  final Widget? labelWidget;

  final bool visible;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? toggleChildren;
  final ShapeBorder? shape;
  final String? heroTag;
  final bool useColumn;
  final bool switchLabelPosition;
  final EdgeInsets? margin;

  final EdgeInsets childMargin;
  final EdgeInsets childPadding;

  const AnimatedChild({
    Key? key,
    this.btnKey,
    required Animation<double> animation,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.buttonSize = const Size(56.0, 56.0),
    this.child,
    this.label,
    this.labelStyle,
    this.labelShadow,
    this.labelBackgroundColor,
    this.labelWidget,
    this.visible = true,
    this.onTap,
    required this.switchLabelPosition,
    required this.useColumn,
    required this.margin,
    this.onLongPress,
    this.toggleChildren,
    this.shape,
    this.heroTag,
    required this.childMargin,
    required this.childPadding,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    bool dark = Theme.of(context).brightness == Brightness.dark;

    void performAction([bool isLong = false]) {
      if (onTap != null && !isLong) {
        onTap!();
      } else if (onLongPress != null && isLong) {
        onLongPress!();
      }
      toggleChildren!();
    }

    Widget buildLabel() {
      if (label == null && labelWidget == null) return Container();

      if (labelWidget != null) {
        return GestureDetector(
          onTap: performAction,
          onLongPress: onLongPress == null ? null : () => performAction(true),
          child: labelWidget,
        );
      }

      const borderRadius = BorderRadius.all(Radius.circular(6.0));
      return Padding(
        padding: childMargin,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: labelBackgroundColor ?? (dark ? Colors.grey[800] : Colors.grey[50]),
            borderRadius: borderRadius,
            boxShadow: labelShadow ??
                [
                  BoxShadow(
                    color: dark ? Colors.grey[900]!.withOpacity(0.7) : Colors.grey.withOpacity(0.7),
                    offset: const Offset(0.8, 0.8),
                    blurRadius: 2.4,
                  ),
                ],
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: borderRadius,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: performAction,
              onLongPress: onLongPress == null ? null : () => performAction(true),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 8.0,
                ),
                child: Text(label!, style: labelStyle),
              ),
            ),
          ),
        ),
      );
    }

    Widget button = ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          key: btnKey,
          heroTag: heroTag,
          onPressed: performAction,
          backgroundColor: backgroundColor ?? (dark ? Colors.grey[800] : Colors.grey[50]),
          foregroundColor: foregroundColor ?? (dark ? Colors.white : Colors.black),
          elevation: elevation ?? 6.0,
          shape: shape,
          child: child,
        ));

    List<Widget> children = [
      if (label != null || labelWidget != null)
        ScaleTransition(
          scale: animation,
          child: Container(
            padding: (child == null) ? const EdgeInsets.symmetric(vertical: 8) : null,
            key: (child == null) ? btnKey : null,
            child: buildLabel(),
          ),
        ),
      if (child != null)
        Container(
          padding: childPadding,
          height: buttonSize.height,
          width: buttonSize.width,
          child: (onLongPress == null)
              ? button
              : FittedBox(
                  child: GestureDetector(
                    onLongPress: () => performAction(true),
                    child: button,
                  ),
                ),
        )
    ];

    Widget buildColumnOrRow(bool isColumn,
        {CrossAxisAlignment? crossAxisAlignment,
        MainAxisAlignment? mainAxisAlignment,
        required List<Widget> children,
        MainAxisSize? mainAxisSize}) {
      return isColumn
          ? Column(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            )
          : Row(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            );
    }

    return visible
        ? Container(
            margin: margin,
            child: buildColumnOrRow(
              useColumn,
              mainAxisSize: MainAxisSize.min,
              children: switchLabelPosition ? children.reversed.toList() : children,
            ),
          )
        : Container();
  }
}

class AnimatedFloatingButton extends StatefulWidget {
  final bool visible;
  final VoidCallback? callback;
  final VoidCallback? onLongPress;
  final Widget? label;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final String? heroTag;
  final double elevation;
  final Size size;
  final ShapeBorder shape;
  final Curve curve;
  final Widget? dialRoot;
  final bool useInkWell;
  final bool mini;

  const AnimatedFloatingButton({
    Key? key,
    this.visible = true,
    this.callback,
    this.label,
    required this.mini,
    this.child,
    this.dialRoot,
    this.useInkWell = false,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
    this.elevation = 6.0,
    this.size = const Size(56.0, 56.0),
    this.shape = const CircleBorder(),
    this.curve = Curves.fastOutSlowIn,
    this.onLongPress,
  }) : super(key: key);

  @override
  State createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.dialRoot == null
        ? AnimatedContainer(
            curve: widget.curve,
            duration: const Duration(milliseconds: 150),
            height: widget.visible
                ? widget.mini
                    ? 40
                    : widget.size.height
                : 0,
            child: FittedBox(
              child: GestureDetector(
                onLongPress: widget.onLongPress,
                child: widget.label != null
                    ? FloatingActionButton.extended(
                        icon: widget.visible ? widget.child : null,
                        label: widget.visible ? widget.label! : const SizedBox.shrink(),
                        shape: widget.shape is CircleBorder ? const StadiumBorder() : widget.shape,
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: widget.foregroundColor,
                        onPressed: widget.callback,
                        tooltip: widget.tooltip,
                        heroTag: widget.heroTag,
                        elevation: widget.elevation,
                        highlightElevation: widget.elevation,
                      )
                    : FloatingActionButton(
                        mini: widget.mini,
                        shape: widget.shape,
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: widget.foregroundColor,
                        onPressed: widget.callback,
                        tooltip: widget.tooltip,
                        heroTag: widget.heroTag,
                        elevation: widget.elevation,
                        highlightElevation: widget.elevation,
                        child: widget.visible ? widget.child : null,
                      ),
              ),
            ),
          )
        : AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: widget.curve,
            child: Container(
              child: widget.visible ? widget.dialRoot : const SizedBox(height: 0, width: 0),
            ),
          );
  }
}

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final GlobalKey dialKey;
  final LayerLink layerLink;
  final ShapeBorder shape;
  final VoidCallback? onTap;
  final bool closeManually;
  final String? tooltip;

  const BackgroundOverlay({
    Key? key,
    this.onTap,
    required this.shape,
    required Animation<double> animation,
    required this.dialKey,
    required this.layerLink,
    required this.closeManually,
    required this.tooltip,
    this.color = Colors.white,
    this.opacity = 0.7,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return ColorFiltered(
        colorFilter:
            ColorFilter.mode(color.withOpacity(opacity * animation.value), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: closeManually ? null : onTap,
              child: Container(
                decoration: BoxDecoration(color: color, backgroundBlendMode: BlendMode.dstOut),
              ),
            ),
            Positioned(
              width: dialKey.globalPaintBounds?.size.width,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: () {
                    final Widget child = GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: dialKey.globalPaintBounds?.size.width,
                        height: dialKey.globalPaintBounds?.size.height,
                        decoration: ShapeDecoration(
                          shape: shape == const CircleBorder() ? const StadiumBorder() : shape,
                          color: Colors.white,
                        ),
                      ),
                    );
                    return tooltip != null && tooltip!.isNotEmpty
                        ? Tooltip(
                            message: tooltip!,
                            child: child,
                          )
                        : child;
                  }(),
                ),
              ),
            ),
          ],
        ));
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null) {
      return renderObject!.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }

  Offset get offset {
    RenderBox renderObject = currentContext?.findRenderObject() as RenderBox;
    return renderObject.localToGlobal(Offset.zero);
  }
}

/// Provides data for a speed dial child
class SpeedDialChild {
  /// The key of the speed dial child.
  final Key? key;

  /// The label to render to the left of the button
  final String? label;

  /// The Shadow for [label] String
  final List<BoxShadow>? labelShadow;

  /// The style of the label
  final TextStyle? labelStyle;

  /// The background color of the label
  final Color? labelBackgroundColor;

  /// If this is provided it will replace the default widget, therefore [label],
  /// [labelStyle] and [labelBackgroundColor] should be null
  final Widget? labelWidget;

  /// The child widget for this `SpeedDialChild`
  final Widget? child;

  /// The color of the background of this `SpeedDialChild`
  final Color? backgroundColor;

  /// The color of the foreground of this `SpeedDialChild`
  final Color? foregroundColor;

  /// The intensity of the shadow for this `SpeedDialChild`
  final double? elevation;

  /// The action that is performed after tapping this `SpeedDialChild`
  final VoidCallback? onTap;

  /// The action that is performed after long pressing this `SpeedDialChild`
  final VoidCallback? onLongPress;

  /// The shape of this `SpeedDialChild`
  final ShapeBorder? shape;

  /// Whether this `SpeedDialChild` is visible or not
  final bool visible;

  SpeedDialChild({
    this.key,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.labelShadow,
    this.child,
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.onLongPress,
    this.shape,
  });
}

enum SpeedDialDirection {
  up,
  down,
  left,
  right;
}

extension EnumExtension on SpeedDialDirection {
  bool get isDown => this == SpeedDialDirection.down;

  bool get isUp => this == SpeedDialDirection.up;

  bool get isLeft => this == SpeedDialDirection.left;

  bool get isRight => this == SpeedDialDirection.right;
}
