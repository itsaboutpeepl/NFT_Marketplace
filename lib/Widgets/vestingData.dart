import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/Widgets/header.dart';
import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/contract_controller.dart';
import 'package:nftapp/controllers/home_controller.dart';

class VestingData extends StatelessWidget {
  VestingData({Key? key}) : super(key: key);

  HomeController homeController = Get.put(HomeController());
  ContractController contractController = Get.put(ContractController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(connectWallet: homeController.connect),
          Padding(
            padding: const EdgeInsets.only(left: 38.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomText(text: 'Your Schedule Id'),
                    CustomText(
                      text: '0x######',
                      color: textColorBlack,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomText(text: 'Vested Amount'),
                    CustomText(
                      text: '##### PPL (£####)',
                      color: textColorBlack,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomText(text: 'Fully Vested'),
                    CustomText(
                      text: '##### Days',
                      color: Colors.black,
                    ),
                    CustomText2(
                      text: 'YYYY-MM-DD',
                      color: textColorGrey,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomText(text: 'Withdrawable Amount'),
                    CustomText(
                      text: '##### PPL (£####)',
                      color: textColorBlack,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CustomText(text: 'Withdrawal Available in'),
                    CustomText(
                      text: '##### Days',
                      color: textColorBlack,
                    ),
                    CustomText2(
                      text: 'YYYY-MM-DD',
                      color: textColorGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
