import HTTP from './client/http'

export function getBillingHistory ({ projectId, ...params }) {
  return HTTP.get(`/projects/${projectId}/billing/`, {
    params
  })
}
