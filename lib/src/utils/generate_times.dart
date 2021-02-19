List<String> generateTimes({
  int interval = 30,
  String startTime,
  String endTime,
}) {
  List<String> times = [];
  int tt = 0;
  int maxTT = 24 * 60;

  if (startTime != null && startTime.isNotEmpty) {
    final List<String> splittedStartTime = startTime.split(':');

    if (splittedStartTime.length == 2) {
      tt = int.parse(splittedStartTime[0]) * 60 +
          int.parse(splittedStartTime[1]) +
          interval;
    }
  }

  if (endTime != null && endTime.isNotEmpty) {
    final List<String> splittedEndTime = endTime.split(':');

    if (splittedEndTime.length == 2) {
      maxTT =
          int.parse(splittedEndTime[0]) * 60 + int.parse(splittedEndTime[1]);
    }
  }

  for (var i = 0; tt < maxTT; i++) {
    var hh = tt ~/ 60; // getting hours of day in 0 - 24 format
    var mm = tt % 60; // getting minutes of the hour in 0 - 59 format

    var hhS = ('0' + (hh >= 12 ? (hh % 24).toString() : (hh % 12).toString()));
    var hhSf = hhS.substring(hhS.length - 2);

    var mmS = ('0' + mm.toString());
    var mmSf = mmS.substring(mmS.length - 2);

    times.add(hhSf + ':' + mmSf);
    tt += interval;
  }

  if (maxTT == 24 * 60) {
    times.add('23:59');
  }

  return times;
}
