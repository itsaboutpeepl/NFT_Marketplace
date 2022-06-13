import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/contract_controller.dart';
import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/responsiveness.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo-red.png',
          width: 150,
          height: 150,
        ),
        SizedBox(
          width: !ResponsiveWidget.isSmallScreen(context) ? itemPadding + 80 : itemPadding - 80,
        ),
        ConnectWallet(),
      ],
    );
  }
}

class ConnectWallet extends StatelessWidget {
  ConnectWallet({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final ContractController contractController = Get.put(ContractController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        homeController.connect().then((value) async {
          if (homeController.isInOperatingChain) {
            final hasVested = await contractController.getUserVestingCount(homeController.currentAddress.value);
            // print(hasVested);
            if (hasVested != BigInt.zero) {
              contractController.getScheduleByAddressAndIndex(
                  index: 0, beneficaryAddress: homeController.currentAddress.value);
            }
          }

          homeController.isLoading(false);
        });
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(defaultPadding * 0.75),
          decoration: BoxDecoration(
            color: homeController.isLoading.value ? textColorBlack : callToAction,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: homeController.isLoading.value
              ? const CircularProgressIndicator(
                  color: callToAction,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Obx(() {
                    return CustomText(
                      text: homeController.displayAddress.value.isEmpty
                          ? "Connect Wallet"
                          : homeController.displayAddress.value,
                      color: Colors.white,
                      size: 18,
                    );
                  }),
                ),
        ),
      ),
    );
  }
}
