# Windows Flutter Installer (WFI)

A simple CLI that helps to install Flutter on Windows easily. It installs all
necessary tools and the last stable version of Flutter on your computer.

## Installation

* Download [`wfi.exe`][exe] on your computer.
* Execute it as Administrator.
* The program will auto-install and run automatically. It installs in your 
  computer, if is not already installed:
  * [Chocolatey][choco]
  * [Git][git]
  * [FVM][fvm]
  * [Flutter][flutter]
* At the end it will run `flutter doctor`. When this happens, you will know that
  flutter has been installed in your computer.
* If there was a problem during the execution, you can execute `WFI` again by
  running the command `wfi` on an **Administrative Powershell**.

## Troubleshooting

If you find any trouble executing `WFI`, try running it again. If the trouble
persists, please report it so I can solve it as soon as possible.

[exe]:https://github.com/danielq1117/wfi/releases/download/0.0.1/wfi.exe
[choco]:https://chocolatey.org
[git]:https://git-scm.com
[fvm]:https://fvm.app
[flutter]:https://flutter.dev
