import HTTP from './client/http'

export function paddleCheckout ({ projectId, id }) {
  return HTTP.put(`/projects/${projectId}/paddle/${id}`)
}

export function generatePayLink ({ projectId, ...params }) {
  return HTTP.post(`/projects/${projectId}/paddle`, params) // amount
}
