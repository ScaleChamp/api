import HTTP from './client/http'

export function enableOtp () {
  return HTTP.post(`/otp/enable`)
}

export function confirmOtp (params) {
  return HTTP.post(`/otp/confirm`, params)
}

export function confirmRecoveryCodes () {
  return HTTP.post(`/otp/recovery_codes`)
}

export function disableOtp () {
  return HTTP.delete(`/otp/disable`)
}
