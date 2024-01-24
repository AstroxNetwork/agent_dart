enum SigHashType {
  ALL(0x01),
  NONE(0x02),
  SINGLE(0x03),
  ANYONE_CAN_PAY(0x80),
  ;

  const SigHashType(this.value);

  final int value;
}
