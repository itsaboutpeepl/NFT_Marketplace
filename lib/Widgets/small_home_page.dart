import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/Widgets/header.dart';
import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/contract_controller.dart';
import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/dateTimeFormat.dart';

class SmallHomePage extends StatelessWidget {
  SmallHomePage({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());
  final ContractController contractController = Get.put(ContractController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(),
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Your Schedule Id'),
                  Obx(
                    () => CustomText(
                      text: homeController.walletConnect.value
                          ? contractController.currentScheduleID.value.toString()
                          : '#####',
                      color: textColorBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Vested Amount'),
                  Obx(
                    () => CustomText(
                      text: homeController.walletConnect.value
                          ? '${contractController.vestedTotal.value.toString()} PPL'
                          : "##### PPL ",
                      color: textColorBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Fully Vested'),
                  Obx(
                    () => CustomText(
                      text: homeController.walletConnect.value
                          ? '${contractController.endTimeDays.value.toString()} Days'
                          : "##### PPL",
                      color: Colors.black,
                    ),
                  ),
                  Obx(
                    () => CustomText2(
                      text: homeController.walletConnect.value
                          ? dateFormatter(contractController.scheduleEnd.value)
                          : "YYYY-MM-DD",
                      color: textColorGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Withdrawable Amount'),
                  Obx(
                    () => CustomText(
                      text: homeController.walletConnect.value
                          ? '${contractController.currentAmountReleasable.value.toString()} PPL '
                          : "##### PPL ",
                      color: textColorBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Withdrawal Available in'),
                  Obx(
                    () => CustomText(
                      text: homeController.walletConnect.value
                          ? '${contractController.cliffEndDays.value.toString()} Days'
                          : "##### Days ",
                      color: textColorBlack,
                    ),
                  ),
                  Obx(
                    () => CustomText2(
                      text: homeController.walletConnect.value
                          ? dateFormatter(contractController.cliff.value)
                          : "YYYY-MM-DD",
                      color: textColorGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(
                () => Center(
                    child: contractController.currentAmountReleasable.value == contractController.vestedTotal.value &&
                            contractController.isContractFullyVested
                        ? InkWell(
                            onTap: () {
                              try {
                                contractController.release();
                              } finally {
                                contractController.getScheduleByAddressAndIndex(
                                    index: 0, beneficaryAddress: homeController.currentAddress.value);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(defaultPadding * 0.75),
                              decoration: const BoxDecoration(
                                color: callToAction,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                                  child: CustomText(
                                    text: "Withdraw",
                                    color: Colors.white,
                                    size: 18,
                                  )),
                            ),
                          )
                        : Container()),
              ),
            ],
          ),
        )
      ],
    );
  }
}
