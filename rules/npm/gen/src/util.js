const PKG_INPUT = /^(.?[^@]+)(?:@(.+))?$/;

exports.parsePackageName = function(input) {
  const [, name, version] = PKG_INPUT.exec(input);
  return {name, version};
}
