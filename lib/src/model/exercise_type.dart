import 'dart:io';

import 'package:collection/collection.dart';

/// Exercise types for Wear OS
enum ExerciseType {
  /// unknown
  unknown(androidId: 0, iosId: null),

  /// alpineSkiing
  /// 
  /// iOS: downhillSkiing
  alpineSkiing(androidId: 92, iosId: 61),

  /// backpacking
  backpacking(84),

  /// backExtension
  backExtension(1),

  /// badminton
  badminton(androidId: 2, iosId: 4),

  /// barbellShoulderPress
  barbellShoulderPress(3),

  /// baseball
  baseball(androidId: 4, iosId: 5),

  /// basketball
  basketball(androidId: 5, iosId: 6),

  /// benchPress
  benchPress(6),

  /// benchSitUp
  benchSitUp(7),

  /// biking
  ///
  /// iOS: cycling
  biking(androidId: 8, iosId: 13),

  /// bikingStationary
  bikingStationary(9),

  /// bootCamp
  bootCamp(10),

  /// boxing
  boxing(androidId: 11, iosId: 8),

  /// burpee
  burpee(12),

  /// calisthenics
  calisthenics(13),

  /// cricket
  cricket(androidId: 14, iosId: 10),

  /// crossCountrySkiing
  crossCountrySkiing(androidId: 91, iosId: 60),

  /// crunch
  crunch(15),

  /// dancing
  dancing(androidId: 16, iosId: 14),

  /// deadlift
  deadlift(17),

  /// dumbbellCurlRightArm
  dumbbellCurlRightArm(18),

  /// dumbbellCurlLeftArm
  dumbbellCurlLeftArm(19),

  /// dumbbellFrontRaise
  dumbbellFrontRaise(20),

  /// dumbbellLateralRaise
  dumbbellLateralRaise(21),

  /// dumbbellTricepsExtensionLeftArm
  dumbbellTricepsExtensionLeftArm(22),

  /// dumbbellTricepsExtensionRightArm
  dumbbellTricepsExtensionRightArm(23),

  /// dumbbellTricepsExtensionTwoArm
  dumbbellTricepsExtensionTwoArm(24),

  /// elliptical
  elliptical(androidId: 25, iosId: 16),

  /// exerciseClass
  exerciseClass(26),

  /// fencing
  fencing(androidId: 27, iosId: 18),

  /// frisbeeDisc
  ///
  /// iOS: discSports
  frisbeeDisc(androidId: 28, iosId: 75),

  /// footballAmerican
  footballAmerican(androidId: 29, iosId: 1),

  /// footballAustralian
  footballAustralian(androidId: 30, iosId: 3),

  /// forwardTwist
  forwardTwist(31),

  /// golf
  golf(androidId: 32, iosId: 21),

  /// guidedBreathing
  guidedBreathing(33),

  /// horseRiding
  ///
  /// iOS: equestrianSports
  horseRiding(androidId: 88, iosId: 17),

  /// gymnastics
  gymnastics(androidId: 34, iosId: 22),

  /// handball
  handball(androidId: 35, iosId: 23),

  /// highIntensityIntervalTraining
  highIntensityIntervalTraining(androidId: 36, iosId: 63),

  /// hiking
  hiking(androidId: 37, iosId: 24),

  /// iceHockey
  ///
  /// iOS: hockey
  iceHockey(androidId: 38, iosId: 25),

  /// iceSkating
  ///
  /// iOS: skatingSports
  iceSkating(androidId: 39, iosId: 39),

  /// inlineSkating
  ///
  /// iOS: skatingSports
  inlineSkating(androidId: 87, iosId: 39),

  /// jumpRope
  jumpRope(androidId: 40, iosId: 64),

  /// jumpingJack
  jumpingJack(41),

  /// latPullDown
  latPullDown(42),

  /// lunge
  lunge(43),

  /// martialArts
  martialArts(androidId: 44, iosId: 28),

  /// meditation
  ///
  /// iOS: mindAndBody
  meditation(androidId: 45, iosId: 29),

  /// mountainBiking
  mountainBiking(85),

  /// orienteering
  orienteering(86),

  /// paddling
  ///
  /// iOS: paddleSports
  paddling(androidId: 46, iosId: 31),

  /// paraGliding
  paraGliding(47),

  /// pilates
  pilates(androidId: 48, iosId: 66),

  /// plank
  plank(49),

  /// racquetball
  racquetball(androidId: 50, iosId: 34),

  /// rockClimbing
  rockClimbing(androidId: 51, iosId: 9),

  /// rollerHockey
  ///
  /// iOS: hockey
  rollerHockey(androidId: 52, iosId: 25),

  /// rollerSkating
  ///
  /// iOS: skatingSports
  rollerSkating(androidId: 89, iosId: 39),

  /// rowing
  rowing(androidId: 53, iosId: 35),

  /// rowingMachine
  rowingMachine(54),

  /// running
  running(androidId: 55, iosId: 37),

  /// runningTreadmill
  runningTreadmill(56),

  /// rugby
  rugby(androidId: 57, iosId: 36),

  /// sailing
  sailing(androidId: 58, iosId: 38),

  /// scubaDiving
  scubaDiving(androidId: 59, iosId: 84),

  /// skating
  ///
  /// iOS: skatingSports
  skating(androidId: 60, iosId: 39),

  /// skiing
  ///
  /// iOS: downhillSkiing
  skiing(androidId: 61, iosId: 61),

