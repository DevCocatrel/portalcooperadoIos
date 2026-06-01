import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/pages/commodity_price/commodity_price_page.dart';
import 'package:cocatrel/pages/deposit_slip/index_deposit_slip.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/index_deposit_slip_tab.dart';
import 'package:cocatrel/pages/invoices/invoices_page.dart';
import 'package:cocatrel/pages/bonds_payable/bonds_payable_page.dart';
import 'package:cocatrel/pages/change_password/change_password_page.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/lot_model.dart';
import 'package:cocatrel/pages/coffee_balance/coffee_balance_page.dart';
import 'package:cocatrel/pages/coffee_balance/pages/coffee_extract_from_farm/coffee_extract_from_farm_page.dart';
import 'package:cocatrel/pages/coffee_balance/pages/coffee_extract_from_farm/pages/lot_details/lot_details_page.dart';
import 'package:cocatrel/pages/coffee_market/evolution/coffee_evolution_page.dart';
import 'package:cocatrel/pages/coffee_market/exchange/coffee_exchange_page.dart';
import 'package:cocatrel/pages/coffee_market/explanation/coffee_explanation_page.dart';
import 'package:cocatrel/pages/coffee_market/market/coffee_market_page.dart';
import 'package:cocatrel/pages/coffee_market/subtitles/coffee_subtitle_page.dart';
import 'package:cocatrel/pages/coffee_movement/coffee_movement_filter_page.dart';
import 'package:cocatrel/pages/coffee_movement/pages/coffee_movement_page.dart';
import 'package:cocatrel/pages/dashboard/balance/balance_page.dart';
import 'package:cocatrel/pages/dashboard/farms/farms_page.dart';
import 'package:cocatrel/pages/dashboard/home/home_page.dart';
import 'package:cocatrel/pages/dashboard/sales/sales_page.dart';
import 'package:cocatrel/pages/laboratory/laboratory_page.dart';
import 'package:cocatrel/pages/loading/loading_page.dart';
import 'package:cocatrel/pages/login/login_page.dart';
import 'package:cocatrel/pages/login_admin/login_admin_page.dart';
import 'package:cocatrel/pages/my_orders/my_orders_page.dart';
import 'package:cocatrel/pages/my_orders/order_detail/order_detail_page.dart';
import 'package:cocatrel/pages/profile/profile_page.dart';
import 'package:cocatrel/pages/ombudsman/ombudsman_page.dart';
import 'package:cocatrel/pages/pdf_view/pdf_view_page.dart';
import 'package:cocatrel/pages/request_access/request_access_page.dart';
import 'package:cocatrel/pages/sales_authorization/farms/authorization_sale_list_farms_page.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_page.dart';
import 'package:cocatrel/pages/sales_authorization/pending/pending_authorizations.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_page.dart';
import 'package:cocatrel/pages/services/services_page.dart';
import 'package:cocatrel/pages/session_expired/session_expired_page.dart';
import 'package:cocatrel/pages/terms_of_use/terms_of_use_page.dart';
import 'package:cocatrel/pages/without_network/without_network.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const splashPage = '/splash';

  static const home = '/home';
  static const balance = '/balance';
  static const farms = "/farms";
  static const sales = "/sales";

  static const myOrders = '/my_orders';
  static const myOrderDetails = '/my_order_details';
  static const coffeeMarket = '/coffee_market';
  static const coffeeExchange = '/coffee_exchange';
  static const coffeeExplanation = '/coffee_explanation';
  static const coffeeEvolution = '/coffee_evolution';
  static const coffeeSubtitles = '/coffee_subtitles';

  static const login = '/login';
  static const loginAdmin = '/login_admin';
  static const requestAccess = '/request_access';
  static const termsOfUse = '/terms_of_use';

  static const services = '/services';
  static const profile = '/profile';
  static const changePassword = '/change_password';
  static const ombudsman = '/ombudsman';
  static const pdfPage = '/pdf_page';
  static const coffeeBalance = '/coffee_balance';
  static const coffeeExtractFromFarm = '/coffee_extract_from_farm';
  static const lotDetails = '/lot_details';

  static const authorizationSaleListFarms = '/authorization_sale_list_farms';
  static const authorizationSaleListLotsByFarmId =
      '/authorization_sale_list_lots_by_farm_id';
  static const authorizationSale = '/authorization_sale';
  static const authorizationPending = '/authorization_pending';

  static const invoices = '/billets';
  static const bondsPayable = '/bonds_payable';
  static const coffeeMovementFilter = '/coffee_movement_filter';
  static const coffeeMovement = '/coffee_movement';
  static const laboratory = '/laboratory';
  static const indexDepositSlip = '/index_deposit_slip';
  static const indexDepositSlipTabs = '/index_deposit_slip_tabs';
  static const loading = '/loading';
  static const withoutNetwork = '/without_network';
  static const sessionExpired = '/session_expired';
  static const commodityPricePage = '/commodity_price';
}

