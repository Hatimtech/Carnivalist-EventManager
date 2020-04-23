import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'flushbar_route.dart' as route;

const String FLUSHBAR_ROUTE_NAME = "/flushbarRoute";

typedef void FlushbarStatusCallback(FlushbarStatus status);
typedef void OnTap(Flushbar flushbar);

class Flushbar<T extends Object> extends StatefulWidget {
  Flushbar(
      {Key key,
      String title,
      String message,
      Widget titleText,
      Widget messageText,
      Widget icon,
      bool shouldIconPulse = true,
      double maxWidth,
      EdgeInsets margin = const EdgeInsets.all(0.0),
      EdgeInsets padding = const EdgeInsets.all(16),
      double borderRadius = 0.0,
      Color borderColor,
      double borderWidth = 1.0,
      Color backgroundColor = const Color(0xFF303030),
      Color leftBarIndicatorColor,
      List<BoxShadow> boxShadows,
      Gradient backgroundGradient,
      FlatButton mainButton,
      OnTap onTap,
      Duration duration,
      bool isDismissible = true,
      FlushbarDismissDirection dismissDirection =
          FlushbarDismissDirection.VERTICAL,
      bool showProgressIndicator = false,
      AnimationController progressIndicatorController,
      Color progressIndicatorBackgroundColor,
      Animation<Color> progressIndicatorValueColor,
      FlushbarPosition flushbarPosition = FlushbarPosition.BOTTOM,
      FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
      Curve forwardAnimationCurve = Curves.easeOutCirc,
      Curve reverseAnimationCurve = Curves.easeOutCirc,
      Duration animationDuration = const Duration(seconds: 1),
      FlushbarStatusCallback onStatusChanged,
      double barBlur = 0.0,
      double overlayBlur = 0.0,
      Color overlayColor = Colors.transparent,
      Form userInputForm})
      : this.title = title,
        this.message = message,
        this.titleText = titleText,
        this.messageText = messageText,
        this.icon = icon,
        this.shouldIconPulse = shouldIconPulse,
        this.maxWidth = maxWidth,
        this.margin = margin,
        this.padding = padding,
        this.borderRadius = borderRadius,
        this.borderColor = borderColor,
        this.borderWidth = borderWidth,
        this.backgroundColor = backgroundColor,
        this.leftBarIndicatorColor = leftBarIndicatorColor,
        this.boxShadows = boxShadows,
        this.backgroundGradient = backgroundGradient,
        this.mainButton = mainButton,
        this.onTap = onTap,
        this.duration = duration,
        this.isDismissible = isDismissible,
        this.dismissDirection = dismissDirection,
        this.showProgressIndicator = showProgressIndicator,
        this.progressIndicatorController = progressIndicatorController,
        this.progressIndicatorBackgroundColor =
            progressIndicatorBackgroundColor,
        this.progressIndicatorValueColor = progressIndicatorValueColor,
        this.flushbarPosition = flushbarPosition,
        this.flushbarStyle = flushbarStyle,
        this.forwardAnimationCurve = forwardAnimationCurve,
        this.reverseAnimationCurve = reverseAnimationCurve,
        this.animationDuration = animationDuration,
        this.barBlur = barBlur,
        this.overlayBlur = overlayBlur,
        this.overlayColor = overlayColor,
        this.userInputForm = userInputForm,
        super(key: key) {
    this.onStatusChanged = onStatusChanged ?? (status) {};
  }

  FlushbarStatusCallback onStatusChanged;

  final String title;

  final String message;

  final Widget titleText;

  final Widget messageText;

  final Color backgroundColor;

  final Color leftBarIndicatorColor;

  final List<BoxShadow> boxShadows;

  final Gradient backgroundGradient;

  final Widget icon;

  final bool shouldIconPulse;

  final FlatButton mainButton;

  final OnTap onTap;

  final Duration duration;

  final bool showProgressIndicator;

  final AnimationController progressIndicatorController;

  final Color progressIndicatorBackgroundColor;

  final Animation<Color> progressIndicatorValueColor;

  final bool isDismissible;

  final double maxWidth;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final double borderRadius;

  final Color borderColor;

  final double borderWidth;

  final FlushbarPosition flushbarPosition;

  final FlushbarDismissDirection dismissDirection;

  final FlushbarStyle flushbarStyle;

  final Curve forwardAnimationCurve;

  final Curve reverseAnimationCurve;

  final Duration animationDuration;

  final double barBlur;

  final double overlayBlur;

  final Color overlayColor;

  final Form userInputForm;

  route.FlushbarRoute<T> _flushbarRoute;

  Future<T> show(BuildContext context) async {
    _flushbarRoute = route.showFlushbar<T>(
      context: context,
      flushbar: this,
    );

    return await Navigator.of(context, rootNavigator: false)
        .push(_flushbarRoute);
  }

