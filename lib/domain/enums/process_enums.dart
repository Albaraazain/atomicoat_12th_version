enum ProcessPhase {
  initialization,
  precursorPulse,
  precursorPurge,
  oxidantPulse,
  oxidantPurge,
  cooldown,
  complete
}

enum ProcessQuality {
  optimal,
  acceptable,
  suboptimal,
  unacceptable
}

enum StepType {
  precursorDelivery,
  precursorPurge,
  oxidantPurge,
  temperatureControl,
  pressureControl,
  wait,
  loop,
  substrateRotation,
}

enum OperationalMode {
  automatic,
  manual,
  diagnostic,
  calibration,
  safety
}
