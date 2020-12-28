import HTTP from './client/http'

export function getAccessKeys ({ projectId }) {
  return HTTP.get(`/projects/${projectId}/access_keys/`)
}

export function createAccessKey ({ projectId, ...args }) {
  return HTTP.post(`/projects/${projectId}/access_keys/`, args)
}

export function updateAccessKey ({ projectId, id, ...args }) {
  return HTTP.put(`/projects/${projectId}/access_keys/${id}`, args)
}

export function deleteAccessKey ({ projectId, id }) {
  return HTTP.delete(`/projects/${projectId}/access_keys/${id}`)
}
