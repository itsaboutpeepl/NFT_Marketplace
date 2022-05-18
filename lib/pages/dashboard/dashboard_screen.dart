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

    return GetBuilder<HomeController>(
        builder: (h) => Scaffold(
              body: Builder(
                builder: (_) {
                  var currentaddress = '';
                  var text = '';

                  if (h.isConnected && h.isInOperatingChain) {
                    // h.getVestingContractInformation();
                    // h.getVestingSchedulesCountByBeneficiary();

                    // h.getScheduleByAddressAndIndex(0, h.currentAddress);

                    // h.getSchedulesInfo();
                    final ContractController contractController =
                        Get.put(ContractController());

                    Get.find<ContractController>()
                        .getVestingContractInformation();

                    Get.find<ContractController>()
                        .getVestingSchedulesCountByBeneficiary();
                    Get.find<ContractController>()
                        .getScheduleByAddressAndIndex(0, h.currentAddress);
                    Get.find<ContractController>().getSchedulesInfo();

                    text = 'Connected';
                  } else if (h.isConnected && !h.isInOperatingChain) {
                    text = 'Wrong Chain! Please connect to FUSE Network';
                  } else if (h.isEnabled) {
                    return SingleChildScrollView(
                        child: ResponsiveWidget.isSmallScreen(context)
                            ? VestingData()
                            : const VestingDataSmall());
                  } else {
                    text = 'Your browser is not Supported';
                  }

                  return (h.isConnected && h.isInOperatingChain)
                      ? GetBuilder<ContractController>(builder: (context) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: ResponsiveWidget.isSmallScreen(_)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Header(
                                        walletState: h.displayAddress,
                                        connectWallet: () {},
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 38.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const CustomText(
                                                    text: 'Your Schedule Id'),
                                                Get.find<ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText(
                                                        text: Get.find<ContractController>()
                                                                    .vestedChecker <=
                                                                0
                                                            ? 'No Vesting Schedule Detected'
                                                            : Get.find<
                                                                    ContractController>()
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
                                                const CustomText(
                                                    text: 'Vested Amount'),
                                                Get.find<ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText(
                                                        text: Get.find<ContractController>()
                                                                    .vestedChecker <
                                                                1
                                                            ? '0 PPL (£####)'
                                                            : '${Get.find<ContractController>().vestedTotal} PPL (£####)',
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
                                                    text: 'Fully Vested'),
                                                Get.find<ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText(
                                                        text: Get.find<ContractController>()
                                                                    .endTimeChecker <
                                                                1
                                                            ? '0 Days'
                                                            : '${Get.find<ContractController>().endTimeDays} Days',
                                                        color: Colors.black,
                                                      ),
                                                Get.find<ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText2(
                                                        text: Get.find<ContractController>()
                                                                    .startTimeChecker ==
                                                                0
                                                            ? 'No Schedules found'
                                                            : Get.find<
                                                                    ContractController>()
                                                                .endTime,
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
                                                    text:
                                                        'Withdrawable Amount'),
                                                //TODO: LOGIC that waits for amount released
                                                CustomText(
                                                  text:
                                                      '${Get.find<ContractController>().amountReleasable} PPL (£####)',
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
                                                    text:
                                                        'Withdrawal Available in'),
                                                Get.find<ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText(
                                                        text: Get.find<ContractController>()
                                                                    .cliffChecker <
                                                                0
                                                            ? '0 Days'
                                                            : '${Get.find<ContractController>().cliffEndDays} Days',
                                                        color: textColorBlack,
                                                      ),
                                                CustomText2(
                                                  text: Get.find<
                                                          ContractController>()
                                                      .cliff,
                                                  color: textColorGrey,
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: Get.find<ContractController>()
                                                              .isTime >=
                                                          0 &&
                                                      Get.find<ContractController>()
                                                              .amountReleasable !=
                                                          0
                                                  ? () {}
                                                  : Get.find<
                                                          ContractController>()
                                                      .release,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                    defaultPadding * 0.75),
                                                decoration: const BoxDecoration(
                                                  color: callToAction,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          defaultPadding / 2),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Header(
                                        walletState: h.displayAddress,
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
                                              const CustomText(
                                                  text: 'Your Schedule Id'),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText(
                                                      text: Get.find<ContractController>()
                                                                  .vestedChecker <=
                                                              0
                                                          ? 'No Vesting Schedule Detected'
                                                          : Get.find<
                                                                  ContractController>()
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
                                              const CustomText(
                                                  text: 'Vested Amount'),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText(
                                                      text: Get.find<ContractController>()
                                                                  .vestedChecker <
                                                              1
                                                          ? '0 PPL (£####)'
                                                          : '${Get.find<ContractController>().vestedTotal} PPL (£####)',
                                                      color: textColorBlack,
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const CustomText(
                                                  text: 'Fully Vested'),
                                              Container(
                                                child: Get.find<
                                                            ContractController>()
                                                        .isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.red,
                                                      )
                                                    : CustomText(
                                                        text: Get.find<ContractController>()
                                                                    .endTimeChecker <
                                                                1
                                                            ? '0 Days'
                                                            : '${Get.find<ContractController>().endTimeDays} Days',
                                                        color: Colors.black,
                                                      ),
                                              ),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText2(
                                                      text: Get.find<ContractController>()
                                                                  .startTimeChecker ==
                                                              0
                                                          ? 'No Schedules found'
                                                          : Get.find<
                                                                  ContractController>()
                                                              .endTime,
                                                      color: textColorGrey,
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const CustomText(
                                                  text: 'Withdrawable Amount'),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText(
                                                      text:
                                                          '${Get.find<ContractController>().amountReleasable} PPL (£####)',
                                                      color: textColorBlack,
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const CustomText(
                                                  text:
                                                      'Withdrawal Available in'),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText(
                                                      text: Get.find<ContractController>()
                                                                  .cliffChecker <
                                                              0
                                                          ? '0 Days'
                                                          : '${Get.find<ContractController>().cliffEndDays} Days',
                                                      color: textColorBlack,
                                                    ),
                                              Get.find<ContractController>()
                                                      .isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : CustomText2(
                                                      text: Get.find<
                                                              ContractController>()
                                                          .cliff,
                                                      color: textColorGrey,
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (Get.find<ContractController>()
                                                  .isTime >=
                                              0 &&
                                          Get.find<ContractController>()
                                                  .vestedChecker >
                                              0)
                                        InkWell(
                                          onTap: () {
                                            Get.find<ContractController>()
                                                .release();
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
                                                  horizontal:
                                                      defaultPadding / 2),
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
                          );
                        })
                      : Center(child: CustomText(text: text));
                },
              ),
            ));
  }
}