  Future<T> dismiss([T result]) async {
    if (_flushbarRoute == null) {
      return null;
    }

    if (_flushbarRoute.isCurrent) {
      _flushbarRoute.navigator.pop(result);
      return _flushbarRoute.completed;
    } else if (_flushbarRoute.isActive) {
      _flushbarRoute.navigator.removeRoute(_flushbarRoute);
    }

    return null;
  }

  bool isShowing() {
    return _flushbarRoute?.currentStatus == FlushbarStatus.SHOWING;
  }

  bool isDismissed() {
    return _flushbarRoute?.currentStatus == FlushbarStatus.DISMISSED;
  }

  @override
  State createState() {
    return _FlushbarState<T>();
  }
}

class _FlushbarState<K extends Object> extends State<Flushbar>
    with TickerProviderStateMixin {
  FlushbarStatus currentStatus;

  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  final Widget _emptyWidget = SizedBox(width: 0.0, height: 0.0);
  final double _initialOpacity = 1.0;
  final double _finalOpacity = 0.4;

  final Duration _pulseAnimationDuration = Duration(seconds: 1);

  bool _isTitlePresent;
  double _messageTopMargin;

  FocusScopeNode _focusNode;
  FocusAttachment _focusAttachment;

  @override
  void initState() {
    super.initState();
    _isTitlePresent = (widget.title != null || widget.titleText != null);
    _messageTopMargin = _isTitlePresent ? 6.0 : widget.padding.top;

    _configureLeftBarFuture();
    _configureProgressIndicatorAnimation();

    if (widget.icon != null && widget.shouldIconPulse) {
      _configurePulseAnimation();
      _fadeController?.forward();
    }

    _focusNode = FocusScopeNode();
    _focusAttachment = _focusNode.attach(context);
  }

  @override
  void dispose() {
    _fadeController?.dispose();

    widget.progressIndicatorController?.removeListener(_progressListener);
    widget.progressIndicatorController?.dispose();

    _focusAttachment.detach();
    _focusNode.dispose();
    super.dispose();
  }

  final Completer<Size> _boxHeightCompleter = Completer<Size>();

  void _configureLeftBarFuture() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final keyContext = backgroundBoxKey.currentContext;

        if (keyContext != null) {
          final RenderBox box = keyContext.findRenderObject();
          _boxHeightCompleter.complete(box.size);
        }
      },
    );
  }

  void _configurePulseAnimation() {
    _fadeController =
        AnimationController(vsync: this, duration: _pulseAnimationDuration);
    _fadeAnimation = Tween(begin: _initialOpacity, end: _finalOpacity).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.linear,
      ),
    );

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _fadeController.forward();
      }
    });

    _fadeController.forward();
  }

  Function _progressListener;

  void _configureProgressIndicatorAnimation() {
    if (widget.showProgressIndicator &&
        widget.progressIndicatorController != null) {
      _progressListener = () {
        setState(() {});
      };
      widget.progressIndicatorController.addListener(_progressListener);

      _progressAnimation = CurvedAnimation(
          curve: Curves.linear, parent: widget.progressIndicatorController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1.0,
      child: Material(
        color: widget.flushbarStyle == FlushbarStyle.FLOATING
            ? Colors.transparent
            : widget.backgroundColor,
        child: SafeArea(
          minimum: widget.flushbarPosition == FlushbarPosition.BOTTOM
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)
              : EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
          bottom: widget.flushbarPosition == FlushbarPosition.BOTTOM,
          top: widget.flushbarPosition == FlushbarPosition.TOP,
          left: false,
          right: false,
          child: _getFlushbar(),
        ),
      ),
    );
  }

  Widget _getFlushbar() {
    Widget flushbar;

    if (widget.userInputForm != null) {
      flushbar = _generateInputFlushbar();
    } else {
      flushbar = _generateFlushbar();
    }

    return Stack(
      children: [
        FutureBuilder(
          future: _boxHeightCompleter.future,
          builder: (context, AsyncSnapshot<Size> snapshot) {
            if (snapshot.hasData) {
              return ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: widget.barBlur, sigmaY: widget.barBlur),
                  child: Container(
                    height: snapshot.data.height,
                    width: snapshot.data.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
              );
            } else {
              return _emptyWidget;
            }
          },
        ),
        flushbar,
      ],
    );
  }

  Widget _generateInputFlushbar() {
    return Container(
      key: backgroundBoxKey,
      constraints: widget.maxWidth != null
          ? BoxConstraints(maxWidth: widget.maxWidth)
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: widget.boxShadows,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor, width: widget.borderWidth)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
        child: FocusScope(
          child: widget.userInputForm,
          node: _focusNode,
          autofocus: true,
        ),
      ),
    );
  }

  CurvedAnimation _progressAnimation;
  GlobalKey backgroundBoxKey = GlobalKey();

  Widget _generateFlushbar() {
    return Container(
      key: backgroundBoxKey,
      constraints: widget.maxWidth != null
          ? BoxConstraints(maxWidth: widget.maxWidth)
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: widget.boxShadows,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor, width: widget.borderWidth)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showProgressIndicator
              ? LinearProgressIndicator(
                  value: widget.progressIndicatorController != null
                      ? _progressAnimation.value
                      : null,
                  backgroundColor: widget.progressIndicatorBackgroundColor,
                  valueColor: widget.progressIndicatorValueColor,
                )
              : _emptyWidget,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: _getAppropriateRowLayout(),
          ),
        ],
      ),
    );
  }

  List<Widget> _getAppropriateRowLayout() {
    double buttonRightPadding;
    double iconPadding = 0;
    if (widget.padding.right - 12 < 0) {
      buttonRightPadding = 4;
    } else {
      buttonRightPadding = widget.padding.right - 12;
    }

    if (widget.padding.left > 16.0) {
      iconPadding = widget.padding.left;
    }

    if (widget.icon == null && widget.mainButton == null) {
      return [
        _buildLeftBarIndicator(),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: widget.padding.top,
                        left: widget.padding.left,
                        right: widget.padding.right,
                      ),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              Padding(
                padding: EdgeInsets.only(
                  top: _messageTopMargin,
                  left: widget.padding.left,
                  right: widget.padding.right,
                  bottom: widget.padding.bottom,
                ),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
      ];
    } else if (widget.icon != null && widget.mainButton == null) {
      return <Widget>[
        _buildLeftBarIndicator(),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 42.0 + iconPadding),
          child: _getIcon(),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: widget.padding.top,
                        left: 4.0,
                        right: widget.padding.left,
                      ),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              Padding(
                padding: EdgeInsets.only(
                  top: _messageTopMargin,
                  left: 4.0,
                  right: widget.padding.right,
                  bottom: widget.padding.bottom,
                ),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
      ];
    } else if (widget.icon == null && widget.mainButton != null) {
      return <Widget>[
        _buildLeftBarIndicator(),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: widget.padding.top,
                        left: widget.padding.left,
                        right: widget.padding.right,
                      ),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              Padding(
                padding: EdgeInsets.only(
                  top: _messageTopMargin,
                  left: widget.padding.left,
                  right: 8.0,
                  bottom: widget.padding.bottom,
                ),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: buttonRightPadding),
          child: _getMainActionButton(),
        ),
      ];
    } else {
      return <Widget>[
        _buildLeftBarIndicator(),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 42.0 + iconPadding),
          child: _getIcon(),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: widget.padding.top,
                        left: 4.0,
                        right: 8.0,
                      ),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              Padding(
                padding: EdgeInsets.only(
                  top: _messageTopMargin,
                  left: 4.0,
                  right: 8.0,
                  bottom: widget.padding.bottom,
                ),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
        Padding(
              padding: EdgeInsets.only(right: buttonRightPadding),
              child: _getMainActionButton(),
            ) ??
            _emptyWidget,
      ];
    }
  }

  Widget _buildLeftBarIndicator() {
    if (widget.leftBarIndicatorColor != null) {
      return FutureBuilder(
        future: _boxHeightCompleter.future,
        builder: (BuildContext buildContext, AsyncSnapshot<Size> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: widget.leftBarIndicatorColor,
              width: 5.0,
              height: snapshot.data.height,
            );
          } else {
            return _emptyWidget;
          }
        },
      );
    } else {
      return _emptyWidget;
    }
  }

  Widget _getIcon() {
    if (widget.icon != null && widget.icon is Icon && widget.shouldIconPulse) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.icon,
      );
    } else if (widget.icon != null) {
      return widget.icon;
    } else {
      return _emptyWidget;
    }
  }

  Widget _getTitleText() {
    return widget.titleText != null
        ? widget.titleText
        : Text(
            widget.title ?? "",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          );
  }

  Text _getDefaultNotificationText() {
    return Text(
      widget.message ?? "",
      style: TextStyle(fontSize: 14.0, color: Colors.white),
    );
  }

  FlatButton _getMainActionButton() {
    if (widget.mainButton != null) {
      return widget.mainButton;
    } else {
      return null;
    }
  }
}

enum FlushbarPosition { TOP, BOTTOM }
enum FlushbarStyle { FLOATING, GROUNDED }
enum FlushbarDismissDirection { HORIZONTAL, VERTICAL }
enum FlushbarStatus { SHOWING, DISMISSED, IS_APPEARING, IS_HIDING }
