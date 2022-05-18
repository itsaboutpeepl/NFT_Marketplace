import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

import 'package:nftapp/controllers/home_controller.dart';
import 'package:nftapp/helpers/abi.dart';
import 'package:nftapp/helpers/dateTimeFormat.dart';
import 'package:nftapp/helpers/decimal_handler.dart';

class ContractController extends GetxController {
  final HomeController homeController = Get.put(HomeController());

  String displayScheduleID = '';
  final vestingContract = Contract('0xfC75C482058d7f521Db493D103247953d5C9d2AF',
      Interface(abi), provider!.getSigner());

  final contractAddress = '0xfC75C482058d7f521Db493D103247953d5C9d2AF';

  static const TOKENVESTING_ADDRESS =
      '0xfC75C482058d7f521Db493D103247953d5C9d2AF';

  static const PEEPL_ADDRESS = '0xa2C7CdB72d177f6259cD12a9A06Fdfd9625419D4';

  ContractERC20? testToken;

  BigInt yourTokenBalance = BigInt.zero;

  int scheduleCount = 0;

  Contract? tokenVesting;

  dynamic amountReleasable = 0.obs;

  BigInt withdrawableAmount = BigInt.zero;

  var displayBalance;

  var displayID;

  String startTime = '';
  String endTime = '';
  String endTimeDays = '';
  String cliff = '';
  String cliffEndDays = '';
  int cliffChecker = 1;
  int vestedChecker = 1;
  int endTimeChecker = 1;
  int startTimeChecker = 1;
  var vestedTotal;
  bool revoked = true;
  int isTime = -1;
  bool isLoading = false;

  List<String> scheduleIDs = [];
  List<String> scheduleIDdropdown = [];

  init() {
    getVestingContractInformation();
  }

  @override
  void onInit() {
    init();
    interval(amountReleasable, (_) {
      print("Doing");
    }, time: const Duration(seconds: 5));
    super.onInit();
  }
//   //Contract Methods

  getVestingSchedulesCountByBeneficiary() async {
    final BigInt response = await vestingContract.call<BigInt>(
        'getVestingSchedulesCountByBeneficiary',
        [Get.find<HomeController>().currentAddress]);

    scheduleCount = response.toInt();
    update();
  }

  //TODO: Move to a separate file e.g contract controller
  getScheduleByAddressAndIndex(int id, String beneficiary) async {
    final schedule = await vestingContract
        .call('getVestingScheduleByAddressAndIndex', [beneficiary, id]);

    startTime = readTimestamp(
      int.parse(
        schedule[3].toString(),
      ),
    );

    // startTimeChecker = int.parse(startTime);

    cliff = readTimestamp(int.parse(schedule[2].toString()));

    final total = int.parse(schedule[7].toString());

    vestedTotal = toDecimal(BigInt.parse(schedule[7].toString()), 18);
    vestedChecker = int.parse(vestedTotal.toString());
    final tempStart = int.parse(schedule[3].toString());
    final tempDuration = int.parse(schedule[4].toString());

//TODO: Add error for no vesting schedule

    endTime = readTimestamp(tempStart + tempDuration);

    DateTime tempEnd =
        DateTime.fromMillisecondsSinceEpoch((tempStart + tempDuration) * 1000);
    DateTime tempStartTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(schedule[3].toString()) * 1000);

    DateTime tempCliff = DateTime.fromMillisecondsSinceEpoch(
        int.parse(schedule[2].toString()) * 1000);
    endTimeDays = daysBetween(DateTime.now(), tempEnd);
    endTimeChecker = int.parse(endTimeDays);
    cliffEndDays = daysBetween(DateTime.now(), tempCliff);
    cliffChecker = int.parse(cliffEndDays);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    isTime = currentTime.compareTo((tempStart + tempDuration) * 1000);

    update();
  }

  Future<List<String>> getUserVestingSchedulesList(
      int amountOfSchedules, String address) async {
    List<String> schedules = [];
    for (int i = 0; i < amountOfSchedules; i++) {
      final vestingScheduleId = await vestingContract.call(
          'computeVestingScheduleIdForAddressAndIndex',
          [address, BigInt.from(i)]);
      schedules.add(vestingScheduleId);

      //To add schedule dropdown list
      // scheduleIDdropdown.add(scheduleIDs.length.toString());
    }
    return schedules;

    // update();
  }

  getVestingContractInformation() async {
    isLoading = true;
    withdrawableAmount =
        await vestingContract.call<BigInt>('getWithdrawableAmount');

    update();
  }

  computeAmountReleasable(String id) async {
    try {
      final BigInt releaseable =
          await vestingContract.call<BigInt>('computeReleasableAmount', [id]);

      amountReleasable = toDecimal(releaseable, 18);
    } catch (e) {
      amountReleasable = 0;
    } finally {
      update();
    }
  }

  getSchedulesInfo() async {
    try {
      final List<String> lists = await getUserVestingSchedulesList(
          1, Get.find<HomeController>().currentAddress);

      scheduleIDs = List.from(lists);
      displayScheduleID = scheduleIDs[0].substring(0, 5) +
          "..." +
          scheduleIDs[0].substring(61, 66);
    } catch (error) {
      print(error);
    } finally {
      computeAmountReleasable(scheduleIDs[0]);
      isLoading = false;

      update();
    }

    // await computeAmountReleasable(BigInt.parse(scheduleIDs[0]));
  }

  release() async {
    final BigInt releaseable = await vestingContract
        .call<BigInt>('computeReleasableAmount', [scheduleIDs[0]]);
    await vestingContract
        .call<BigInt>('release', [scheduleIDs[0], releaseable]);
  }
}
