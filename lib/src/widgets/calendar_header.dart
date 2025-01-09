// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/src/customization/header_style.dart';
import 'package:table_calendar/src/shared/utils.dart'
    show CalendarFormat, DayBuilder;
import 'package:table_calendar/src/widgets/format_button.dart';

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;

  const CalendarHeader({
    super.key,
    this.locale,
    required this.focusedMonth,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onHeaderTap,
    required this.onHeaderLongPress,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final text = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.yMMMM(locale).format(focusedMonth);

    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      height: headerStyle.headerHeight ?? 60.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              // spacing between chevrons and title
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (headerStyle.leftChevronVisible)
                  Container(
                    margin: headerStyle.leftChevronMargin,
                    padding: headerStyle.leftChevronPadding,
                    child: headerStyle.leftChevronIcon,
                  ),
                if (headerStyle.rightChevronVisible)
                  Container(
                    margin: headerStyle.rightChevronMargin,
                    padding: headerStyle.rightChevronPadding,
                    child: headerStyle.rightChevronIcon,
                  ),
              ],
            ),
          ),
          Align(
            alignment: headerStyle.titleCentered
                ? Alignment.center
                : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                headerTitleBuilder?.call(context, focusedMonth) ??
                    GestureDetector(
                      onTap: onHeaderTap,
                      onLongPress: onHeaderLongPress,
                      child: Text(
                        text,
                        style: headerStyle.titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                if (headerStyle.formatButtonVisible &&
                    availableCalendarFormats.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FormatButton(
                      onTap: onFormatButtonTap,
                      availableCalendarFormats: availableCalendarFormats,
                      calendarFormat: calendarFormat,
                      decoration: headerStyle.formatButtonDecoration,
                      padding: headerStyle.formatButtonPadding,
                      textStyle: headerStyle.formatButtonTextStyle,
                      showsNextFormat: headerStyle.formatButtonShowsNext,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
