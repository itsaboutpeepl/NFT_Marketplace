import 'package:decimal/decimal.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:nftapp/constants/addresses.dart';
import 'package:nftapp/controllers/home_controller.dart';

import 'package:nftapp/helpers/abi.dart';
import 'package:nftapp/helpers/dateTimeFormat.dart';
import 'package:nftapp/helpers/decimal_handler.dart';
import 'package:nftapp/models/schedules.dart';

class ContractController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  List<Schedules> vestingSchedules = <Schedules>[];

  String? currentWalletAddress;

  final vestingContract = Contract(VESTING_CONTRACT, Interface(abi), provider!.getSigner());

  bool hasVestingSchedule = false;
  Rx<Decimal> currentAmountReleasable = Decimal.one.obs;

  late DateTime scheduleStart;

  String? displayScheduleID;
  Rx<DateTime> scheduleEnd = DateTime.now().obs;
  Rx<DateTime> cliff = DateTime.now().obs;

  RxInt endTimeDays = 0.obs;
  RxInt cliffEndDays = 0.obs;

  bool vestedChecker = false;

  Rx<Decimal> vestedTotal = Decimal.zero.obs;

  int scheduleCount = 0;

  bool isContractFullyVested = false;

  bool isLoading = false;

  List<String> scheduleIDs = [];

  RxString currentScheduleID = "".obs;

  RxBool isRevoked = true.obs;

  var incrementer = 0.obs;

  // BigInt withdrawableAmount = BigInt.zero;

  // int scheduleCount = 0;

  @override
  onInit() {
    interval(incrementer, (_) => getSchedulesInfo(), time: const Duration(seconds: 10));
    super.onInit();
  }

  //SmartContract functions: Check assets/abi for usage

  Future<bool> getSchedulesInfo() async {
    try {
      scheduleIDs = await getUserVestingSchedulesList();

      currentAmountReleasable(toDecimal(await computeAmountReleasable(scheduleIDs[0]), 18));

      isLoading = false;
      currentScheduleID(scheduleIDs[0].substring(0, 5) + "..." + scheduleIDs[0].substring(61, 66));

      isContractFullyVested = DateTime.now().compareTo(scheduleEnd.value) > 0 ? true : false;

      update();
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    } finally {
      incrementer.value++;
    }
  }

  void getScheduleByAddressAndIndex({required int index, required String beneficaryAddress}) async {
    isLoading = true;

    await getSchedulesInfo();

    final schedule = await vestingContract.call('getVestingScheduleByAddressAndIndex', [beneficaryAddress, index]);
    print(schedule);
    isRevoked(schedule[9]);

    scheduleStart = readTimeStampToDate(
      int.parse(
        schedule[3].toString(),
      ),
    );

    final DateTime scheduleDuration = readTimeStampToDate(
      int.parse(
        schedule[4].toString(),
      ),
    );

    scheduleEnd(DateTime.fromMillisecondsSinceEpoch(
        scheduleStart.millisecondsSinceEpoch + scheduleDuration.millisecondsSinceEpoch));

    cliff(readTimeStampToDate(
      int.parse(
        schedule[2].toString(),
      ),
    ));

    vestedTotal(toDecimal(BigInt.parse(schedule[7].toString()), 18));

    vestedChecker = vestedTotal.value == Decimal.zero ? false : true;

    endTimeDays(daysBetweenInt(DateTime.now(), scheduleEnd.value));
    cliffEndDays(daysBetweenInt(DateTime.now(), cliff.value));

    cliffEndDays.value >= 0 ? cliffEndDays(daysBetweenInt(DateTime.now(), cliff.value)) : cliffEndDays(0);
    endTimeDays.value >= 0 ? endTimeDays(daysBetweenInt(DateTime.now(), scheduleEnd.value)) : endTimeDays(0);

    vestingSchedules.add(Schedules(
      scheduleID: currentScheduleID.value.toString(),
      vestedAmount: vestedTotal.value.toString(),
      fullyVestedDays: endTimeDays.value.toString(),
      fullyVestedDateTime: dateFormatter(scheduleEnd.value),
      withdrawableAmount: currentAmountReleasable.value.toString(),
      cliffEndDays: cliffEndDays.value.toString(),
      cliffDateTime: dateFormatter(cliff.value),
      isRevoked: isRevoked.value,
    ));

    update();
  }

  Future<List<String>> getUserVestingSchedulesList() async {
    BigInt scheduleCount = await getUserVestingCount(homeController.currentAddress.value);

    List<String> schedules = [];

    for (int i = 0; i < scheduleCount.toInt(); i++) {
      final vestingScheduleId = await vestingContract
          .call('computeVestingScheduleIdForAddressAndIndex', [homeController.currentAddress.value, BigInt.from(i)]);
      schedules.add(vestingScheduleId);
    }

    return schedules;
  }

  Future<BigInt> getUserVestingCount(String beneficiary) async {
    return await vestingContract.call<BigInt>('getVestingSchedulesCountByBeneficiary', [beneficiary]);
  }

  Future<BigInt> computeAmountReleasable(String id) async {
    return await vestingContract.call<BigInt>('computeReleasableAmount', [id]);
  }

  void release() async {
    final BigInt releaseable = await vestingContract.call<BigInt>('computeReleasableAmount', [scheduleIDs[0]]);
    try {
      await vestingContract.call<BigInt>('release', [scheduleIDs[0], releaseable]);
    } catch (e) {
      print(e);
    }
  }
}
