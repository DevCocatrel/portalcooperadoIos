import 'package:cocatrel/common/widgets/dropdown/basic_dropdown_notifier.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicDropdownMenu extends StatelessWidget {
  final List<Widget> items;

  const BasicDropdownMenu({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        final dropdownNotifier =
            Provider.of<BasicDropdownNotifier>(context, listen: false);

        dropdownNotifier.close();
      },
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.5,
                  color: Color(0xFFd4cbbd),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              children: intercalateWidgets(items),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> intercalateWidgets(List<Widget> widgets) {
    List<Widget> intercalatedWidgets = [];
    for (int i = 0; i < widgets.length; i++) {
      intercalatedWidgets.add(widgets[i]);
      if (i < widgets.length - 1) {
        intercalatedWidgets.add(const Divider(
          height: 0,
          thickness: 1,
          color: AppColors.borderColor,
        ));
      }
    }
    return intercalatedWidgets;
  }
}
