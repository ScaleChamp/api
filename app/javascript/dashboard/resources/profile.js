import HTTP from './client/http'

export function update (data) {
  return HTTP.put('/users/', data)
}

export function getProfile () {
  return HTTP.get('/users/')
}

export function destroyProfile ({ id }) {
  return HTTP.delete(`/users/${id}`)
}
