import HTTP from './client/http'

export function getMetrics ({ id, projectId }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/metrics/`)
}
