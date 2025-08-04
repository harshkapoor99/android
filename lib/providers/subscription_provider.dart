import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/subscription_provider.gen.dart';

const String _kSilverSubscriptionId = 'subscription_silver';
const String _kGoldSubscriptionId = 'subscription_gold';
const List<String> _kProductIds = <String>[
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

@riverpod
class Subscription extends _$Subscription {
  @override
  SubscritionState build() {
    late StreamSubscription<List<PurchaseDetails>> subscription;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
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
    SubscritionState iniState = SubscritionState(subscriptions: subscription);
    return iniState;
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      state.isAvailable = isAvailable;
      state.products = <ProductDetails>[];
      state.purchases = <PurchaseDetails>[];
      state.notFoundIds = <String>[];
      state.consumables = <String>[];
      state.purchasePending = false;
      state.loading = false;

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
        .queryProductDetails(_kProductIds.toSet());
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
    // state.isAvailable = isAvailable;
    // state.products = productDetailResponse.productDetails;
    // state.notFoundIds = productDetailResponse.notFoundIDs;
    // state.consumables = consumables;
    // state.purchasePending = false;
    // state.loading = false;
    // state = state._updateWith(state);
  }

  void selectSub(PurchaseDetails sub) async {
    // final currentState = await future;
    // currentState.seletedSub = sub;
    state.seletedSub = sub;
    // state = AsyncData(currentState._updateWith(currentState));
    state = state._updateWith(state);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
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
    });
  }
}

class SubscritionState {
  SubscritionState({
    required this.subscriptions,
    this.seletedSub,
    this.products = const [],
    this.purchases = const [],
    this.consumables = const [],
    this.notFoundIds = const [],
    this.purchasePending = false,
    this.isAvailable = false,
    this.loading = true,
  });
  // final List<SubscriptionModel> subscriptions;
  PurchaseDetails? seletedSub;
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
      seletedSub: state.seletedSub,
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
