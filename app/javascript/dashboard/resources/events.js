import HTTP from './client/http'

export function getInstanceEvents ({ id, projectId, ...params }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/events/`, { params })
}
