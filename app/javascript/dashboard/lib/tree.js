export function generateSearchTreeByFields (array, fields) {
  const result = {}
  for (const item of array) {
    for (let i = 0, field = result; i < fields.length; i += 1) {
      field = field[item[fields[i]]] = (i === fields.length - 1) ? item : (field[item[fields[i]]] || {})
    }
  }
  return result
}

export function byField (resource, field) {
  return function (state) {
    return state[resource].reduce((acc, item) => {
      acc[item[field]] = acc[item[field]] || []
      acc[item[field]].push(item)
      return acc
    }, {})
  }
}
