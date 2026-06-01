import 'package:cocatrel/common/widgets/dropdown/basic_dropdown_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DropDownAlignment { left, right }

class BasicDropdown extends StatefulWidget {
  final DropDownAlignment alignment;
  final Widget? menu;
  final Widget button;

  const BasicDropdown({
    super.key,
    this.alignment = DropDownAlignment.left,
    this.menu,
    required this.button,
  });

  @override
  State<StatefulWidget> createState() => BasicDropdownState();
}

class BasicDropdownState extends State<BasicDropdown> {
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BasicDropdownNotifier(),
      child: Consumer<BasicDropdownNotifier>(
        builder: (context, notifier, _) {
          return CompositedTransformTarget(
            link: _link,
            child: OverlayPortal(
              controller: notifier.basicDropdownController,
              overlayChildBuilder: (BuildContext context) {
                return CompositedTransformFollower(
                  link: _link,
                  targetAnchor: widget.alignment == DropDownAlignment.left
                      ? Alignment.bottomCenter
                      : Alignment.bottomRight,
                  followerAnchor: widget.alignment == DropDownAlignment.left
                      ? Alignment.topRight
                      : Alignment.topCenter,
                  child: Align(
                    alignment: widget.alignment == DropDownAlignment.left
                        ? AlignmentDirectional.topEnd
                        : AlignmentDirectional.topEnd,
                    child: widget.menu,
                  ),
                );
              },
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  notifier.toggle();
                },
                child: widget.button,
              ),
            ),
          );
        },
      ),
    );
  }
}
