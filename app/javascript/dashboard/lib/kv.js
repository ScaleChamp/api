export default function (context, regexp) {
  return context.keys().reduce((modules, filename) => {
    const name = filename.replace(regexp, '')
    modules[name] = context(filename).default
    return modules
  }, {})
}
