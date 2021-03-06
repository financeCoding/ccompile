part of ccompile;

class GnuCompiler implements ProjectTool {
  Future<ProcessResult> run(Project project, [String workingDirectory]) {
    var options = new ProcessOptions();
    var executable = project.compilerSettings.getExecutable('g++');
    var arguments = _projectToArguments(project);
    options.workingDirectory = workingDirectory;
    return Process.run(executable, arguments, options);
  }

  List<String> _projectToArguments(Project project) {
    var settings = project.compilerSettings;
    var arguments = ['-c'];
    arguments.addAll(settings.arguments);

    if(project.getBits() == 32) {
      arguments.add('-m32');
    } else if(project.getBits() == 64) {
      arguments.add('-m64');
    }

    var includes = SystemUtils.expandEnvironmentVars(settings.includes);
    includes = includes.map((elem) => FileUtils.correctPathSeparators(elem));
    includes.forEach((include) {
      arguments.add('-I$include');
    });

    settings.defines.forEach((k, v) {
      if(v == null) {
        arguments.add('-D$k');
      } else {
        arguments.add('-D$v=$k');
      }
    });

    var inputFiles = SystemUtils.expandEnvironmentVars(settings.inputFiles);
    inputFiles = inputFiles.map((elem) => FileUtils.correctPathSeparators(elem));
    inputFiles.forEach((inputFile) {
      arguments.add('$inputFile');
    });

    return arguments;
  }
}
