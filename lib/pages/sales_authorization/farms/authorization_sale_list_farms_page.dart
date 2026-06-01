import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/authorization_sale_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/repositories/authorization_sales_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthorizationSaleListFarmsPage extends StatefulWidget {
  const AuthorizationSaleListFarmsPage({super.key});

  @override
  State createState() => _AuthorizationSaleListFarmsPageState();
}

class _AuthorizationSaleListFarmsPageState
    extends State<AuthorizationSaleListFarmsPage> {
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
                    const BasicTitle(text: "Fazendas disponíveis"),
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
        context: context,
        openTitles: 0,
        farms: List.generate(
          2,
          (index) {
            return AuthorizationSaleFarmBalanceModel(
              name: "Carregando...",
              inscription: "Carregando...",
              balance: 0,
              blockedBalance: 0,
              authorizedBalance: 0,
              availableBalance: 0,
              cooperateName: "Carregando...",
            );
          },
        ),
      );
    }

    return _page!.fold(
      (error) {
        return const BasicCardError(error: "Erro ao carregar fazendas");
      },
      (page) {
        if (page.farms.isEmpty) {
          return const BasicCardError(error: "Nenhuma fazenda disponível");
        }

        return _list(
          openTitles: page.openTitles,
          context: context,
          loading: false,
          farms: page.farms,
        );
      },
    );
  }

  Widget _list({
    bool loading = false,
    required double openTitles,
    required List<AuthorizationSaleFarmBalanceModel> farms,
    required BuildContext context,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: farms.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final farm = farms[index];
          final isLast = index == farms.length - 1;

          return Container(
            padding: EdgeInsets.only(bottom: !isLast ? 8 : 0),
            child: DefaultCardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.agriculture_outlined,
                        color: AppColors.primaryDark,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          farm.name,
                          style: GoogleFonts.montserrat(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _itemList(
                    label: "Inscrição",
                    value: farm.inscription,
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 16,
                  ),
                  _itemList(
                    label: "Sacas",
                    value: farm.balance.toString(),
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 16,
                  ),
                  _itemList(
                    label: "Bloqueado",
                    value: farm.blockedBalance.toString(),
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 16,
                  ),
                  _itemList(
                    label: "Autorizado",
                    value: farm.authorizedBalance.toString(),
                  ),
                  const Divider(
                    color: AppColors.borderColor,
                    height: 16,
                  ),
                  _itemList(
                    label: "Disponível",
                    value: farm.availableBalance.toString(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.authorizationSaleListLotsByFarmId,
                        arguments: {
                          "farm": farm,
                          "openTitles": openTitles,
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.price_check_rounded,
                          size: 24,
                          color: AppColors.textColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Autorizar venda",
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemList({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: AppColors.textColorLight,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: AppColors.textColorLight,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
