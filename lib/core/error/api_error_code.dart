enum ApiErrorCode {
  outing007('OUTING_007'),
  common002('COMMON_002'),
  conduct007('CONDUCT_007'),
  gbsw002('GBSW_002'),
  schoolcamp010('SCHOOLCAMP_010'),
  schoolcamp014('SCHOOLCAMP_014'),
  outing014('OUTING_014'),
  schoolcamp003('SCHOOLCAMP_003'),
  common006('COMMON_006'),
  file001('FILE_001'),
  auth008('AUTH_008'),
  common001('COMMON_001'),
  auth009('AUTH_009'),
  common004('COMMON_004'),
  outing001('OUTING_001'),
  outing015('OUTING_015'),
  outing004('OUTING_004'),
  common003('COMMON_003'),
  schoolcamp006('SCHOOLCAMP_006'),
  schoolcamp001('SCHOOLCAMP_001'),
  schoolcamp007('SCHOOLCAMP_007'),
  conduct003('CONDUCT_003'),
  schoolcamp005('SCHOOLCAMP_005'),
  auth007('AUTH_007'),
  conduct006('CONDUCT_006'),
  neis001('NEIS_001'),
  conduct002('CONDUCT_002'),
  conduct001('CONDUCT_001'),
  schoolcamp011('SCHOOLCAMP_011'),
  file003('FILE_003'),
  outing002('OUTING_002'),
  schoolcamp012('SCHOOLCAMP_012'),
  outing006('OUTING_006'),
  schoolcamp015('SCHOOLCAMP_015'),
  schoolcamp008('SCHOOLCAMP_008'),
  user003('USER_003'),
  common005('COMMON_005'),
  file002('FILE_002'),
  user002('USER_002'),
  schoolcamp002('SCHOOLCAMP_002'),
  outing012('OUTING_012'),
  schoolcamp013('SCHOOLCAMP_013'),
  outing016('OUTING_016'),
  outing008('OUTING_008'),
  timetable001('TIMETABLE_001'),
  outing010('OUTING_010'),
  common007('COMMON_007'),
  outing003('OUTING_003'),
  outing011('OUTING_011'),
  outing013('OUTING_013'),
  conduct005('CONDUCT_005'),
  outing009('OUTING_009'),
  conduct008('CONDUCT_008'),
  outing005('OUTING_005'),
  conduct004('CONDUCT_004'),
  schoolcamp009('SCHOOLCAMP_009'),
  schoolcamp004('SCHOOLCAMP_004'),
  auth005('AUTH_005'),
  auth004('AUTH_004'),
  gbsw001('GBSW_001'),
  auth001('AUTH_001'),
  auth006('AUTH_006'),
  auth002('AUTH_002'),
  user001('USER_001'),
  auth003('AUTH_003');

  final String value;

  const ApiErrorCode(this.value);

  static ApiErrorCode? from(String? value) {
    for (final code in values) {
      if (code.value == value) {
        return code;
      }
    }

    return null;
  }
}