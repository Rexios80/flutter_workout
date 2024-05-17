import 'dart:io';

import 'package:collection/collection.dart';

abstract class _AndroidExercise {
  _AndroidExercise._();

  static const unknown = 0;
  static const alpineSkiing = 92;
  static const backpacking = 84;
  static const backExtension = 1;
  static const badminton = 2;
  static const barbellShoulderPress = 3;
  static const baseball = 4;
  static const basketball = 5;
  static const benchPress = 6;
  static const benchSitUp = 7;
  static const biking = 8;
  static const bikingStationary = 9;
  static const bootCamp = 10;
  static const boxing = 11;
  static const burpee = 12;
  static const calisthenics = 13;
  static const cricket = 14;
  static const crossCountrySkiing = 91;
  static const crunch = 15;
  static const dancing = 16;
  static const deadlift = 17;
  static const dumbbellCurlRightArm = 18;
  static const dumbbellCurlLeftArm = 19;
  static const dumbbellFrontRaise = 20;
  static const dumbbellLateralRaise = 21;
  static const dumbbellTricepsExtensionLeftArm = 22;
  static const dumbbellTricepsExtensionRightArm = 23;
  static const dumbbellTricepsExtensionTwoArm = 24;
  static const elliptical = 25;
  static const exerciseClass = 26;
  static const fencing = 27;
  static const frisbeeDisc = 28;
  static const footballAmerican = 29;
  static const footballAustralian = 30;
  static const forwardTwist = 31;
  static const golf = 32;
  static const guidedBreathing = 33;
  static const horseRiding = 88;
  static const gymnastics = 34;
  static const handball = 35;
  static const highIntensityIntervalTraining = 36;
  static const hiking = 37;
  static const iceHockey = 38;
  static const iceSkating = 39;
  static const inlineSkating = 87;
  static const jumpRope = 40;
  static const jumpingJack = 41;
  static const latPullDown = 42;
  static const lunge = 43;
  static const martialArts = 44;
  static const meditation = 45;
  static const mountainBiking = 85;
  static const orienteering = 86;
  static const paddling = 46;
  static const paraGliding = 47;
  static const pilates = 48;
  static const plank = 49;
  static const racquetball = 50;
  static const rockClimbing = 51;
  static const rollerHockey = 52;
  static const rollerSkating = 89;
  static const rowing = 53;
  static const rowingMachine = 54;
  static const running = 55;
  static const runningTreadmill = 56;
  static const rugby = 57;
  static const sailing = 58;
  static const scubaDiving = 59;
  static const skating = 60;
  static const skiing = 61;
  static const snowboarding = 62;
  static const snowshoeing = 63;
  static const soccer = 64;
  static const softball = 65;
  static const squash = 66;
  static const squat = 67;
  static const stairClimbing = 68;
  static const stairClimbingMachine = 69;
  static const strengthTraining = 70;
  static const stretching = 71;
  static const surfing = 72;
  static const swimmingOpenWater = 73;
  static const swimmingPool = 74;
  static const tableTennis = 75;
  static const tennis = 76;
  static const upperTwist = 77;
  static const volleyball = 78;
  static const walking = 79;
  static const waterPolo = 80;
  static const weightlifting = 81;
  static const workout = 82;
  static const yachting = 90;
  static const yoga = 83;
}

abstract class _IosExercise {
  _IosExercise._();

  static const americanFootball = 1;
  static const archery = 2;
  static const australianFootball = 3;
  static const badminton = 4;
  static const baseball = 5;
  static const basketball = 6;
  static const bowling = 7;
  static const boxing = 8;
  static const climbing = 9;
  static const cricket = 10;
  static const crossTraining = 11;
  static const curling = 12;
  static const cycling = 13;
  static const elliptical = 16;
  static const equestrianSports = 17;
  static const fencing = 18;
  static const fishing = 19;
  static const functionalStrengthTraining = 20;
  static const golf = 21;
  static const gymnastics = 22;
  static const handball = 23;
  static const hiking = 24;
  static const hockey = 25;
  static const hunting = 26;
  static const lacrosse = 27;
  static const martialArts = 28;
  static const mindAndBody = 29;
  static const paddleSports = 31;
  static const play = 32;
  static const preparationAndRecovery = 33;
  static const racquetball = 34;
  static const rowing = 35;
  static const rugby = 36;
  static const running = 37;
  static const sailing = 38;
  static const skatingSports = 39;
  static const snowSports = 40;
  static const soccer = 41;
  static const softball = 42;
  static const squash = 43;
  static const stairClimbing = 44;
  static const surfingSports = 45;
  static const swimming = 46;
  static const tableTennis = 47;
  static const tennis = 48;
  static const trackAndField = 49;
  static const traditionalStrengthTraining = 50;
  static const volleyball = 51;
  static const walking = 52;
  static const waterFitness = 53;
  static const waterPolo = 54;
  static const waterSports = 55;
  static const wrestling = 56;
  static const yoga = 57;
  static const barre = 58;
  static const coreTraining = 59;
  static const crossCountrySkiing = 60;
  static const downhillSkiing = 61;
  static const flexibility = 62;
  static const highIntensityIntervalTraining = 63;
  static const jumpRope = 64;
  static const kickboxing = 65;
  static const pilates = 66;
  static const snowboarding = 67;
  static const stairs = 68;
  static const stepTraining = 69;
  static const wheelchairWalkPace = 70;
  static const wheelchairRunPace = 71;
  static const taiChi = 72;
  static const mixedCardio = 73;
  static const handCycling = 74;
  static const discSports = 75;
  static const fitnessGaming = 76;
  static const cardioDance = 77;
  static const socialDance = 78;
  static const pickleball = 79;
  static const cooldown = 80;
  static const swimBikeRun = 82;
  static const transition = 83;
  static const underwaterDiving = 84;
  static const other = 3000;
}

