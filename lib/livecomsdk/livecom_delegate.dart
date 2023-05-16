
mixin LiveComDelegate {
  void onProductAdd(String sku, String streamId);
  void onProductDelete(String productSKU);
  void onCartChange(List<String> productSKUs);

  // Called only if LiveComSDK.useCustomProductScreen is true
  void onRequestOpenProductScreen(String sku, String streamId);
  // Called only if LiveComSDK.useCustomProductScreen is true
  void onRequestOpenCheckoutScreen(List<String> productSKUs);
}