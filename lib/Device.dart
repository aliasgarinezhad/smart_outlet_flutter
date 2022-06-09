class Device {
  var serialNumber = "";
  var password = "";
  var name = "";
  var status = false;

  Device(this.serialNumber, this.password, this.name, this.status);

  String getStatusString() {
    if(status) {
      return "روشن";
    } else {
      return "خاموش";
    }
  }
}