Map<String, Widget Function(BuildContext)> appRoutes = {
  AppRoutes.myOrders: (_) => const MyOrdersPage(),
  AppRoutes.myOrderDetails: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return OrderDetailPage(
      authorizationNumber: args['authorizationNumber'],
      saleNumber: args['saleNumber'],
      authorizationDate: args['authorizationDate'],
      saleExpirationDate: args['saleExpirationDate'],
      saleStatus: args['saleStatus'],
    );
  },
  AppRoutes.coffeeSubtitles: (_) => const CoffeeSubtitlePage(),
  AppRoutes.coffeeEvolution: (_) => const CoffeeEvolutionPage(),
  AppRoutes.coffeeExplanation: (_) => const CoffeeExplanationPage(),
  AppRoutes.coffeeMarket: (_) => const CoffeeMarketPage(),
  AppRoutes.coffeeExchange: (_) => const CoffeeExchangePage(),
  AppRoutes.home: (_) => const HomePage(),
  AppRoutes.balance: (_) => const BalancePage(),
  AppRoutes.farms: (_) => const FarmsPage(),
  AppRoutes.sales: (_) => const SalesPage(),
  AppRoutes.login: (_) => LoginPage(),
  AppRoutes.loginAdmin: (_) => LoginAdminPage(),
  AppRoutes.requestAccess: (_) => RequestAccessPage(),
  AppRoutes.termsOfUse: (_) => const TermsOfUsePage(),
  AppRoutes.services: (_) => const ServicesPage(),
  AppRoutes.profile: (_) => const ProfilePage(),
  AppRoutes.changePassword: (_) => ChangePasswordPage(),
  AppRoutes.ombudsman: (_) => OmbudsmanPage(),
  AppRoutes.pdfPage: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return PDFPage(
      pdfData: args['pdfData'],
      filePath: args['filePath'],
      title: args['title'],
    );
  },
  AppRoutes.coffeeBalance: (_) => CoffeeBalancePage(),
  AppRoutes.coffeeExtractFromFarm: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return CoffeeExtractFromFarm(
      coffeeBalance: args['farm'] as FarmModel,
    );
  },
  AppRoutes.lotDetails: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return LotDetailsPage(
        args['lotDetails'] as LotModel, args['coffeeBalance']);
  },
  AppRoutes.authorizationSaleListFarms: (_) =>
      const AuthorizationSaleListFarmsPage(),
  AppRoutes.authorizationSaleListLotsByFarmId: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return ListLotsByFarmIdPage(
      farm: args['farm'] as AuthorizationSaleFarmBalanceModel,
      openTitles: args['openTitles'] as double,
    );
  },
  AppRoutes.authorizationSale: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return AuthorizationSalePage(
      batches: args['batches'],
      farm: args['farm'],
      openTitles: args['openTitles'],
    );
  },
  AppRoutes.authorizationPending: (_) => const PendingAuthorizationsPage(),
  AppRoutes.invoices: (_) => InvoicesPage(),
  AppRoutes.bondsPayable: (_) => BondsPayablePage(),
  AppRoutes.coffeeMovementFilter: (_) => CoffeeMovementFilterPage(),
  AppRoutes.coffeeMovement: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return CoffeeMovementPage(args['filter']);
  },
  AppRoutes.laboratory: (context) => LaboratoryPage(),
  AppRoutes.indexDepositSlip: (_) => const IndexDepositSlip(),
  AppRoutes.indexDepositSlipTabs: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return IssueInvoiceStepsPage(args['depositSlip']);
  },
  AppRoutes.loading: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return LoadingPage(args['future'] as Future<bool>);
  },
  AppRoutes.withoutNetwork: (_) => const WithoutNetworkPage(),
  AppRoutes.sessionExpired: (_) => const SessionExpiredPage(),
  AppRoutes.commodityPricePage: (_) => CommodityPricePage(),
};

class MyRouteObserver extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
  }
}
