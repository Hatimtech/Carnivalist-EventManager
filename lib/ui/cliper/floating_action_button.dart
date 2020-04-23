import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const BoxConstraints _kSizeConstraints = BoxConstraints.tightFor(
  width: 56.0,
  height: 56.0,
);

const BoxConstraints _kMiniSizeConstraints = BoxConstraints.tightFor(
  width: 40.0,
  height: 40.0,
);

const BoxConstraints _kExtendedSizeConstraints = BoxConstraints(
  minHeight: 48.0,
  maxHeight: 48.0,
);

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionButton tag>';
}

class FloatingActionButtonCustom extends StatelessWidget {
  const FloatingActionButtonCustom({
    Key key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    @required this.onPressed,
    this.mini = false,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
  })  :
        _sizeConstraints = mini ? _kMiniSizeConstraints : _kSizeConstraints,
        super(key: key);

  FloatingActionButtonCustom.extended({
    Key key,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.heroTag = const _DefaultHeroTag(),
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.splashColor,
    this.highlightElevation,
    this.disabledElevation,
    @required this.onPressed,
    this.shape,
    this.isExtended = true,
    this.materialTapTargetSize,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    Widget icon,
    @required Widget label,
  })  : _sizeConstraints = _kExtendedSizeConstraints,
        mini = false,
        child = _ChildOverflowBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: icon == null
                ? <Widget>[
                    const SizedBox(width: 20.0),
                    label,
                    const SizedBox(width: 20.0),
                  ]
                : <Widget>[
                    const SizedBox(width: 16.0),
                    icon,
                    const SizedBox(width: 8.0),
                    label,
                    const SizedBox(width: 20.0),
                  ],
          ),
        ),
        super(key: key);

  final Widget child;
  final String tooltip;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color focusColor;
  final Color hoverColor;
  final Color splashColor;
  final Object heroTag;
  final VoidCallback onPressed;
  final double elevation;
  final double focusElevation;
  final double hoverElevation;
  final double highlightElevation;
  final double disabledElevation;
  final bool mini;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final bool isExtended;
  final FocusNode focusNode;
  final bool autofocus;
  final MaterialTapTargetSize materialTapTargetSize;

  final BoxConstraints _sizeConstraints;

  static const double _defaultElevation = 6;
  static const double _defaultFocusElevation = 8;
  static const double _defaultHoverElevation = 10;
  static const double _defaultHighlightElevation = 12;
  static const ShapeBorder _defaultShape = CircleBorder();
  static const ShapeBorder _defaultExtendedShape = StadiumBorder();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FloatingActionButtonThemeData floatingActionButtonTheme =
        theme.floatingActionButtonTheme;

    final Color foregroundColor = this.foregroundColor ??
        floatingActionButtonTheme.foregroundColor ??
        theme.accentIconTheme.color ??
        theme.colorScheme.onSecondary;
    final Color backgroundColor = this.backgroundColor ??
        floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    final Color focusColor = this.focusColor ??
        floatingActionButtonTheme.focusColor ??
        theme.focusColor;
    final Color hoverColor = this.hoverColor ??
        floatingActionButtonTheme.hoverColor ??
        theme.hoverColor;
    final Color splashColor = this.splashColor ??
        floatingActionButtonTheme.splashColor ??
        theme.splashColor;
    final double elevation = this.elevation ??
        floatingActionButtonTheme.elevation ??
        _defaultElevation;
    final double focusElevation = this.focusElevation ??
        floatingActionButtonTheme.focusElevation ??
        _defaultFocusElevation;
    final double hoverElevation = this.hoverElevation ??
        floatingActionButtonTheme.hoverElevation ??
        _defaultHoverElevation;
    final double disabledElevation = this.disabledElevation ??
        floatingActionButtonTheme.disabledElevation ??
        elevation;
    final double highlightElevation = this.highlightElevation ??
        floatingActionButtonTheme.highlightElevation ??
        _defaultHighlightElevation;
    final MaterialTapTargetSize materialTapTargetSize =
        this.materialTapTargetSize ?? theme.materialTapTargetSize;
    final TextStyle textStyle = theme.accentTextTheme.button.copyWith(
      color: foregroundColor,
      letterSpacing: 1.2,
    );
    final ShapeBorder shape = this.shape ??
        floatingActionButtonTheme.shape ??
        (isExtended ? _defaultExtendedShape : _defaultShape);

    Widget result = RawMaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      constraints: _sizeConstraints,
      materialTapTargetSize: materialTapTargetSize,
      fillColor: backgroundColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      textStyle: textStyle,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      child: child,
    );

    if (tooltip != null) {
      result = Tooltip(
        message: tooltip,
        child: result,
      );
    }

    if (heroTag != null) {
      result = Hero(
        tag: heroTag,
        child: result,
      );
    }

    return MergeSemantics(child: result);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed,
        ifNull: 'disabled'));
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null));
    properties.add(
        ColorProperty('foregroundColor', foregroundColor, defaultValue: null));
    properties.add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties
        .add(ColorProperty('splashColor', splashColor, defaultValue: null));
    properties
        .add(ObjectFlagProperty<Object>('heroTag', heroTag, ifPresent: 'hero'));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(
        DoubleProperty('focusElevation', focusElevation, defaultValue: null));
    properties.add(
        DoubleProperty('hoverElevation', hoverElevation, defaultValue: null));
    properties.add(DoubleProperty('highlightElevation', highlightElevation,
        defaultValue: null));
    properties.add(DoubleProperty('disabledElevation', disabledElevation,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
    properties
        .add(FlagProperty('isExtended', value: isExtended, ifTrue: 'extended'));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', materialTapTargetSize,
        defaultValue: null));
  }
}

class _ChildOverflowBox extends SingleChildRenderObjectWidget {
  const _ChildOverflowBox({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _RenderChildOverflowBox createRenderObject(BuildContext context) {
    return _RenderChildOverflowBox(
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderChildOverflowBox renderObject) {
    renderObject..textDirection = Directionality.of(context);
  }
}

class _RenderChildOverflowBox extends RenderAligningShiftedBox {
  _RenderChildOverflowBox({
    RenderBox child,
    TextDirection textDirection,
  }) : super(
            child: child,
            alignment: Alignment.center,
            textDirection: textDirection);

  @override
  double computeMinIntrinsicWidth(double height) => 0.0;

  @override
  double computeMinIntrinsicHeight(double width) => 0.0;

  @override
  void performLayout() {
    if (child != null) {
      child.layout(const BoxConstraints(), parentUsesSize: true);
      size = Size(
        math.max(constraints.minWidth,
            math.min(constraints.maxWidth, child.size.width)),
        math.max(constraints.minHeight,
            math.min(constraints.maxHeight, child.size.height)),
      );
      alignChild();
    } else {
      size = constraints.biggest;
    }
  }
}
