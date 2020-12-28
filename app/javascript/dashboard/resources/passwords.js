import HTTP from './client/http'

export function forgetPassword ({ email }) {
  return HTTP.post('/passwords', { email })
}

export function recoverPassword ({ id, password, passwordConfirmation }) {
  return HTTP.patch(`/passwords/${id}`, { password, password_confirmation: passwordConfirmation })
}
