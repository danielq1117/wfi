import 'dart:io';

import 'package:wfi/shell.dart';
import 'package:wfi/shell_colors.dart';

void main() async {
  int status = 0;
  printInfo('Windows Flutter Installer v0.0.1');
  if (!Shell.isAdmin()) {
    printError('WFI needs to be run as an Administrator.');
  } else {
    if (!Shell.isInstalled('${Shell.installPath}\\wfi.exe')) {
      printWarning('WFI is not installed. Installing...');
      Shell.installWfi();
      printDone();
    }
    if (!Shell.isInPath(Shell.installPath, 'Machine')) {
      printWarning('Adding WFI to the PATH...');
      Shell.addToPath(Shell.installPath, 'Machine');
      printDone();
      printInfo('You can run WFI again by typing wfi on powershell.');
    }
    if (!Shell.isInstalled(Shell.chocoPath)) {
      printWarning('Chocolatey is not installed. Installing...');
      if (await Shell.installChoco() == 0) {
        printDone();
      } else {
        printError(
            'There was a problem installing Chocolatey. Please try again.');
        status = 1;
      }
    }
    if (status == 0 && !Shell.isInChoco('git')) {
      printWarning('Git is not installed. Installing...');
      if (await Shell.chocoInstall('git') == 0) {
        printDone();
      } else {
        printError('There was a problem installing Git. Please try again.');
        status = 1;
      }
    }
    if (status == 0 && !Shell.isInChoco('fvm')) {
      printWarning('FVM is not installed. Installing...');
      if (await Shell.chocoInstall('fvm') == 0) {
        printDone();
      } else {
        printError('There was a problem installing FVM. Please try again.');
        status = 1;
      }
    }
    if (status == 0 && !Shell.isInstalled('${Shell.flutterPath}\\flutter')) {
      printWarning('Flutter is not installed. Installing...');
      if (await Shell.installFlutter() == 0) {
        printDone();
      } else {
        printError('There was a problem installing Flutter. Please try again.');
        status = 1;
      }
    }
    if (status == 0 && !Shell.isInPath(Shell.flutterPath, 'User')) {
      printWarning('Adding Flutter to the PATH...');
      Shell.addToPath(Shell.flutterPath, 'User', removeWhere: 'dart-sdk');
      printDone();
    }
    if (status == 0) {
      await Shell.flutterDoctor();
      printInfo('Flutter is installed in your machine.');
    }
  }
  print('Press ${shCol.blue.bold('Enter')} to exit');
  stdin.echoMode = false;
  stdin.readByteSync();
}
