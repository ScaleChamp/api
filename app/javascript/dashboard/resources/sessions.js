import HTTP from './client/http'

export function login (params) {
  return HTTP.post('/sessions/', params)
}

export function signup ({ passwordConfirmation, ...params }) {
  return HTTP.post('/users/', { password_confirmation: passwordConfirmation, ...params })
}

export function changeEmail (params) {
  return HTTP.post('/logins/', params)
}

export function updateUser ({ id, ...params }) {
  return HTTP.put(`/users/${id}`, params)
}
