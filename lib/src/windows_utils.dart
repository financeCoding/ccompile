part of ccompile;

class WindowsUtils {
  static String findFileInEnvPath(Map<String, String> env, String filename) {
    if(env == null || filename == null) {
      return filename;
    }

    var paths = [];
    for(var key in env.keys) {
      if(key.toUpperCase() == 'PATH') {
        paths = env[key].split(';');
        break;
      }
    }

    for(var i = paths.length; i >= 0; i--) {
      var path = paths[i - 1];
      if(path.isEmpty) {
        continue;
      }

      if(!path.endsWith('\\')) {
        path = '$path\\';
      }

      path = '${path}$filename';

      var file = new File(path);
      if(file.existsSync()) {
        filename = path;
        break;
      }
    }

    return filename;
  }

  static int getSystemBits() {
    if(Platform.environment.containsKey('ProgramFiles(x86)')) {
      return 64;
    }

    return 32;
  }
}
