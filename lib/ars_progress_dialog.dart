import 'dart:ui';

import 'package:flutter/material.dart';

class ArsProgressDialog {
  final BuildContext context;
  final Widget loadingWidget;
  final bool dismissable;
  final Function onDismiss;
  final double blur;
  final Color backgroundColor;
  final bool useSafeArea;
  final Duration animationDuration;

  bool _isShowing = false;
  _ArsProgressDialogWidget _progressDialogWidget;

  bool get isShowing => _isShowing;

  ArsProgressDialog(
    this.context, {
    this.backgroundColor: const Color(0x99000000),
    this.blur: 0,
    this.dismissable: true,
    this.onDismiss,
    this.loadingWidget,
    this.useSafeArea: false,
    this.animationDuration: const Duration(milliseconds: 300),
  }) {
    _initProgress();
  }

  void _initProgress() {
    _progressDialogWidget = _ArsProgressDialogWidget(
      blur: blur,
      dismissable: dismissable,
      backgroundColor: backgroundColor,
      onDismiss: onDismiss,
      loadingWidget: loadingWidget,
      animationDuration: animationDuration,
    );
  }

  // Show progress dialog
  void show() async {
    if (!_isShowing) {
      _isShowing = true;
      if (_progressDialogWidget == null) _initProgress();
      await showDialog(
        useSafeArea: useSafeArea,
        context: context,
        barrierDismissible: dismissable ?? true,
        builder: (context) => _progressDialogWidget,
        barrierColor: Colors.transparent,
      );
      _isShowing = false;
    }
  }

  // Dismiss progress dialog
  void dismiss() {
    if (_isShowing) {
      _isShowing = false;
      Navigator.pop(context);
    }
  }
}

// ignore: must_be_immutable
class _ArsProgressDialogWidget extends StatelessWidget {
  Widget loadingWidget;
  final Function onDismiss;
  final double blur;
  final Color backgroundColor;
  final bool dismissable;
  final Duration animationDuration;

  _ArsProgressDialogWidget({
    Key key,
    this.dismissable,
    this.onDismiss,
    this.backgroundColor,
    this.loadingWidget,
    this.blur,
    this.animationDuration: const Duration(milliseconds: 300),
  }) {
    loadingWidget = loadingWidget ??
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
  }

  @override
  Widget build(BuildContext context) {
    return _DialogBackground(
      blur: blur,
      dismissable: dismissable ?? true,
      onDismiss: onDismiss,
      color: backgroundColor,
      animationDuration: animationDuration,
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

// ignore: must_be_immutable
class _DialogBackground extends StatelessWidget {
  // Widget of dialog, you can use NDialog, Dialog, AlertDialog or Custom your own Dialog
  final Widget dialog;

  // Because blur dialog cover the barrier, you have to declare here
  final bool dismissable;

  // Action before dialog dismissed
  final Function onDismiss;

  // Creates an background filter that applies a Gaussian blur.
  // Default = 0
  final double blur;

  // Background color
  final Color color;

  // Animation Duration
  final Duration animationDuration;

  // Color Opacity
  double _colorOpacity;

  _DialogBackground(
      {this.dialog,
      this.dismissable,
      this.blur,
      this.onDismiss,
      this.animationDuration: const Duration(milliseconds: 300),
      this.color}) {
    _colorOpacity = color.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: animationDuration,
        builder: (context, val, child) {
          return Material(
            type: MaterialType.canvas,
            color: color.withOpacity(val * _colorOpacity),
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
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: val * blur,
                          sigmaY: val * blur,
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )),
                  dialog
                ],
              ),
            ),
          );
        });
  }
}
