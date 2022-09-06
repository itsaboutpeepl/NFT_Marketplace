import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:peeplDapp/Widgets/snackbar.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  bool get isEnabled => ethereum != null; //isEnabled means if metamask is enabled

  bool get isInOperatingChain =>
      currentChain == OPERATING_CHAIN; //if the operating chain is the same as the chain of the current wallet

  bool get isConnected => isEnabled && currentAddress.value.isNotEmpty; //if enabled plus current address is not null.

  final walletConnect = false.obs;

  final Rx<String> currentAddress = ''.obs;
  final Rx<String> displayAddress = ''.obs;

  RxBool isLoading = false.obs;

  bool onTapEnabled = true;

  int currentChain = -1;
  static const OPERATING_CHAIN = 122;

  bool isLoggedOut = false;

  List<String> accs = [];

  Future<void> connect() async {
    if (onTapEnabled) {
      if (isEnabled) {
        try {
          isLoading(true);
          accs = await ethereum!.requestAccount();
        } catch (e) {
          if (e == '4001') {
            isLoading(false);
          } else if (e == '') {}
        }

        if (accs.isNotEmpty) {
          isLoggedOut = false;
          currentAddress.value = accs.first;

          displayAddress.value = "${accs.first.substring(0, 5)}...${accs.first.substring(37, 41)}";
          onTapEnabled = false;
        }
        currentChain = await ethereum!.getChainId();

        walletConnect(true);

        isLoading(false);
        update();
      }
    } else {
      print('button disabled');
    }
  }

  void clear() {
    currentAddress.value = '';
    displayAddress.value = '';
    currentChain = -1;
    update();
  }

  void switchChain() async {
    await ethereum!.walletAddChain(
      chainId: 122,
      chainName: 'Fuse Network',
      nativeCurrency: CurrencyParams(name: 'Fuse', symbol: 'Fuse', decimals: 18),
      rpcUrls: ['https://rpc.fuse.io'],
    );
  }

  @override
  void onInit() {
    if (isEnabled) {
      if (ethereum!.isConnected()) {
        connect();
      }

      ethereum!.onAccountsChanged((accs) async {
        try {
          isLoading(true);
          accs = await ethereum!.requestAccount();
        } catch (e) {
          if (e == '4001') {
            isLoading(false);
          } else if (e == '') {}
        }

        if (accs.isNotEmpty) {
          isLoggedOut = false;
          currentAddress.value = accs.first;

          displayAddress.value = "${accs.first.substring(0, 5)}...${accs.first.substring(37, 41)}";
          onTapEnabled = false;
        }
        currentChain = await ethereum!.getChainId();

        walletConnect(true);

        isLoading(false);
        update();
      });

      ethereum!.onChainChanged((chain) async {
        try {
          isLoading(true);
          accs = await ethereum!.requestAccount();
        } catch (e) {
          if (e == '4001') {
            isLoading(false);
          } else if (e == '') {}
        }

        if (accs.isNotEmpty) {
          isLoggedOut = false;
          currentAddress.value = accs.first;

          displayAddress.value = "${accs.first.substring(0, 5)}...${accs.first.substring(37, 41)}";
          onTapEnabled = false;
        }
        currentChain = await ethereum!.getChainId();

        walletConnect(true);

        isLoading(false);
        update();
      });
    }

    super.onInit();
  }
}