/// Exercise types
///
/// Names are Wear OS first, then iOS
enum ExerciseType {
  /// unknown
  unknown(androidId: _AndroidExercise.unknown, iosId: _IosExercise.other),

  /// alpineSkiing
  alpineSkiing(
    androidId: _AndroidExercise.alpineSkiing,
    iosId: _IosExercise.downhillSkiing,
  ),

  /// backpacking
  backpacking(
    androidId: _AndroidExercise.backpacking,
    iosId: _IosExercise.hiking,
  ),

  /// backExtension
  backExtension(
    androidId: _AndroidExercise.backExtension,
    iosId: _IosExercise.traditionalStrengthTraining,
  ),

  /// badminton
  badminton(
    androidId: _AndroidExercise.badminton,
    iosId: _IosExercise.badminton,
  ),

  /// barbellShoulderPress
  barbellShoulderPress(
    androidId: _AndroidExercise.barbellShoulderPress,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// baseball
  baseball(androidId: _AndroidExercise.baseball, iosId: _IosExercise.baseball),

  /// basketball
  basketball(
    androidId: _AndroidExercise.basketball,
    iosId: _IosExercise.basketball,
  ),

  /// benchPress
  benchPress(
    androidId: _AndroidExercise.benchPress,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// benchSitUp
  benchSitUp(
    androidId: _AndroidExercise.benchSitUp,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// biking
  ///
  /// iOS: Use with [WorkoutLocationType.outdoor]
  biking(androidId: _AndroidExercise.biking, iosId: _IosExercise.cycling),

  /// bikingStationary
  ///
  /// iOS: Use with [WorkoutLocationType.indoor]
  bikingStationary(
    androidId: _AndroidExercise.bikingStationary,
    iosId: _IosExercise.cycling,
  ),

  /// bootCamp
  bootCamp(
    androidId: _AndroidExercise.bootCamp,
    iosId: _IosExercise.highIntensityIntervalTraining,
  ),

  /// boxing
  boxing(androidId: _AndroidExercise.boxing, iosId: _IosExercise.boxing),

  /// burpee
  burpee(
    androidId: _AndroidExercise.burpee,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// calisthenics
  calisthenics(
    androidId: _AndroidExercise.calisthenics,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// cricket
  cricket(androidId: _AndroidExercise.cricket, iosId: _IosExercise.cricket),

  /// crossCountrySkiing
  crossCountrySkiing(
    androidId: _AndroidExercise.crossCountrySkiing,
    iosId: _IosExercise.crossCountrySkiing,
  ),

  /// crunch
  crunch(androidId: _AndroidExercise.crunch, iosId: _IosExercise.coreTraining),

  /// dancing
  dancing(androidId: _AndroidExercise.dancing, iosId: _IosExercise.cardioDance),

  /// deadlift
  deadlift(
    androidId: _AndroidExercise.deadlift,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellCurlRightArm
  dumbbellCurlRightArm(
    androidId: _AndroidExercise.dumbbellCurlRightArm,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellCurlLeftArm
  dumbbellCurlLeftArm(
    androidId: _AndroidExercise.dumbbellCurlLeftArm,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellFrontRaise
  dumbbellFrontRaise(
    androidId: _AndroidExercise.dumbbellFrontRaise,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellLateralRaise
  dumbbellLateralRaise(
    androidId: _AndroidExercise.dumbbellLateralRaise,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellTricepsExtensionLeftArm
  dumbbellTricepsExtensionLeftArm(
    androidId: _AndroidExercise.dumbbellTricepsExtensionLeftArm,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellTricepsExtensionRightArm
  dumbbellTricepsExtensionRightArm(
    androidId: _AndroidExercise.dumbbellTricepsExtensionRightArm,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// dumbbellTricepsExtensionTwoArm
  dumbbellTricepsExtensionTwoArm(
    androidId: _AndroidExercise.dumbbellTricepsExtensionTwoArm,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// elliptical
  elliptical(
    androidId: _AndroidExercise.elliptical,
    iosId: _IosExercise.elliptical,
  ),

  /// exerciseClass
  exerciseClass(
    androidId: _AndroidExercise.exerciseClass,
    iosId: _IosExercise.other,
  ),

  /// fencing
  fencing(androidId: _AndroidExercise.fencing, iosId: _IosExercise.fencing),

  /// frisbeeDisc
  frisbeeDisc(
    androidId: _AndroidExercise.frisbeeDisc,
    iosId: _IosExercise.discSports,
  ),

  /// footballAmerican
  footballAmerican(
    androidId: _AndroidExercise.footballAmerican,
    iosId: _IosExercise.americanFootball,
  ),

  /// footballAustralian
  footballAustralian(
    androidId: _AndroidExercise.footballAustralian,
    iosId: _IosExercise.australianFootball,
  ),

  /// forwardTwist
  forwardTwist(
    androidId: _AndroidExercise.forwardTwist,
    iosId: _IosExercise.coreTraining,
  ),

  /// golf
  golf(androidId: _AndroidExercise.golf, iosId: _IosExercise.golf),

  /// guidedBreathing
  guidedBreathing(
    androidId: _AndroidExercise.guidedBreathing,
    iosId: _IosExercise.mindAndBody,
  ),

  /// horseRiding
  horseRiding(
    androidId: _AndroidExercise.horseRiding,
    iosId: _IosExercise.equestrianSports,
  ),

  /// gymnastics
  gymnastics(
    androidId: _AndroidExercise.gymnastics,
    iosId: _IosExercise.gymnastics,
  ),

  /// handball
  handball(androidId: _AndroidExercise.handball, iosId: _IosExercise.handball),

  /// highIntensityIntervalTraining
  highIntensityIntervalTraining(
    androidId: _AndroidExercise.highIntensityIntervalTraining,
    iosId: _IosExercise.highIntensityIntervalTraining,
  ),

  /// hiking
  hiking(androidId: _AndroidExercise.hiking, iosId: _IosExercise.hiking),

  /// iceHockey
  iceHockey(androidId: _AndroidExercise.iceHockey, iosId: _IosExercise.hockey),

  /// iceSkating
  iceSkating(
    androidId: _AndroidExercise.iceSkating,
    iosId: _IosExercise.skatingSports,
  ),

  /// inlineSkating
  inlineSkating(
    androidId: _AndroidExercise.inlineSkating,
    iosId: _IosExercise.skatingSports,
  ),

  /// jumpRope
  jumpRope(androidId: _AndroidExercise.jumpRope, iosId: _IosExercise.jumpRope),

  /// jumpingJack
  jumpingJack(
    androidId: _AndroidExercise.jumpingJack,
    iosId: _IosExercise.mixedCardio,
  ),

  /// latPullDown
  latPullDown(
    androidId: _AndroidExercise.latPullDown,
    iosId: _IosExercise.traditionalStrengthTraining,
  ),

  /// lunge
  lunge(
    androidId: _AndroidExercise.lunge,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// martialArts
  martialArts(
    androidId: _AndroidExercise.martialArts,
    iosId: _IosExercise.martialArts,
  ),

  /// meditation
  meditation(
    androidId: _AndroidExercise.meditation,
    iosId: _IosExercise.mindAndBody,
  ),

  /// mountainBiking
  ///
  /// iOS: Use with [WorkoutLocationType.outdoor]
  mountainBiking(
    androidId: _AndroidExercise.mountainBiking,
    iosId: _IosExercise.cycling,
  ),

  /// orienteering
  orienteering(
    androidId: _AndroidExercise.orienteering,
    iosId: _IosExercise.hiking,
  ),

  /// paddling
  paddling(
    androidId: _AndroidExercise.paddling,
    iosId: _IosExercise.paddleSports,
  ),

  /// paraGliding
  paraGliding(
    androidId: _AndroidExercise.paraGliding,
    iosId: _IosExercise.other,
  ),

  /// pilates
  pilates(androidId: _AndroidExercise.pilates, iosId: _IosExercise.pilates),

  /// plank
  plank(androidId: _AndroidExercise.plank, iosId: _IosExercise.coreTraining),

  /// racquetball
  racquetball(
    androidId: _AndroidExercise.racquetball,
    iosId: _IosExercise.racquetball,
  ),

  /// rockClimbing
  rockClimbing(
    androidId: _AndroidExercise.rockClimbing,
    iosId: _IosExercise.climbing,
  ),

  /// rollerHockey
  rollerHockey(
    androidId: _AndroidExercise.rollerHockey,
    iosId: _IosExercise.hockey,
  ),

  /// rollerSkating
  rollerSkating(
    androidId: _AndroidExercise.rollerSkating,
    iosId: _IosExercise.skatingSports,
  ),

  /// rowing
  ///
  /// iOS: Use with [WorkoutLocationType.outdoor]
  rowing(androidId: _AndroidExercise.rowing, iosId: _IosExercise.rowing),

  /// rowingMachine
  ///
  /// iOS: Use with [WorkoutLocationType.indoor]
  rowingMachine(
    androidId: _AndroidExercise.rowingMachine,
    iosId: _IosExercise.rowing,
  ),

  /// running
  ///
  /// iOS: Use with [WorkoutLocationType.outdoor]
  running(androidId: _AndroidExercise.running, iosId: _IosExercise.running),

  /// runningTreadmill
  ///
  /// iOS: Use with [WorkoutLocationType.indoor]
  runningTreadmill(
    androidId: _AndroidExercise.runningTreadmill,
    iosId: _IosExercise.running,
  ),

  /// rugby
  rugby(androidId: _AndroidExercise.rugby, iosId: _IosExercise.rugby),

  /// sailing
  sailing(androidId: _AndroidExercise.sailing, iosId: _IosExercise.sailing),

  /// scubaDiving
  scubaDiving(
    androidId: _AndroidExercise.scubaDiving,
    iosId: _IosExercise.underwaterDiving,
  ),

  /// skating
  skating(
    androidId: _AndroidExercise.skating,
    iosId: _IosExercise.skatingSports,
  ),

  /// skiing
  skiing(
    androidId: _AndroidExercise.skiing,
    iosId: _IosExercise.downhillSkiing,
  ),

  /// snowboarding
  snowboarding(
    androidId: _AndroidExercise.snowboarding,
    iosId: _IosExercise.snowboarding,
  ),

  /// snowshoeing
  ///
  /// iOS: snowSports
  snowshoeing(
    androidId: _AndroidExercise.snowshoeing,
    iosId: _IosExercise.snowSports,
  ),

  /// soccer
  soccer(androidId: _AndroidExercise.soccer, iosId: _IosExercise.soccer),

  /// softball
  softball(androidId: _AndroidExercise.softball, iosId: _IosExercise.softball),

  /// squash
  squash(androidId: _AndroidExercise.squash, iosId: _IosExercise.squash),

  /// squat
  squat(
    androidId: _AndroidExercise.squat,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// stairClimbing
  stairClimbing(
    androidId: _AndroidExercise.stairClimbing,
    iosId: _IosExercise.stairClimbing,
  ),

  /// stairClimbingMachine
  stairClimbingMachine(
    androidId: _AndroidExercise.stairClimbingMachine,
    iosId: _IosExercise.stairClimbing,
  ),

  /// strengthTraining
  strengthTraining(
    androidId: _AndroidExercise.strengthTraining,
    iosId: _IosExercise.functionalStrengthTraining,
  ),

  /// stretching
  stretching(
    androidId: _AndroidExercise.stretching,
    iosId: _IosExercise.flexibility,
  ),

  /// surfing
  ///
  /// iOS: surfingSports
  surfing(
    androidId: _AndroidExercise.surfing,
    iosId: _IosExercise.surfingSports,
  ),

  /// swimmingOpenWater
  ///
  /// iOS: Use with [SwimmingLocationType.openWater]
  swimmingOpenWater(
    androidId: _AndroidExercise.swimmingOpenWater,
    iosId: _IosExercise.swimming,
  ),

  /// swimmingPool
  ///
  /// iOS: Use with [SwimmingLocationType.pool]
  swimmingPool(
    androidId: _AndroidExercise.swimmingPool,
    iosId: _IosExercise.swimming,
  ),

  /// tableTennis
  tableTennis(
    androidId: _AndroidExercise.tableTennis,
    iosId: _IosExercise.tableTennis,
  ),

  /// tennis
  tennis(androidId: _AndroidExercise.tennis, iosId: _IosExercise.tennis),

  /// upperTwist
  upperTwist(
    androidId: _AndroidExercise.upperTwist,
    iosId: _IosExercise.coreTraining,
  ),

  /// volleyball
  volleyball(
    androidId: _AndroidExercise.volleyball,
    iosId: _IosExercise.volleyball,
  ),

  /// walking
  walking(androidId: _AndroidExercise.walking, iosId: _IosExercise.walking),

  /// waterPolo
  waterPolo(
    androidId: _AndroidExercise.waterPolo,
    iosId: _IosExercise.waterPolo,
  ),

  /// weightlifting
  weightlifting(
    androidId: _AndroidExercise.weightlifting,
    iosId: _IosExercise.traditionalStrengthTraining,
  ),

  /// workout
  workout(androidId: _AndroidExercise.workout, iosId: _IosExercise.other),

  /// yachting
  yachting(androidId: _AndroidExercise.yachting, iosId: _IosExercise.sailing),

  /// yoga
  yoga(androidId: _AndroidExercise.yoga, iosId: _IosExercise.yoga),

  // MARK: - iOS only types

  /// archery
  archery(androidId: _AndroidExercise.workout, iosId: _IosExercise.archery),

  /// bowling
  bowling(androidId: _AndroidExercise.workout, iosId: _IosExercise.bowling),

  /// crossTraining
  crossTraining(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.crossTraining,
  ),

  /// curling
  curling(androidId: _AndroidExercise.workout, iosId: _IosExercise.curling),

  /// fishing
  fishing(androidId: _AndroidExercise.workout, iosId: _IosExercise.fishing),

  /// hunting
  hunting(androidId: _AndroidExercise.workout, iosId: _IosExercise.hunting),

  /// lacrosse
  lacrosse(androidId: _AndroidExercise.workout, iosId: _IosExercise.lacrosse),

  /// play
  play(androidId: _AndroidExercise.workout, iosId: _IosExercise.play),

  /// preparationAndRecovery
  preparationAndRecovery(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.preparationAndRecovery,
  ),

  /// snowSports
  snowSports(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.snowSports,
  ),

  /// trackAndField
  trackAndField(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.trackAndField,
  ),

  /// waterFitness
  waterFitness(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.waterFitness,
  ),

  /// waterSports
  waterSports(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.waterSports,
  ),

  /// wrestling
  wrestling(androidId: _AndroidExercise.workout, iosId: _IosExercise.wrestling),

  /// barre
  barre(androidId: _AndroidExercise.dancing, iosId: _IosExercise.barre),

  /// coreTraining
  coreTraining(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.coreTraining,
  ),

  /// kickboxing
  kickboxing(
    androidId: _AndroidExercise.boxing,
    iosId: _IosExercise.kickboxing,
  ),

  /// stairs
  stairs(androidId: _AndroidExercise.stairClimbing, iosId: _IosExercise.stairs),

  /// stepTraining
  stepTraining(
    androidId: _AndroidExercise.stairClimbing,
    iosId: _IosExercise.stepTraining,
  ),

  /// wheelchairWalkPace
  wheelchairWalkPace(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.wheelchairWalkPace,
  ),

  /// wheelchairRunPace
  wheelchairRunPace(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.wheelchairRunPace,
  ),

  /// taiChi
  taiChi(androidId: _AndroidExercise.martialArts, iosId: _IosExercise.taiChi),

  /// mixedCardio
  mixedCardio(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.mixedCardio,
  ),

  /// handCycling
  handCycling(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.handCycling,
  ),

  /// fitnessGaming
  fitnessGaming(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.fitnessGaming,
  ),

  /// cardioDance
  cardioDance(
    androidId: _AndroidExercise.dancing,
    iosId: _IosExercise.cardioDance,
  ),

  /// socialDance
  socialDance(
    androidId: _AndroidExercise.dancing,
    iosId: _IosExercise.socialDance,
  ),

  /// pickleball
  pickleball(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.pickleball,
  ),

  /// cooldown
  cooldown(androidId: _AndroidExercise.workout, iosId: _IosExercise.cooldown),

  /// swimBikeRun
  swimBikeRun(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.swimBikeRun,
  ),

  /// transition
  transition(
    androidId: _AndroidExercise.workout,
    iosId: _IosExercise.transition,
  );

  /// The type id for Android
  final int _androidId;

  /// The type id for iOS
  final int _iosId;

  /// Returns the id for the current platform
  int get id {
    if (Platform.isAndroid) {
      return _androidId;
    } else if (Platform.isIOS) {
      return _iosId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Constructor
  const ExerciseType({required int androidId, required int iosId})
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
