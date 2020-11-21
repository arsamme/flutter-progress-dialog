import 'dart:ui';

import 'package:flutter/material.dart';

class CustomProgressDialog {
  final BuildContext context;
  final Widget loadingWidget;
  final Function onCancel;
  final bool dismissable;
  final Function onDismiss;
  final double blur;
  final Color backgroundColor;
  bool _isShowing = false;
  ArsProgressDialogWidget _progressDialogWidget;

  bool get isShowing => _isShowing;

  CustomProgressDialog(
      this.context, {
        this.backgroundColor,
        this.blur,
        this.onCancel,
        this.dismissable,
        this.onDismiss,
        this.loadingWidget,
      }) {
    _initProgress();
  }

  void _initProgress() {
    _progressDialogWidget = ArsProgressDialogWidget(
      blur: blur,
      onCancel: onCancel,
      dismissable: dismissable,
      backgroundColor: backgroundColor,
      onDismiss: onDismiss,
      loadingWidget: loadingWidget,
    );
  }

  void show() async {
    if (!_isShowing) {
      _isShowing = true;
      if (_progressDialogWidget == null) _initProgress();
      await showDialog(
          useSafeArea: false,
          context: context,
          barrierDismissible: dismissable ?? true,
          builder: (context) => _progressDialogWidget,
          barrierColor: Color(0x00ffffff));
      _isShowing = false;
    }
  }

  ///Dissmiss progress dialog
  void dismiss() {
    if (_isShowing) {
      _isShowing = false;
      Navigator.pop(context);
    }
  }
}

// ignore: must_be_immutable
class ArsProgressDialogWidget extends StatefulWidget {
  final Function onCancel;
  final Widget loadingWidget;
  final Function onDismiss;
  final double blur;
  final Color backgroundColor;
  final bool dismissable;

  ArsProgressDialogWidget({
    Key key,
    this.onCancel,
    this.dismissable,
    this.onDismiss,
    this.backgroundColor,
    this.loadingWidget,
    this.blur,
  }) : super(key: key);

  @override
  _ArsProgressDialogWidgetState createState() =>
      _ArsProgressDialogWidgetState();
}

class _ArsProgressDialogWidgetState extends State<ArsProgressDialogWidget> {
  Widget _loadingWidget;
  Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _backgroundColor ?? widget.backgroundColor;
    Widget loadingWidget = (this._loadingWidget ?? widget.loadingWidget) ??
        Container(
          padding: EdgeInsets.all(10.0),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );

    return DialogBackground(
      blur: widget.blur ?? 0,
      dismissable: widget.dismissable ?? true,
      onDismiss: widget.onDismiss,
      color: backgroundColor,
      dialog: Padding(
        padding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Center(
          child: loadingWidget,
        ),
      ),
    );
  }
}

class DialogBackground extends StatelessWidget {
  ///Widget of dialog, you can use NDialog, Dialog, AlertDialog or Custom your own Dialog
  final Widget dialog;

  ///Because blur dialog cover the barrier, you have to declare here
  final bool dismissable;

  ///Action before dialog dismissed
  final Function onDismiss;

  /// Creates an background filter that applies a Gaussian blur.
  /// Default = 0
  final double blur;

  /// Background color
  final Color color;

  const DialogBackground(
      {Key key,
        this.dialog,
        this.dismissable,
        this.blur,
        this.onDismiss,
        this.color})
      : super(key: key);

  ///Show dialog directly
  Future show<T>(BuildContext context) => showDialog<T>(
      context: context,
      builder: (context) => this,
      barrierColor: Color(0x00ffffff),
      barrierDismissible: dismissable ?? true);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: color ?? Colors.black.withOpacity(.6),
      child: WillPopScope(
        onWillPop: () async {
          if (dismissable ?? true) {
            if (onDismiss != null) onDismiss();
            Navigator.pop(context);
          }
          return;
        },
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: dismissable ?? true
                    ? () {
                  if (onDismiss != null) {
                    onDismiss();
                  }
                  Navigator.pop(context);
                }
                    : () {},
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: blur ?? 0),
                  duration: Duration(milliseconds: 300),
                  builder: (context, val, child) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: val,
                        sigmaY: val,
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    );
                  },
                )),
            dialog
          ],
        ),
      ),
    );
  }
}