import HTTP from './client/http'

export function getLogs ({ projectId, id }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/logs/`)
}
