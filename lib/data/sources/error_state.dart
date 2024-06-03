enum ErrorState {
  notFound(404, "해당 항목을 찾을 수 없습니다."),
  userNotFound(401, '아이디 또는 비밀번호를 확인해주세요.'),
  alreadyUser(400, '이미 해당 아이디의 유저가 존재합니다.'),
  error(500, "알 수 없는 에러가 발생했습니다."),
  validEmailFormat(402, '이메일 형식이 잘못되었습니다.'),
  expiredToken(401, '토큰이 만료되었습니다.'),
  heightOrWeightIsNull(444, '첫 회원수정시 키와 몸무게 값을 입력해주셔야합니다.'),
  success(200, "정상적으로 완료되었습니다.");

  const ErrorState(
    this.statusCode,
    this.message,
  );

  final int statusCode;
  final String message;
}
