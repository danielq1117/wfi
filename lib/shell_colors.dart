class ShCol {
  int? code;
  int? end;
  ShCol? parent;

  ShCol({this.code, this.end, this.parent});

  get black => ShCol(code: 30, end: 39, parent: this);
  get red => ShCol(code: 31, end: 39, parent: this);
  get green => ShCol(code: 32, end: 39, parent: this);
  get yellow => ShCol(code: 33, end: 39, parent: this);
  get blue => ShCol(code: 34, end: 39, parent: this);
  get magenta => ShCol(code: 35, end: 39, parent: this);
  get cyan => ShCol(code: 36, end: 39, parent: this);
  get white => ShCol(code: 37, end: 39, parent: this);

  get onBlack => ShCol(code: 40, end: 49, parent: this);
  get onRed => ShCol(code: 41, end: 49, parent: this);
  get onGreen => ShCol(code: 42, end: 49, parent: this);
  get onYellow => ShCol(code: 43, end: 49, parent: this);
  get onBlue => ShCol(code: 44, end: 49, parent: this);
  get onMagenta => ShCol(code: 45, end: 49, parent: this);
  get onCyan => ShCol(code: 46, end: 49, parent: this);
  get onWhite => ShCol(code: 47, end: 49, parent: this);

  get bold => ShCol(code: 1, parent: this);

  String _ansiCode([int? code]) => '\x1B[${code ?? 0}m';

  String call(Object text) {
    if (parent != null) {
      return parent!.call('${_ansiCode(code)}$text${_ansiCode(end)}');
    }
    return text.toString();
  }
}

ShCol shCol = ShCol();

void printInfo(Object text) {
  print(shCol.blue.onBlack(text));
}

void printWarning(Object text) {
  print(shCol.yellow(text));
}

void printDone() {
  print(shCol.green('Done!'));
}

void printError(Object text) {
  print(shCol.red(text));
}
