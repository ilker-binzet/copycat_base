import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/widgets/timer_progress_bar.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackbar(
  SnackBar snackBar, {
  bool closePrevious = false,
}) {
  ScaffoldMessengerState? state = scaffoldMessengerKey.currentState;

  if (closePrevious) {
    state?.removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  }
  return state?.showSnackBar(snackBar);
}

void closeSnackbar() {
  ScaffoldMessengerState? state = scaffoldMessengerKey.currentState;
  state?.removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showFailureSnackbar(
  Failure failure,
) {
  final context = scaffoldMessengerKey.currentContext!;
  final mq = MediaQuery.of(context);
  final colors = context.colors;
  final isMobile = Breakpoints.isMobile(mq.size.width);
  return showSnackbar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colors.errorContainer,
          ),
          width8,
          Expanded(
            child: Text(
              failure.message,
              maxLines: 10,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: colors.errorContainer,
              ),
            ),
          )
        ],
      ),
      closeIconColor: colors.errorContainer,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      width: isMobile ? null : 480,
      showCloseIcon: !isMobile,
      backgroundColor: colors.error,
    ),
    closePrevious: true,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showTextSnackbar(
  String text, {
  bool isLoading = false,
  bool isProgress = false,
  bool success = false,
  bool failure = false,
  bool closePrevious = false,
  int? duration,
  SnackBarAction? action,
}) {
  final context = scaffoldMessengerKey.currentContext!;
  final mq = MediaQuery.of(context);
  final isMobile = Breakpoints.isMobile(mq.size.width);

  Color? bg;
  if (success) bg = Colors.green;
  if (failure) bg = Colors.red;

  Widget child;

  if (isLoading) {
    child = Row(
      children: [
        const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        width8,
        Text(text)
      ],
    );
  } else if (isProgress) {
    child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        height6,
        TimerProgressBar(
          duration: Duration(seconds: duration ?? 4),
        ),
      ],
    );
  } else {
    child = Text(text);
  }

  return showSnackbar(
    SnackBar(
      content: child,
      backgroundColor: bg,
      showCloseIcon: !isMobile && !isLoading,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      width: isMobile ? null : 480,
      duration: duration != null
          ? Duration(seconds: duration)
          : isLoading
              ? const Duration(seconds: 30)
              : const Duration(seconds: 2),
      action: action,
    ),
    closePrevious: closePrevious,
  );
}
