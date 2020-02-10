class TextUtil {
  static bool isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }
}

extension StringExt on String {
  String upperCaseFirstCharacter() {
    try {
      return this.substring(0, 1).toUpperCase() +
          this.substring(1, this.length);
    } catch (e) {
      return this;
    }
  }
}
