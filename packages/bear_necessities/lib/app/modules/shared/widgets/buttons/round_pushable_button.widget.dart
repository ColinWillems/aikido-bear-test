import 'package:bear_necessities/bear_necessities.dart';

class RoundPushableButton extends PushableButton {
  const RoundPushableButton(
      {super.key,
      super.child,
      super.color = BearColors.bearBrown,
      super.height = 40,
      super.elevation = 6,
      super.shadow,
      super.borderRadius,
      super.tooltip,
      super.onPressed});
}
