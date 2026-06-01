import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultScaffoldWidget extends StatelessWidget {
  const DefaultScaffoldWidget({
    required this.appBar,
    this.floatingActionButton,
    required this.body,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: body,
      ),
    );
  }
}
