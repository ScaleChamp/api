import HTTP from './client/http'

export function createTicket ({ projectId, data }) {
  return HTTP.post(`/projects/${projectId}/tickets/`, data)
}
