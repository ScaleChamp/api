import HTTP from './client/http'

export function getSecurityLogs (params) {
  return HTTP.get(`/security_logs`, {
    params
  })
}
