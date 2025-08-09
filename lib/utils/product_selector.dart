int getCoinFromProductId(String id) {
  int coin = 0;
  switch (id) {
    case "100_coins":
      coin = 100;
      break;
    case "200_coins":
      coin = 200;
      break;
    case "single_coin":
      coin = 1;
      break;
  }
  return coin;
}
