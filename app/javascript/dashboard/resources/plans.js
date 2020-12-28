import HTTP from './client/http'

export function getPlans () {
  return HTTP.get('/plans/')
}
