import HTTP from './client/http'

export function getNodes ({ projectId, id }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/nodes/`)
}
