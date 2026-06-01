import 'package:cocatrel/common/widgets/dropdown/basic_dropdown_notifier.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BasicDropdownMenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final bool isFirst;
  final bool isLast;
  final bool isOnly;
  final void Function()? onPressed;

  const BasicDropdownMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.isFirst = false,
    this.isLast = false,
    this.isOnly = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.only(
          top: 24,
          bottom: 24,
          left: 20,
          right: 20,
        )),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: isFirst
                ? const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )
                : isLast
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      )
                    : isOnly
                        ? const BorderRadius.all(
                            Radius.circular(16),
                          )
                        : BorderRadius.zero,
          ),
        ),
      ),
      onPressed: () {
        final dropdownNotifier =
            Provider.of<BasicDropdownNotifier>(context, listen: false);

        onPressed?.call();
        dropdownNotifier.close();
      },
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: AppColors.buttonTextLight,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            softWrap: true, // Permite quebra de linha
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
