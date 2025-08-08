import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/subscription_provider.gen.dart';

const Set<String> _kProductIds = {"100_coins", "200_coins", "single_coin"};

@riverpod
class Subscription extends _$Subscription {
  @override
  SubscritionState build() {
    late StreamSubscription<List<PurchaseDetails>> subscription;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    print("Fetching Subscription");
    subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        subscription.cancel();
      },
      onError: (error) {
        // handle error here.
      },
    );
    initStoreInfo();
    SubscritionState iniState = SubscritionState(subscriptions: subscription);
    return iniState;
  }

  Future<void> initStoreInfo() async {
    print("initStoreInfo");
    bool isAvailable = false;
    try {
      isAvailable = await InAppPurchase.instance.isAvailable();
    } catch (e) {
      print("ERROR> $e");
      rethrow;
    }
    print("isAvailable $isAvailable");
    if (!isAvailable) {
      state.isAvailable = isAvailable;
      state.products = <ProductDetails>[];
      state.purchases = <PurchaseDetails>[];
      state.notFoundIds = <String>[];
      state.consumables = <String>[];
      state.purchasePending = false;
      state.loading = false;
      state = state._updateWith(state);

      return;
    }

    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       InAppPurchase.instance
    //           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }

    final ProductDetailsResponse productDetailResponse = await InAppPurchase
        .instance
        .queryProductDetails(_kProductIds);
    if (productDetailResponse.error != null) {
      // state.queryProductError = productDetailResponse.error!.message;
      state.isAvailable = isAvailable;
      state.products = productDetailResponse.productDetails;
      state.purchases = <PurchaseDetails>[];
      state.notFoundIds = productDetailResponse.notFoundIDs;
      state.consumables = <String>[];
      state.purchasePending = false;
      state.loading = false;
      state = state._updateWith(state);
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      // _queryProductError = null;
      state.isAvailable = isAvailable;
      state.products = productDetailResponse.productDetails;
      state.purchases = <PurchaseDetails>[];
      state.notFoundIds = productDetailResponse.notFoundIDs;
      state.consumables = <String>[];
      state.purchasePending = false;
      state.loading = false;
      state = state._updateWith(state);
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();
    state.isAvailable = isAvailable;
    state.products = productDetailResponse.productDetails;
    state.notFoundIds = productDetailResponse.notFoundIDs;
    // state.consumables = consumables;
    state.purchasePending = false;
    state.loading = false;
    state = state._updateWith(state);
  }

  void selectSub(ProductDetails sub) async {
    // final currentState = await future;
    // currentState.seletedSub = sub;
    state.seletedProduct = sub;
    // state = AsyncData(currentState._updateWith(currentState));
    state = state._updateWith(state);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print(purchaseDetailsList);
    purchaseDetailsList.forEach(_handlePurchaseUpdate);
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // _showPendingUI();
      print("pending");
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // _handleError(purchaseDetails.error!);
        print("Error: ${purchaseDetails.error!}");
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        print("pDetails: $purchaseDetails");
        // bool valid = await _verifyPurchase(purchaseDetails);
        // if (valid) {
        //   // _deliverProduct(purchaseDetails);
        // } else {
        //   // _handleInvalidPurchase(purchaseDetails);
        // }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  void purchaseProduct() {
    if (state.seletedProduct != null) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: state.seletedProduct!,
      );
      // if (_isConsumable(productDetails)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      // } else {
      //   InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      // }
    }
  }
}

class SubscritionState {
  SubscritionState({
    required this.subscriptions,
    this.seletedProduct,
    this.products = const [],
    this.purchases = const [],
    this.consumables = const [],
    this.notFoundIds = const [],
    this.purchasePending = false,
    this.isAvailable = false,
    this.loading = true,
  });
  // final List<SubscriptionModel> subscriptions;
  ProductDetails? seletedProduct;
  StreamSubscription<List<PurchaseDetails>> subscriptions;

  List<ProductDetails> products;
  List<PurchaseDetails> purchases;
  List<String> consumables;
  List<String> notFoundIds;
  bool purchasePending;
  bool isAvailable;
  bool loading;

  SubscritionState _updateWith(SubscritionState state) {
    return SubscritionState(
      subscriptions: state.subscriptions,
      seletedProduct: state.seletedProduct,
      products: state.products,
      purchases: state.purchases,
      consumables: state.consumables,
      notFoundIds: state.notFoundIds,
      purchasePending: state.purchasePending,
      isAvailable: state.isAvailable,
      loading: state.loading,
    );
  }
}
