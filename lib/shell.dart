import 'dart:io';

abstract class Shell {
  static const ps = 'powershell';
  static final exe = Platform.executable;
  static final home = Platform.environment['HOMEDRIVE'];
  static final user = Platform.environment['HOMEPATH'];
  static final path = Platform.environment['PATH'];
  static final installPath = '$home\\ProgramData\\wfi';
  static final chocoPath = '$home\\ProgramData\\chocolatey\\bin\\choco.exe';
  static final fvmPath = '$home\\ProgramData\\chocolatey\\bin\\fvm.exe';
  static final gitPath = '$home\\Program Files\\Git\\cmd';
  static final flutterPath = '$user\\fvm\\versions\\stable\\bin';

  static bool isAdmin() {
    final cmd = [
      '([Security.Principal.WindowsPrincipal][Security.Principal.'
          'WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.'
          'WindowsBuiltInRole]::Administrator)'
    ];
    return Process.runSync(ps, cmd).stdout.toString().contains('True');
  }

  static bool isInstalled(String value) {
    final cmd = ['Test-Path -Path "$value" -PathType leaf'];
    return Process.runSync(ps, cmd).stdout.toString().contains('True');
  }

  static void installWfi() {
    var cmd = [
      'New-Item -Path $home\\ProgramData -Name wfi -ItemType directory -Force'
    ];
    Process.runSync(ps, cmd);
    cmd = ['Copy-Item "$exe" -Destination $home\\ProgramData\\wfi'];
    Process.runSync(ps, cmd);
  }

  static Future<int> installChoco() async {
    var cmd = ['Remove-Item "$home\\ProgramData\\chocolatey" -Recurse'];
    Process.runSync(ps, cmd);
    cmd = [
      'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.'
          'ServicePointManager]::SecurityProtocol = [System.Net.'
          'ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object '
          'System.Net.WebClient).'
          'DownloadString("https://community.chocolatey.org/install.ps1"))'
    ];
    var p = await Process.start(ps, cmd);
    stdout.addStream(p.stdout);
    stderr.addStream(p.stderr);
    return await p.exitCode;
  }

  static bool isInPath(String value, String type) {
    final cmd = ['[Environment]::GetEnvironmentVariable("Path","$type")'];
    final path = Process.runSync(ps, cmd).stdout.toString().trim().split(';');
    return path.indexWhere((p) => p.contains(value)) != -1;
  }

  static void addToPath(String value, String type, {String? removeWhere}) {
    var cmd = ['[Environment]::GetEnvironmentVariable("Path","$type")'];
    List<String> path =
        Process.runSync(ps, cmd).stdout.toString().trim().split(';');
    if (removeWhere != null) {
      path.removeWhere((p) => p.contains(removeWhere));
    }
    path.add(value);
    cmd = [
      '[Environment]::SetEnvironmentVariable("Path","${path.join(';')};$value",'
          '"$type")'
    ];
    Process.runSync(ps, cmd);
  }

  static bool isInChoco(String value) {
    var cmd = ['list'];
    return Process.runSync(chocoPath, cmd)
        .stdout
        .toString()
        .contains('$value ');
  }

  static Future<int> chocoInstall(String package) async {
    final cmd = ['$chocoPath install $package -y --failonstderr'];
    var p = await Process.start(ps, cmd);
    stdout.addStream(p.stdout);
    stderr.addStream(p.stderr);
    return await p.exitCode;
  }

  static Future<int> installFlutter() async {
    final cmd = ['$fvmPath install stable'];
    Map<String, String> env = Map.from(Platform.environment);
    env['PATH'] = '${env['PATH']};$gitPath';
    var p = await Process.start(ps, cmd, environment: env);
    stdout.addStream(p.stdout);
    stderr.addStream(p.stderr);
    return await p.exitCode;
  }

  static Future<int> flutterDoctor() async {
    final cmd = ['$flutterPath\\flutter.bat doctor'];
    Map<String, String> env = Map.from(Platform.environment);
    env['PATH'] = '${env['PATH']};$gitPath';
    var p = await Process.start(ps, cmd, environment: env);
    stdout.addStream(p.stdout);
    stderr.addStream(p.stderr);
    return await p.exitCode;
  }
}
