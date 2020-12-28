import HTTP from './client/http'

export function getVPCs ({ ...params }) {
  return HTTP.get(`/vpcs`, { params })
}
