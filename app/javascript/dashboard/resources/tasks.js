import HTTP from './client/http'

export function getTasks ({ projectId, id, ...params }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/tasks/`, {
    params
  })
}
