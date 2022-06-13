import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/Widgets/header.dart';
import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/contract_controller.dart';
import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/dateTimeFormat.dart';
import 'package:nftapp/helpers/responsiveness.dart';

class LargeHomePage extends StatelessWidget {
  LargeHomePage({Key? key}) : super(key: key);

  late double itemHeight;
  late double itemWidth;
  HomeController homeController = Get.put(HomeController());
  ContractController contractController = Get.put(ContractController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Header(),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: !ResponsiveWidget.isSmallScreen(context) ? 4.8 / 2 : 1 / 2,
          crossAxisSpacing: 0,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
          children: [
            Column(
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
              height: 2,
            ),
            Column(
              children: [
                const CustomText(text: 'Vested Amount'),
                Obx(
                  () => CustomText(
                    text: homeController.walletConnect.value
                        ? '${contractController.vestedTotal.value.toString()} PPL'
                        : "##### PPL",
                    color: textColorBlack,
                  ),
                )
              ],
            ),
            Column(
              children: [
                const CustomText(text: 'Fully Vested'),
                Obx(
                  () => CustomText(
                    text: homeController.walletConnect.value
                        ? '${contractController.endTimeDays.value.toString()} Days'
                        : "##### PPL ",
                    color: Colors.black,
                  ),
                ),
                Expanded(
                    child: Obx(
                  () => CustomText2(
                    text: homeController.walletConnect.value
                        ? dateFormatter(contractController.scheduleEnd.value)
                        : "YYYY-MM-DD",
                    color: textColorGrey,
                  ),
                )),
              ],
            ),
            Column(
              children: [
                const CustomText(text: 'Withdrawable Amount'),
                Obx(
                  () => CustomText(
                    text: homeController.walletConnect.value
                        ? '${contractController.currentAmountReleasable.value.toString()} PPL'
                        : "##### PPL",
                    color: textColorBlack,
                  ),
                )
              ],
            ),
            Column(
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
                Expanded(
                    child: Obx(
                  () => CustomText2(
                    text: homeController.walletConnect.value
                        ? dateFormatter(contractController.cliff.value)
                        : "YYYY-MM-DD",
                    color: textColorGrey,
                  ),
                )),
              ],
            ),
          ],
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
    );
  }
}
