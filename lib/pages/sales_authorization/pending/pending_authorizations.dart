import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/authorization_sale_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/repositories/authorization_sales_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PendingAuthorizationsPage extends StatefulWidget {
  const PendingAuthorizationsPage({super.key});

  @override
  State createState() => _PendingAuthorizationsPageState();
}

class _PendingAuthorizationsPageState extends State<PendingAuthorizationsPage> {
  Either<Error, AuthorizationSaleModel>? _page;

  Future<void> _loadPage() async {
    setState(() {
      _page = null;
    });

    final page = await AuthorizationSalesRepository.loadPage();

    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        title: "Autorização de venda",
      ),
      bottomNavigationBar: const AuthorizationSaleNavigation(),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        displacement: 50,
        onRefresh: _loadPage,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 32),
                    const BasicTitle(text: "Autorização de venda pendente"),
                    _section(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context) {
    if (_page == null) {
      return _list(
        loading: true,
        authorizations: List.generate(5, (index) {
          return AuthorizationSalePendingModel(
            bags: "2",
            date: "00/00/0000",
            farmInscription: "L-003696/${index + 1}",
            farmName: "Fazenda $index",
            payment: "R\$ 0,00",
            priceType: "M",
            standard: "0",
            status: "P",
            statusFlag: "P",
            totalPrice: 3000.00,
            unitPrice: 1500.00,
            value: "0",
          );
        }),
      );
    }

    return _page!.fold(
      (error) {
        return const BasicCardError(
          error: "Erro ao carregar autorizações de venda",
        );
      },
      (page) {
        if (page.pending.isEmpty) {
          return const BasicCardError(
            icon: Icon(
              Icons.check_rounded,
              color: AppColors.textColorLight,
              size: 24,
            ),
            error: "Você não possui autorizações de vendas pendentes",
          );
        }

        return _list(loading: false, authorizations: page.pending);
      },
    );
  }

  Widget _list({
    bool loading = false,
    required List<AuthorizationSalePendingModel> authorizations,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: authorizations.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final authorization = authorizations[index];
          final isLast = index == authorizations.length - 1;

          return Container(
            padding: EdgeInsets.only(bottom: !isLast ? 8 : 0),
            child: DefaultCardWidget(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorization.farmInscription,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _textItem(
                      label: "Bebida",
                      value: authorization.farmName,
                      hasDivider: true,
                    ),
                    _textItem(
                      label: "Sacas",
                      value: authorization.bags,
                      hasDivider: true,
                    ),
                    _textItem(
                      label: "Preço praticado",
                      value: authorization.priceType,
                      hasDivider: true,
                    ),
                    _textItem(
                      label: "Pr. Unitário Liquido",
                      value: Currency.format(authorization.unitPrice),
                      hasDivider: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _textItem({
    required String label,
    required String value,
    bool hasDivider = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        if (hasDivider)
          const Divider(
            color: AppColors.borderColor,
            height: 16,
          ),
      ],
    );
  }
}
