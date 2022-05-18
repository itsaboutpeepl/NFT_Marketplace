import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;

  bool get isConnected => isEnabled && currentAddress.value.isNotEmpty;

  final currentAddress = ''.obs;
  String displayAddress = '';

  int currentChain = -1;
  static const OPERATING_CHAIN = 97;

  connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress.value = accs.first;
      if (accs.isNotEmpty) {
        displayAddress =
            accs.first.substring(0, 5) + "..." + accs.first.substring(37, 41);
      }

      currentChain = await ethereum!.getChainId();

      update();
    }
  }

  clear() {
    currentAddress.value = '';
    displayAddress = '';
    currentChain = -1;
    update();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accs) {
        clear();
      });

      ethereum!.onChainChanged((chain) {
        clear();
      });
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
