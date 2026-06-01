import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/authorization_sale_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/authorization_sale_batches_model.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/widgets/batch/batch_item.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/widgets/cart/cart_drawer.dart';
import 'package:cocatrel/repositories/authorization_sales_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListLotsByFarmIdPage extends StatefulWidget {
  final double openTitles;
  final AuthorizationSaleFarmBalanceModel farm;

  const ListLotsByFarmIdPage({
    super.key,
    required this.farm,
    required this.openTitles,
  });

  @override
  State createState() => _LotsByFarmIdPageState();
}

class _LotsByFarmIdPageState extends State<ListLotsByFarmIdPage> {
  late final ListLotsByFarmIdController controller;
  Either<Error, List<AuthorizationSaleBatchesModel>>? _batches;

  @override
  void initState() {
    super.initState();
    controller = ListLotsByFarmIdController(
      openTitles: widget.openTitles,
      farm: widget.farm,
    );
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    setState(() {
      _batches = null;
    });

    final result = await AuthorizationSalesRepository.loadBatchesByInscription(
      widget.farm.inscription,
    );

    setState(() {
      _batches = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      floatingActionButton: ChangeNotifierProvider.value(
        value: controller,
        child: _floatingActionButton(),
      ),
      appBar: const ProfileAppBar(
        showBackButton: true,
      ),
      bottomNavigationBar: const AuthorizationSaleNavigation(),
      drawer: const BasicMenuDrawer(),
      endDrawer: ChangeNotifierProvider.value(
        value: controller,
        child: const CartDrawer(),
      ),
      body: RefreshIndicator(
        displacement: 50,
        onRefresh: () {
          controller.clear();

          return _loadBatches();
        },
        child: ChangeNotifierProvider.value(
          value: controller,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 32),
                      _actualFarm(),
                      const SizedBox(height: 26),
                      const BasicTitle(text: "Lotes disponíveis"),
                      _section(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context) {
    if (_batches == null) {
      return _listBatches(
        batches: List.generate(5, (index) {
          return AuthorizationSaleBatchesModel(
            authorizedBags: 0,
            availableBags: 0,
            backgroundColor: "#FFFFFF",
            batch: "Lorem",
            balanceBags: 0,
            balanceEntryBags: 0,
            beanClassification: "Lorem",
            blockedBalanceBags: 0,
            classificationPerBreak: 0,
            customClassification: "Lorem",
            drinkClassification: "Lorem",
            dryClassification: "Lorem",
            entryDate: "Lorem",
            goodBarrelDrink: "Lorem",
            grossUnitPrice: 0,
            harvestClassification: "Lorem",
            netUnitPrice: 0,
            sampleName: "Lorem",
            standardClassification: "Lorem",
            textColor: "#FFFFFF",
          );
        }),
        loading: true,
      );
    }

    return _batches!.fold(
      (error) {
        return const BasicCardError(error: "Erro ao carregar os lotes");
      },
      (batches) {
        if (batches.isEmpty) {
          return const BasicCardError(error: "Não há lotes para listar");
        }
        return _listBatches(batches: batches, loading: false);
      },
    );
  }

  Widget _listBatches({
    bool loading = false,
    required List<AuthorizationSaleBatchesModel> batches,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: batches.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final batch = batches[index];
          final isLast = index == batches.length - 1;

          return Container(
            padding: EdgeInsets.only(bottom: !isLast ? 8 : 0),
            child: BatchItem(batch: batch),
          );
        },
      ),
    );
  }

  Widget _floatingActionButton() {
    return Consumer<ListLotsByFarmIdController>(
      builder: (context, myProvider, child) {
        if (myProvider.batches.isEmpty) {
          return const SizedBox();
        }

        return SizedBox(
          width: 127,
          height: 54,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Stack(
              alignment: const Alignment(1.1, -1.5),
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  label: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart_checkout_outlined,
                        color: AppColors.buttonTextLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Autorizar',
                        style: GoogleFonts.montserrat(
                          color: AppColors.buttonTextLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.primaryLight,
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  constraints:
                      const BoxConstraints(minHeight: 24, minWidth: 24),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 5,
                        color: Colors.black.withAlpha(50),
                      )
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.danger,
                  ),
                  child: Center(
                    child: Text(
                      controller.batches.length.toString(),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actualFarm() {
    return DefaultCardWidget(
      child: Column(
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
                  widget.farm.name,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Inscrição",
                style: GoogleFonts.montserrat(
                  color: AppColors.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.farm.inscription,
                style: GoogleFonts.montserrat(
                  color: AppColors.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
