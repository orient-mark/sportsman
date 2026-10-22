void initializePwa() {}
void setPwaSafeToUpdate(bool safe) {}
Future<T> runPwaOperation<T>(Future<T> Function() operation) => operation();
Future<bool> webTorchAvailable() async => false;
Future<bool> toggleWebTorch() async => false;
