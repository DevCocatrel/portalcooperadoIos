import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/models/order_authorization_model.dart';
import 'package:cocatrel/models/order_model.dart';
import 'package:cocatrel/models/orders_model.dart';
import 'package:cocatrel/pages/my_orders/widgets/authorization_selector.dart';
import 'package:cocatrel/repositories/my_orders_repository.dart';
import 'package:either_dart/either.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  MyOrdersPageState createState() => MyOrdersPageState();
}

class MyOrdersPageState extends State<MyOrdersPage> {
  String? selectedAuthorization;
  Either<Error, OrdersModel>? orders;

  bool loadingDownloadFile = false;

  Future _loadOrders() async {
    setState(() {
      orders = null;
    });

    final response = await MyOrdersRepository.loadOrders();

    setState(() {
      orders = response;
    });
  }

  Future _downloadSaleRelationAsPDF() async {
    setState(() {
      loadingDownloadFile = true;
    });
    final response = await MyOrdersRepository.pdfFileSalesRelationDownload(
      Provider.of<AuthProvider>(context, listen: false).user!.name!,
    );

    setState(() {
      loadingDownloadFile = false;
    });

    response.fold(
      (error) {
        errorSnackBar("Erro ao baixar o arquivo");
      },
      (data) async {
        try {
          final path = await FileSaver.instance.saveAs(
            name: "relacao_vendas",
            bytes: data,
            mimeType: MimeType.pdf,
            fileExtension: "pdf",
          );

          if ((path ?? '').isNotEmpty) {
            successSnackBar("Arquivo salvo com sucesso");
          } else {
            errorSnackBar('O arquivo não foi salvo');
          }
        } catch (e) {
          errorSnackBar("Erro ao salvar o arquivo");
        }
      },
    );
  }

  Future _downloadSaleRelationAsExcel() async {
    setState(() {
      loadingDownloadFile = true;
    });

    var user = Provider.of<AuthProvider>(context, listen: false).user;

    final response = await MyOrdersRepository.excelFileSalesRelationDownload(
      user!.name!,
      user.registration!,
      user.token!,
    );

    setState(() {
      loadingDownloadFile = false;
    });

    response.fold(
      (error) {
        errorSnackBar("Erro ao baixar o arquivo");
      },
      (data) async {
        try {
          final path = await FileSaver.instance.saveAs(
            name: "relacao_vendas",
            bytes: data,
            mimeType: MimeType.microsoftExcel,
            fileExtension: "xlsx",
          );

          if ((path ?? '').isNotEmpty) {
            successSnackBar("Arquivo salvo com sucesso");
          } else {
            errorSnackBar('O arquivo não foi salvo');
          }
        } catch (e) {
          errorSnackBar("Erro ao salvar o arquivo");
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        title: "Minhas vendas",
      ),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Fazendas disponíveis",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        BasicDropdown(
                          alignment: DropDownAlignment.left,
                          menu: BasicDropdownMenu(
                            items: [
                              BasicDropdownMenuItem(
                                isFirst: true,
                                text: "Baixar relação em PDF",
                                onPressed: () async {
                                  await _downloadSaleRelationAsPDF();
                                },
                                icon: const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 24,
                                  color: AppColors.buttonTextLight,
                                ),
                              ),
                              BasicDropdownMenuItem(
                                isLast: true,
                                text: "Baixar relação em XLSX",
                                onPressed: () async {
                                  await _downloadSaleRelationAsExcel();
                                },
                                icon: const Icon(
                                  Icons.backup_table_rounded,
                                  size: 24,
                                  color: AppColors.buttonTextLight,
                                ),
                              ),
                            ],
                          ),
                          button: Container(
                            padding: const EdgeInsets.all(8),
                            child: loadingDownloadFile
                                ? const SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : const Icon(
                                    Icons.file_download_outlined,
                                    size: 28,
                                    color: AppColors.primaryDark,
                                  ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ordersSection(context),
                    const SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ordersSection(
    BuildContext context,
  ) {
    if (orders == null) {
      return _ordersList(
        loading: true,
        data: OrdersModel(
          orders: List.generate(
            5,
            (index) => OrderModel(
              bagsSold: 00.00,
              authorizations: List.generate(
                1,
                (index) => OrderAuthorizationModel(
                  saleNumber: "000000",
                  authorizationNumber: "000000",
                  authorizationDate: "11/06/2024",
                ),
              ),
              cooperateName: "Lorem Ipsum",
              saleDate: "11/06/2024",
              saleExpirationDate: "11/06/2024",
              saleNumber: "000000",
              saleStatus: "Pendente",
            ),
          ),
        ),
      );
    }

    return orders!.fold(
      (error) => _errorSection(),
      (data) => _ordersList(data: data),
    );
  }

  Widget _errorSection() {
    return const BasicCardError(error: "Erro ao carregar as vendas");
  }

  Widget _ordersList({
    bool loading = false,
    required OrdersModel data,
  }) {
    var orders = data.orders;

    return Skeletonizer(
      enabled: loading,
      child: Column(
        children: [
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;

            return _orderItem(
              order,
              index,
              orders.length,
            );
          })
        ],
      ),
    );
  }

  Container _orderItem(
    OrderModel order,
    int index,
    int ordersLength,
  ) {
    final isLast = index == ordersLength - 1;
    final isChecked = order.saleStatus == "Liberado";

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: DefaultCardWidget(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Venda ${order.saleNumber}",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.successLight
                          : AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isChecked ? Icons.check : Icons.schedule_rounded,
                          size: 16,
                          color: isChecked
                              ? AppColors.successDark
                              : AppColors.dangerDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.saleStatus,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isChecked
                                ? AppColors.successDark
                                : AppColors.dangerDark,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _informationLine(
                    label: "Data",
                    value: order.saleDate,
                  ),
                  _informationLine(
                    label: "Vencimento",
                    value: order.saleExpirationDate,
                  ),
                  _informationLine(
                    label: "Sacas",
                    value: order.bagsSold.toString(),
                  )
                ],
              ),
              if (order.authorizations.isNotEmpty) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Autorizações",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColorLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.authorizations.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        var authorization = order.authorizations[index];

                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            border: Border.all(
                              color: AppColors.borderDarkColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            authorization.authorizationNumber,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.borderDarkColor,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                AuthorizationDialog(
                  authorizations: order.authorizations,
                  saleExpirationDate: order.saleExpirationDate,
                  saleStatus: order.saleStatus,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Container _informationLine({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textColorLight,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