  /// snowboarding
  snowboarding(androidId: 62, iosId: 67),

  /// snowshoeing
  snowshoeing(63),

  /// soccer
  soccer(androidId: 64, iosId: 41),

  /// softball
  softball(androidId: 65, iosId: 42),

  /// squash
  squash(androidId: 66, iosId: 43),

  /// squat
  squat(67),

  /// stairClimbing
  stairClimbing(androidId: 68, iosId: 44),

  /// stairClimbingMachine
  ///
  /// iOS: stairClimbing
  stairClimbingMachine(androidId: 69, iosId: 44),

  /// strengthTraining
  ///
  /// iOS: functionalStrengthTraining
  strengthTraining(androidId: 70, iosId: 20),

  /// stretching
  ///
  /// iOS: flexibility
  stretching(androidId: 71, iosId: 62),

  /// surfing
  ///
  /// iOS: surfingSports
  surfing(androidId: 72, iosId: 45),

  /// swimmingOpenWater
  ///
  /// iOS: Use with [SwimmingLocationType.openWater]
  swimmingOpenWater(androidId: 73, iosId: 46),

  /// swimmingPool
  ///
  /// iOS: Use with [SwimmingLocationType.pool]
  swimmingPool(androidId: 74, iosId: 46),

  /// tableTennis
  tableTennis(androidId: 75, iosId: 47),

  /// tennis
  tennis(androidId: 76, iosId: 48),

  /// upperTwist
  upperTwist(77),

  /// volleyball
  volleyball(androidId: 78, iosId: 51),

  /// walking
  walking(androidId: 79, iosId: 52),

  /// waterPolo
  waterPolo(androidId: 80, iosId: 54),

  /// weightlifting
  ///
  /// iOS: traditionalStrengthTraining
  weightlifting(androidId: 81, iosId: 50),

  /// workout
  ///
  /// iOS: other
  workout(androidId: 82, iosId: 3000),

  /// yachting
  yachting(90),

  /// yoga
  yoga(androidId: 83, iosId: 57),

  // MARK: - iOS only types

  /// archery
  archery(androidId: null, iosId: 2),

  /// bowling
  bowling(androidId: null, iosId: 7),

  /// crossTraining
  crossTraining(androidId: null, iosId: 11),

  /// curling
  curling(androidId: null, iosId: 12),

  /// danceInspiredTraining
  danceInspiredTraining(androidId: null, iosId: 15),

  /// fishing
  fishing(androidId: null, iosId: 19),

  /// hunting
  hunting(androidId: null, iosId: 26),

  /// lacrosse
  lacrosse(androidId: null, iosId: 27),

  /// mixedMetabolicCardioTraining
  mixedMetabolicCardioTraining(androidId: null, iosId: 30),

  /// play
  play(androidId: null, iosId: 32),

  /// preparationAndRecovery
  preparationAndRecovery(androidId: null, iosId: 33),

  /// snowSports
  snowSports(androidId: null, iosId: 40),

  /// trackAndField
  trackAndField(androidId: null, iosId: 49),

  /// waterFitness
  waterFitness(androidId: null, iosId: 53),

  /// waterSports
  waterSports(androidId: null, iosId: 55),

  /// wrestling
  wrestling(androidId: null, iosId: 56),

  /// barre
  barre(androidId: null, iosId: 58),

  /// coreTraining
  coreTraining(androidId: null, iosId: 59),

  /// kickboxing
  kickboxing(androidId: null, iosId: 65),

  /// stairs
  stairs(androidId: null, iosId: 68),

  /// stepTraining
  stepTraining(androidId: null, iosId: 69),

  /// wheelchairWalkPace
  wheelchairWalkPace(androidId: null, iosId: 70),

  /// wheelchairRunPace
  wheelchairRunPace(androidId: null, iosId: 71),

  /// taiChi
  taiChi(androidId: null, iosId: 72),

  /// mixedCardio
  mixedCardio(androidId: null, iosId: 73),

  /// handCycling
  handCycling(androidId: null, iosId: 74),

  /// fitnessGaming
  fitnessGaming(androidId: null, iosId: 76),

  /// cardioDance
  cardioDance(androidId: null, iosId: 77),

  /// socialDance
  socialDance(androidId: null, iosId: 78),

  /// pickleball
  pickleball(androidId: null, iosId: 79),

  /// cooldown
  cooldown(androidId: null, iosId: 80),

  /// swimBikeRun
  swimBikeRun(androidId: null, iosId: 82),

  /// transition
  transition(androidId: null, iosId: 83);

  /// The type id for Android
  final int? _androidId;

  /// The type id for iOS
  final int? _iosId;

  /// Returns the id for the current platform
  int? get id {
    if (Platform.isAndroid) {
      return _androidId;
    } else if (Platform.isIOS) {
      return _iosId;
    } else {
      return null;
    }
  }

  /// Constructor
  const ExerciseType({required int? androidId, required int? iosId})
      : _iosId = iosId,
        _androidId = androidId;

  /// Returns the [ExerciseType] for the given [id]
  static ExerciseType? fromId(int id) {
    if (Platform.isAndroid) {
      return ExerciseType.values.firstWhereOrNull((e) => e._androidId == id);
    } else if (Platform.isIOS) {
      return ExerciseType.values.firstWhereOrNull((e) => e._iosId == id);
    } else {
      return null;
    }
  }
}
