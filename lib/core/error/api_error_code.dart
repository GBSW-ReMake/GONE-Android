enum ApiErrorCode {
  outing007(
    'OUTING_007',
    '이 외출증에 접근할 권한이 없습니다.',
  ),
  common002(
    'COMMON_002',
    '인증이 필요합니다.',
  ),
  conduct007(
    'CONDUCT_007',
    '페이지 파라미터가 유효하지 않습니다.',
  ),
  gbsw002(
    'GBSW_002',
    '학급 정보가 없는 계정입니다.',
  ),
  schoolcamp010(
    'SCHOOLCAMP_010',
    '해당 신청을 찾을 수 없습니다.',
  ),
  schoolcamp014(
    'SCHOOLCAMP_014',
    '이미 대기 등록되어 있습니다.',
  ),
  outing014(
    'OUTING_014',
    '조회 기간 파라미터 조합이 올바르지 않습니다.',
  ),
  schoolcamp003(
    'SCHOOLCAMP_003',
    '이번 달에 이미 참여한 사용자가 포함되어 있습니다.',
  ),
  common006(
    'COMMON_006',
    '이미 존재하는 리소스입니다.',
  ),
  file001(
    'FILE_001',
    '업로드된 파일을 확인할 수 없습니다.',
  ),
  auth008(
    'AUTH_008',
    '유효하지 않거나 만료된 토큰입니다. 다시 로그인해주세요.',
  ),
  common001(
    'COMMON_001',
    '요청 형식이 올바르지 않습니다.',
  ),
  auth009(
    'AUTH_009',
    '문자 발송에 실패했습니다. 잠시 후 다시 시도해주세요.',
  ),
  common004(
    'COMMON_004',
    '요청한 리소스를 찾을 수 없습니다.',
  ),
  outing001(
    'OUTING_001',
    '신청 가능한 날짜 또는 시간이 아닙니다.',
  ),
  outing015(
    'OUTING_015',
    '페이지 파라미터가 올바르지 않습니다(page>=0, 1<=size<=100).',
  ),
  outing004(
    'OUTING_004',
    '본인에게 지정된 외출증만 처리할 수 있습니다.',
  ),
  common003(
    'COMMON_003',
    '접근 권한이 없습니다.',
  ),
  schoolcamp006(
    'SCHOOLCAMP_006',
    '이미 등록된 날짜입니다.',
  ),
  schoolcamp001(
    'SCHOOLCAMP_001',
    '해당 날짜에 스쿨캠핑 일정이 없습니다.',
  ),
  schoolcamp007(
    'SCHOOLCAMP_007',
    '본인 신청만 취소/수정할 수 있습니다.',
  ),
  conduct003(
    'CONDUCT_003',
    '이미 취소된 기록입니다.',
  ),
  schoolcamp005(
    'SCHOOLCAMP_005',
    '신청 가능한 날짜가 아닙니다.',
  ),
  auth007(
    'AUTH_007',
    '아이디 또는 비밀번호가 일치하지 않습니다.',
  ),
  conduct006(
    'CONDUCT_006',
    '대상 사용자가 학생 역할이 아닙니다.',
  ),
  neis001(
    'NEIS_001',
    '외부 학교 정보 서비스와 통신 중 문제가 발생했습니다.',
  ),
  conduct002(
    'CONDUCT_002',
    '본인이 부여한 기록만 처리할 수 있습니다.',
  ),
  conduct001(
    'CONDUCT_001',
    '상/벌점 기록을 찾을 수 없습니다.',
  ),
  schoolcamp011(
    'SCHOOLCAMP_011',
    '다른 요청과 동시에 처리되어 반영하지 못했습니다. 다시 시도해주세요.',
  ),
  file003(
    'FILE_003',
    '파일 크기가 허용 범위를 초과했습니다.',
  ),
  outing002(
    'OUTING_002',
    '지정한 선생님을 찾을 수 없습니다.',
  ),
  schoolcamp012(
    'SCHOOLCAMP_012',
    '페이지 파라미터가 올바르지 않습니다(page>=0, 1<=size<=100).',
  ),
  outing006(
    'OUTING_006',
    '외출증을 찾을 수 없습니다.',
  ),
  schoolcamp015(
    'SCHOOLCAMP_015',
    '유효한 대기 등록을 찾을 수 없습니다.',
  ),
  schoolcamp008(
    'SCHOOLCAMP_008',
    '팀원 정보가 올바르지 않습니다.',
  ),
  user003(
    'USER_003',
    '이미 사용 중인 별명입니다.',
  ),
  common005(
    'COMMON_005',
    '허용되지 않는 HTTP 메서드입니다.',
  ),
  file002(
    'FILE_002',
    '지원하지 않는 파일 형식입니다.',
  ),
  user002(
    'USER_002',
    '이미 사용 중인 아이디입니다.',
  ),
  schoolcamp002(
    'SCHOOLCAMP_002',
    '이미 다른 팀이 신청한 날짜입니다.',
  ),
  outing012(
    'OUTING_012',
    '학생만 외출증을 신청할 수 있습니다.',
  ),
  schoolcamp013(
    'SCHOOLCAMP_013',
    '본인이 참여한 신청만 조회할 수 있습니다.',
  ),
  outing016(
    'OUTING_016',
    '그 외출증이 DEPARTED 상태가 아닙니다.',
  ),
  outing008(
    'OUTING_008',
    '마감이 지나 더 이상 처리할 수 없는 외출증입니다.',
  ),
  timetable001(
    'TIMETABLE_001',
    '학급 정보를 확인할 수 없습니다. 관리자에게 문의해주세요.',
  ),
  outing010(
    'OUTING_010',
    '학교 운영시간(08:40~20:30) 외에는 출발/도착을 보고할 수 없습니다.',
  ),
  common007(
    'COMMON_007',
    '서버 내부 오류가 발생했습니다.',
  ),
  outing003(
    'OUTING_003',
    '같은 시간대에 이미 진행 중인 외출증이 있습니다.',
  ),
  outing011(
    'OUTING_011',
    '커스텀 시간대는 08:40~20:30 범위 안이어야 합니다.',
  ),
  outing013(
    'OUTING_013',
    '조회 시작일이 종료일보다 늦습니다.',
  ),
  conduct005(
    'CONDUCT_005',
    '대상 학생을 찾을 수 없습니다.',
  ),
  outing009(
    'OUTING_009',
    '학교 반경을 벗어난 위치에서는 출발/도착 처리를 할 수 없습니다.',
  ),
  conduct008(
    'CONDUCT_008',
    '날짜 범위 파라미터가 유효하지 않습니다.',
  ),
  outing005(
    'OUTING_005',
    '지금 상태에서는 처리할 수 없는 요청입니다.',
  ),
  conduct004(
    'CONDUCT_004',
    '존재하지 않거나 비활성화된 카테고리입니다.',
  ),
  schoolcamp009(
    'SCHOOLCAMP_009',
    '캠핑 당일에는 취소할 수 없습니다.',
  ),
  schoolcamp004(
    'SCHOOLCAMP_004',
    '신청 정보가 올바르지 않습니다.',
  ),
  auth005(
    'AUTH_005',
    '유효하지 않거나 만료된 티켓입니다. 인증을 다시 진행해주세요.',
  ),
  auth004(
    'AUTH_004',
    '인증번호 재발송을 너무 많이 요청했습니다. 잠시 후 다시 시도해주세요.',
  ),
  gbsw001(
    'GBSW_001',
    '명단에 등록되지 않은 번호입니다. 관리자에게 문의해주세요.',
  ),
  auth001(
    'AUTH_001',
    '인증번호가 일치하지 않습니다.',
  ),
  auth006(
    'AUTH_006',
    '인증된 휴대폰 번호와 일치하지 않습니다.',
  ),
  auth002(
    'AUTH_002',
    '인증번호가 만료되었습니다. 다시 요청해주세요.',
  ),
  user001(
    'USER_001',
    '이미 가입된 계정입니다.',
  ),
  auth003(
    'AUTH_003',
    '인증 시도 횟수를 초과했습니다. 잠시 후 다시 시도해주세요.',
  );

  final String value;
  final String message;

  const ApiErrorCode(this.value, this.message);

  static ApiErrorCode? from(String? value) {
    for (final code in values) {
      if (code.value == value) {
        return code;
      }
    }

    return null;
  }
}