import 'package:collection/collection.dart';

/// Exercise types for Wear OS
enum ExerciseType {
  /// unknown
  unknown(0),

  /// alpineSkiing
  alpineSkiing(92),

  /// backpacking
  backpacking(84),

  /// backExtension
  backExtension(1),

  /// badminton
  badminton(2),

  /// barbellShoulderPress
  barbellShoulderPress(3),

  /// baseball
  baseball(4),

  /// basketball
  basketball(5),

  /// benchPress
  benchPress(6),

  /// benchSitUp
  benchSitUp(7),

  /// biking
  biking(8),

  /// bikingStationary
  bikingStationary(9),

  /// bootCamp
  bootCamp(10),

  /// boxing
  boxing(11),

  /// burpee
  burpee(12),

  /// calisthenics
  calisthenics(13),

  /// cricket
  cricket(14),

  /// crossCountrySkiing
  crossCountrySkiing(91),

  /// crunch
  crunch(15),

  /// dancing
  dancing(16),

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
  elliptical(25),

  /// exerciseClass
  exerciseClass(26),

  /// fencing
  fencing(27),

  /// frisbeeDisc
  frisbeeDisc(28),

  /// footballAmerican
  footballAmerican(29),

  /// footballAustralian
  footballAustralian(30),

  /// forwardTwist
  forwardTwist(31),

  /// golf
  golf(32),

  /// guidedBreathing
  guidedBreathing(33),

  /// horseRiding
  horseRiding(88),

  /// gymnastics
  gymnastics(34),

  /// handball
  handball(35),

  /// highIntensityIntervalTraining
  highIntensityIntervalTraining(36),

  /// hiking
  hiking(37),

  /// iceHockey
  iceHockey(38),

  /// iceSkating
  iceSkating(39),

  /// inlineSkating
  inlineSkating(87),

  /// jumpRope
  jumpRope(40),

  /// jumpingJack
  jumpingJack(41),

  /// latPullDown
  latPullDown(42),

  /// lunge
  lunge(43),

  /// martialArts
  martialArts(44),

  /// meditation
  meditation(45),

  /// mountainBiking
  mountainBiking(85),

  /// orienteering
  orienteering(86),

  /// paddling
  paddling(46),

  /// paraGliding
  paraGliding(47),

  /// pilates
  pilates(48),

  /// plank
  plank(49),

  /// racquetball
  racquetball(50),

  /// rockClimbing
  rockClimbing(51),

  /// rollerHockey
  rollerHockey(52),

  /// rollerSkating
  rollerSkating(89),

  /// rowing
  rowing(53),

  /// rowingMachine
  rowingMachine(54),

  /// running
  running(55),

  /// runningTreadmill
  runningTreadmill(56),

  /// rugby
  rugby(57),

  /// sailing
  sailing(58),

  /// scubaDiving
  scubaDiving(59),

  /// skating
  skating(60),

  /// skiing
  skiing(61),

  /// snowboarding
  snowboarding(62),

  /// snowshoeing
  snowshoeing(63),

  /// soccer
  soccer(64),

  /// softball
  softball(65),

  /// squash
  squash(66),

  /// squat
  squat(67),

  /// stairClimbing
  stairClimbing(68),

  /// stairClimbingMachine
  stairClimbingMachine(69),

  /// strengthTraining
  strengthTraining(70),

  /// stretching
  stretching(71),

  /// surfing
  surfing(72),

  /// swimmingOpenWater
  swimmingOpenWater(73),

  /// swimmingPool
  swimmingPool(74),

  /// tableTennis
  tableTennis(75),

  /// tennis
  tennis(76),

  /// upperTwist
  upperTwist(77),

  /// volleyball
  volleyball(78),

  /// walking
  walking(79),

  /// waterPolo
  waterPolo(80),

  /// weightlifting
  weightlifting(81),

  /// workout
  workout(82),

  /// yachting
  yachting(90),

  /// yoga
  yoga(83);

  /// The type id
  final int id;

  /// Constructor
  const ExerciseType(this.id);

  /// Returns the [ExerciseType] for the given [id]
  static ExerciseType? fromId(int id) =>
      ExerciseType.values.firstWhereOrNull((e) => e.id == id);
}
