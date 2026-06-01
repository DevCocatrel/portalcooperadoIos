import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/models/order_details_authorization_model.dart';
import 'package:cocatrel/models/order_details_history_model.dart';
import 'package:cocatrel/models/order_details_model.dart';
import 'package:cocatrel/repositories/my_orders_repository.dart';
import 'package:either_dart/either.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsItem {
  final String label;
  final String value;

  OrderDetailsItem({
    required this.label,
    required this.value,
  });
}

class OrderDetailPage extends StatefulWidget {
  final String authorizationNumber;
  final String saleNumber;
  final String authorizationDate;
  final String saleExpirationDate;
  final String saleStatus;

  const OrderDetailPage({
    super.key,
    required this.authorizationNumber,
    required this.saleNumber,
    required this.authorizationDate,
    required this.saleExpirationDate,
    required this.saleStatus,
  });

  @override
  OrderDetailPageState createState() => OrderDetailPageState();
}

class OrderDetailPageState extends State<OrderDetailPage> {
  Either<Error, OrderDetailsModel>? _orderDetails;

  Future _loadDetails() async {
    setState(() {
      _orderDetails = null;
    });

    final response = await MyOrdersRepository.loadOrderDetails(
      authorizationNumber: widget.authorizationNumber,
      saleNumber: widget.saleNumber,
    );

    setState(() {
      _orderDetails = response;
    });
  }

  bool loadingDownload = false;
  Future _downloadOrderDetailsAsPDF() async {
    setState(() {
      loadingDownload = true;
    });
    final response = await MyOrdersRepository.pdfFileSaleDetailsDownload(
      userName: Provider.of<AuthProvider>(context, listen: false).user!.name!,
      authorizationNumber: widget.authorizationNumber,
      saleNumber: widget.saleNumber,
      authorizationDate: widget.authorizationDate,
      saleExpirationDate: widget.saleExpirationDate,
    );

    setState(() {
      loadingDownload = false;
    });

    response.fold(
      (error) {
        errorSnackBar("Erro ao baixar o arquivo");
      },
      (data) async {
        try {
          var name = "venda_${widget.saleNumber}_${widget.authorizationNumber}"
              .replaceAll('/', '_');
          final value = await FileSaver.instance.saveAs(
            name: name,
            bytes: data,
            mimeType: MimeType.pdf,
            fileExtension: "pdf",
          );

          if ((value ?? '').isNotEmpty) {
            successSnackBar("Arquivo salvo com sucesso");
          } else {
            errorSnackBar("O arquivo não foi salvo");
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
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        showBackButton: true,
      ),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadDetails,
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
                    _wrapper(),
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

  Widget _wrapper() {
    if (_orderDetails == null) {
      return _section(
        loading: true,
        orderDetails: OrderDetailsModel(
          authorizations: List.generate(5, (index) {
            return OrderDetailsAuthorizationModel(
              batch: "Lorem Ipsum",
              bags: 00.00,
              certifier: "Lorem Ipsum",
              dry: "Lorem Ipsum",
              entryDate: "Lorem Ipsum",
              harvest: "Lorem Ipsum",
              picking: "Lorem Ipsum",
              price: 00.00,
              procDry: "Lorem Ipsum",
              quote: "Lorem Ipsum",
              sieve: "Lorem Ipsum",
            );
          }),
          cooperateName: "Lorem Ipsum",
          farmName: "Lorem Ipsum",
          histories: List.generate(5, (index) {
            return OrderDetailsHistoryModel(
              balance: 00.00,
              calculatedBalance: 00.00,
              name: "Lorem Ipsum",
              type: "Lorem Ipsum",
            );
          }),
          inscription: "Lorem Ipsum",
          totalBalance: 00.00,
          totalCredit: 00.00,
          totalDebt: 00.00,
        ),
      );
    }

    return _orderDetails!.fold((error) {
      return _errorSection();
    }, (orderDetails) {
      return _section(
        loading: false,
        orderDetails: orderDetails,
      );
    });
  }

  Widget _errorSection() {
    return const BasicCardError(error: "Erro ao carregar detalhes da venda");
  }

  Widget _section({
    bool loading = false,
    required OrderDetailsModel orderDetails,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Vendas realizadas",
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
                      isOnly: true,
                      text: "Baixar demonstrativo em PDF",
                      onPressed: () async {
                        await _downloadOrderDetailsAsPDF();
                      },
                      icon: const Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 24,
                        color: AppColors.buttonTextLight,
                      ),
                    ),
                  ],
                ),
                button: Container(
                  padding: const EdgeInsets.all(8),
                  child: loadingDownload
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
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
          _defaultCard(
            title: "Venda ${widget.saleNumber}",
            status: "Liberado",
            items: [
              OrderDetailsItem(
                label: "Autorização",
                value: widget.authorizationNumber,
              ),
              OrderDetailsItem(
                label: "Data da operação",
                value: widget.authorizationDate,
              ),
              OrderDetailsItem(
                label: "Data do vencimento",
                value: widget.saleExpirationDate,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const BasicTitle(text: "Detalhes da Autorização de venda"),
          ...orderDetails.authorizations.asMap().entries.map(
            (entry) {
              final authorization = entry.value;
              final isLast =
                  entry.key == orderDetails.authorizations.length - 1;

              return Container(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: _defaultCard(
                  items: [
                    OrderDetailsItem(
                      label: "Lote",
                      value: authorization.batch,
                    ),
                    OrderDetailsItem(
                      label: "Safra",
                      value: authorization.harvest,
                    ),
                    OrderDetailsItem(
                      label: "Entrada",
                      value: authorization.entryDate,
                    ),
                    OrderDetailsItem(
                      label: "Sacas",
                      value: authorization.bags.toString(),
                    ),
                    OrderDetailsItem(
                      label: "Preço",
                      value: Currency.format(authorization.price),
                    ),
                    OrderDetailsItem(
                      label: "Padrão",
                      value: authorization.quote,
                    ),
                    OrderDetailsItem(
                      label: "Catação (%)",
                      value: authorization.picking,
                    ),
                    OrderDetailsItem(
                      label: "Peneira",
                      value: authorization.sieve.trim(),
                    ),
                    OrderDetailsItem(
                      label: "Certificador",
                      value: authorization.certifier,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const BasicTitle(text: "Histórico"),
          ...orderDetails.histories.asMap().entries.map(
            (entry) {
              final history = entry.value;
              final isLast = entry.key == orderDetails.histories.length - 1;

              return Container(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: _defaultCard(
                  title: history.name,
                  items: [
                    OrderDetailsItem(
                      label: "D/C",
                      value: history.type,
                    ),
                    OrderDetailsItem(
                      label: "Valor lançamento (R\$)",
                      value: Currency.format(history.balance),
                    ),
                    OrderDetailsItem(
                      label: "Saldo (R\$)",
                      value: Currency.format(history.calculatedBalance),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _defaultCard({
    String? title,
    String? status,
    required List<OrderDetailsItem> items,
  }) {
    final isChecked = widget.saleStatus == "Liberado";

    return DefaultCardWidget(
      child: Column(
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColorDark,
                  ),
                ),
                if (status != null) ...[
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
                          widget.saleStatus,
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
              ],
            ),
            const SizedBox(height: 16),
          ],
          ...items.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final item = entry.value;
              final isFirst = index == 0;
              final isLast = index == items.length - 1;

              return Container(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 8,
                  top: isFirst ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          isFirst ? Colors.transparent : AppColors.borderColor,
                      width: isFirst ? 0 : 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorLight,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
