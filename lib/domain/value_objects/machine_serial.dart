// lib/domain/value_objects/machine_serial.dart
class MachineSerial extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory MachineSerial(String input) {
    return MachineSerial._(
      validateMachineSerial(input),
    );
  }

  const MachineSerial._(this.value);
}