import 'package:dpa/components/app_localization.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatelessWidget {
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final DateTime startDateSelected;
  final DateTime endDateSelected;

  const DateRangePicker({
    @required this.onStartDateChanged,
    @required this.onEndDateChanged,
    @required this.startDateSelected,
    @required this.endDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: Dimens.s,
        ),
        Text(
          AppLocalizations.of(context).translate('from'),
          style: TextStyle(fontSize: Dimens.font_l, color: MyColors.second),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: Dimens.s,
        ),
        generateDateWidget(context, true),
        SizedBox(
          width: Dimens.s,
        ),
        Text(
          AppLocalizations.of(context).translate('to'),
          style: TextStyle(fontSize: Dimens.font_l, color: MyColors.second),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: Dimens.s,
        ),
        generateDateWidget(context, false),
        SizedBox(
          width: Dimens.s,
        ),
      ],
    );
  }

  Widget generateDateWidget(BuildContext context, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.xxxl),
        ),
        margin: EdgeInsets.symmetric(vertical: Dimens.s),
        elevation: Dimens.m,
        child: Padding(
          padding: EdgeInsets.all(Dimens.xs),
          child: Container(
            width: Dimens.date_tile_width,
            child: AspectRatio(
              aspectRatio: 1,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  SizedBox(height: Dimens.xxs),
                  Expanded(
                    child: Text(
                      DateFormat("MMM d").format(
                          (isStartDate) ? startDateSelected : endDateSelected),
                      style: TextStyle(
                        fontSize: Dimens.font_m,
                        color: MyColors.second,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat("y").format(
                          (isStartDate) ? startDateSelected : endDateSelected),
                      style: TextStyle(
                        fontSize: Dimens.font_m,
                        color: MyColors.second,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime selectedDate = isStartDate ? startDateSelected : endDateSelected;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      isStartDate ? onStartDateChanged(picked) : onEndDateChanged(picked);
  }
}
