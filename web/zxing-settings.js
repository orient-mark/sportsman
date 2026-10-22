// Configure the public ZXing reader API before mobile_scanner starts decoding.
// Both success and failed-decode paths yield time for Flutter to draw frames.
(() => {
  const reader = ZXing.BrowserMultiFormatReader.prototype;
  const decodeContinuously = reader.decodeContinuously;
  reader.decodeContinuously = function(video, callback) {
    this.timeBetweenScansMillis = Math.max(250, this.timeBetweenScansMillis);
    this.timeBetweenDecodingAttempts = 150;
    return decodeContinuously.call(this, video, callback);
  };
})();
