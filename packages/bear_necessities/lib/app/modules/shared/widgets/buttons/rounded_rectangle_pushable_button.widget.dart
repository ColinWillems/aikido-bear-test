import 'package:bear_necessities/bear_necessities.dart';

class RoundedRectanglePushableButton extends PushableButton {
  const RoundedRectanglePushableButton(
      {super.key,
      super.child,
      super.color = BearColors.bearActionButton,
      super.height,
      super.elevation = 6,
      super.shadow,
      super.borderRadius = 8,
      super.onPressed});
}
