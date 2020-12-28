import HTTP from './client/http'

export function getSnapshots ({ projectId, id, ...params }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/snapshots/`, {
    params
  })
}
