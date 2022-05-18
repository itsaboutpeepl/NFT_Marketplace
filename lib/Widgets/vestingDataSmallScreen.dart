import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nftapp/Widgets/customText.dart';
import 'package:nftapp/Widgets/header.dart';
import 'package:nftapp/constants/style.dart';
import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/responsiveness.dart';

class VestingDataSmall extends StatelessWidget {
  const VestingDataSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 5;

    HomeController homeController = Get.put(HomeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Header(
          connectWallet: homeController.connect,
        ),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio:
              !ResponsiveWidget.isSmallScreen(context) ? 4.8 / 2 : 1 / 2,
          crossAxisSpacing: 0,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: itemWidth, right: itemWidth),
          children: [
            Column(
              children: const [
                CustomText(text: 'Your Schedule Id'),
                CustomText(
                  text: '0x######',
                  color: textColorBlack,
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Column(
              children: const [
                CustomText(text: 'Vested Amount'),
                CustomText(
                  text: '##### PPL (£####)',
                  color: textColorBlack,
                ),
              ],
            ),
            Column(
              children: const [
                CustomText(text: 'Fully Vested'),
                CustomText(
                  text: '##### Days',
                  color: Colors.black,
                ),
                Expanded(
                  child: CustomText2(
                    text: 'YYYY-MM-DD',
                    color: textColorGrey,
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                CustomText(text: 'Withdrawable Amount'),
                CustomText(
                  text: '##### PPL (£####)',
                  color: textColorBlack,
                ),
              ],
            ),
            Column(
              children: const [
                CustomText(text: 'Withdrawal Available in'),
                CustomText(
                  text: '##### Days',
                  color: textColorBlack,
                ),
                Expanded(
                  child: CustomText2(
                    text: 'YYYY-MM-DD',
                    color: textColorGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
