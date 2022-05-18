import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/Widgets/header.dart';
import 'package:nftapp/Widgets/vestingData.dart';
import 'package:nftapp/Widgets/vestingDataSmallScreen.dart';

import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/contract_controller.dart';
import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/responsiveness.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 5;

    final HomeController homeController = Get.put(HomeController());
    final ContractController contractController = Get.put(ContractController());

    return Scaffold(
      body: Obx(
        () {
          var currentaddress = '';
          var text = '';

          if (homeController.isConnected && homeController.isInOperatingChain) {
            // h.getVestingContractInformation();
            // h.getVestingSchedulesCountByBeneficiary();

            // h.getScheduleByAddressAndIndex(0, h.currentAddress);

            // h.getSchedulesInfo();

            contractController.getVestingContractInformation();

            contractController.getVestingSchedulesCountByBeneficiary();
            contractController.getScheduleByAddressAndIndex(
                0, homeController.currentAddress.value);
            contractController.getSchedulesInfo();

            text = 'Connected';
          } else if (homeController.isConnected &&
              !homeController.isInOperatingChain) {
            text = 'Wrong Chain! Please connect to FUSE Network';
          } else if (homeController.isEnabled) {
            return SingleChildScrollView(
                child: ResponsiveWidget.isSmallScreen(context)
                    ? VestingData()
                    : const VestingDataSmall());
          } else {
            text = 'Your browser is not Supported';
          }

          return (homeController.isConnected &&
                  homeController.isInOperatingChain)
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ResponsiveWidget.isSmallScreen(context)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Header(
                              walletState: homeController.displayAddress,
                              connectWallet: () {},
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                          text: 'Your Schedule Id'),
                                      contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText(
                                              text: contractController
                                                          .vestedChecker <=
                                                      0
                                                  ? 'No Vesting Schedule Detected'
                                                  : contractController
                                                      .displayScheduleID,
                                              color: textColorBlack,
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(text: 'Vested Amount'),
                                      contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText(
                                              text: contractController
                                                          .vestedChecker <
                                                      1
                                                  ? '0 PPL (£####)'
                                                  : '${contractController.vestedTotal} PPL (£####)',
                                              color: textColorBlack,
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(text: 'Fully Vested'),
                                      contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText(
                                              text: contractController
                                                          .endTimeChecker <
                                                      1
                                                  ? '0 Days'
                                                  : '${contractController.endTimeDays} Days',
                                              color: Colors.black,
                                            ),
                                      contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText2(
                                              text: contractController
                                                          .startTimeChecker ==
                                                      0
                                                  ? 'No Schedules found'
                                                  : contractController.endTime,
                                              color: textColorGrey,
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                          text: 'Withdrawable Amount'),
                                      //TODO: LOGIC that waits for amount released
                                      CustomText(
                                        text:
                                            '${contractController.amountReleasable} PPL (£####)',
                                        color: textColorBlack,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                          text: 'Withdrawal Available in'),
                                      contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText(
                                              text: contractController
                                                          .cliffChecker <
                                                      0
                                                  ? '0 Days'
                                                  : '${contractController.cliffEndDays} Days',
                                              color: textColorBlack,
                                            ),
                                      CustomText2(
                                        text: contractController.cliff,
                                        color: textColorGrey,
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: contractController.isTime >= 0 &&
                                            contractController
                                                    .amountReleasable !=
                                                0
                                        ? () {}
                                        : contractController.release,
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          defaultPadding * 0.75),
                                      decoration: const BoxDecoration(
                                        color: callToAction,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding / 2),
                                        child: CustomText(
                                          text: "Withdraw",
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Header(
                              walletState: homeController.displayAddress,
                              connectWallet: () {},
                            ),
                            GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 5 / 2,
                              crossAxisSpacing: 0,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  left: itemWidth, right: itemWidth),
                              children: [
                                Column(
                                  children: [
                                    const CustomText(text: 'Your Schedule Id'),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText(
                                            text: contractController
                                                        .vestedChecker <=
                                                    0
                                                ? 'No Vesting Schedule Detected'
                                                : contractController
                                                    .displayScheduleID,
                                            color: textColorBlack,
                                          ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  children: [
                                    const CustomText(text: 'Vested Amount'),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText(
                                            text: contractController
                                                        .vestedChecker <
                                                    1
                                                ? '0 PPL (£####)'
                                                : '${contractController.vestedTotal} PPL (£####)',
                                            color: textColorBlack,
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CustomText(text: 'Fully Vested'),
                                    Container(
                                      child: contractController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                          : CustomText(
                                              text: contractController
                                                          .endTimeChecker <
                                                      1
                                                  ? '0 Days'
                                                  : '${contractController.endTimeDays} Days',
                                              color: Colors.black,
                                            ),
                                    ),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText2(
                                            text: contractController
                                                        .startTimeChecker ==
                                                    0
                                                ? 'No Schedules found'
                                                : contractController.endTime,
                                            color: textColorGrey,
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CustomText(
                                        text: 'Withdrawable Amount'),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText(
                                            text:
                                                '${contractController.amountReleasable} PPL (£####)',
                                            color: textColorBlack,
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CustomText(
                                        text: 'Withdrawal Available in'),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText(
                                            text: contractController
                                                        .cliffChecker <
                                                    0
                                                ? '0 Days'
                                                : '${contractController.cliffEndDays} Days',
                                            color: textColorBlack,
                                          ),
                                    contractController.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.red,
                                          )
                                        : CustomText2(
                                            text: contractController.cliff,
                                            color: textColorGrey,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            if (contractController.isTime >= 0 &&
                                contractController.vestedChecker > 0)
                              InkWell(
                                onTap: () {
                                  contractController.release();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      defaultPadding * 0.75),
                                  decoration: const BoxDecoration(
                                    color: callToAction,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 2),
                                    child: CustomText(
                                      text: "Withdraw",
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                )
              : Center(child: CustomText(text: text));
        },
      ),
    );
  }
}
