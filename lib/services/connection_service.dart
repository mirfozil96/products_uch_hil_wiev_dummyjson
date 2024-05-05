import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'product/product_list_service.dart';

class ConnectionService {
  late StreamSubscription<List<ConnectivityResult>> connectivity;
  late ProductListService productListService;

  ConnectionService(ProductListService service) {
    productListService = service;
  }

  Future<bool> isInternetConnectionAvailable() async {
    bool isConnectionAvailable = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      isConnectionAvailable = false;
      productListService.internetConnectionAvailability = false;
      productListService.isProductLoading = false;
      productListService
          .addProductError('Internet connection is currently not available');
    }
    return isConnectionAvailable;
  }

  void watchConnectivity(ProductListService productListService) {
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> statuses) {
      // Check if any of the statuses is none, indicating no internet connection
      if (statuses.contains(ConnectivityResult.none)) {
        productListService.internetConnectionAvailability = false;
        productListService.isProductLoading = false;
        productListService
            .addProductError('Internet connection is currently not available');
      } else {
        // If none of the statuses is none, internet is available
        productListService.internetConnectionAvailability = true;
        productListService.refreshCurrentListProducts();
      }
    });
  }

  void cancel() {
    connectivity.cancel();
  }
}
