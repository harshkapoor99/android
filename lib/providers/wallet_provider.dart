import 'package:flutter/material.dart';
import 'package:guftagu_mobile/components/recharge_coin_dialog.dart';
import 'package:guftagu_mobile/models/wallet.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/services/subscription_service.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/wallet_provider.gen.dart';

@Riverpod(keepAlive: true)
class Wallet extends _$Wallet {
  @override
  WalletState build() {
    WalletState iniState = WalletState();
    return iniState;
  }

  Future<void> fetchWallet() async {
    try {
      final response = await ref
          .read(subscriptionServiceProvider)
          .fetchWallet(ref.read(hiveServiceProvider.notifier).getUserId()!);
      WalletModel walletModel = WalletModel.fromJson(response.data["wallet"]);

      setWalletCoin(walletModel.coin);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void setWalletCoin(double coins) {
    state.coins = coins;
    state = state._updateWith(state);
  }

  void deductCoins(double usedCoins) {
    if (usedCoins > state.coins) {
      state.coins = 0;
    } else {
      state.coins = state.coins - usedCoins;
    }

    state = state._updateWith(state);
  }

  bool checkWalletHasCoin() {
    // TODO: update logic
    if (state.coins >= 0) {
      showDialog(
        context: AppConstants.navigatorKey.currentContext!,
        builder: (context) => const RechargeCoinsDialog(),
      );
      return false;
    }
    return true;
  }
}

class WalletState {
  WalletState({this.coins = 0, this.loading = true});
  double coins;
  bool loading;

  WalletState _updateWith(WalletState state) {
    return WalletState(coins: state.coins, loading: state.loading);
  }
}
