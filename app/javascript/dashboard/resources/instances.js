import HTTP from './client/http'

export function getInstances ({ projectId, cancelToken, ...params }) {
  return HTTP.get(`/projects/${projectId}/instances`, {
    cancelToken,
    params
  })
}

export function getInstance ({ projectId, id }) {
  return HTTP.get(`/projects/${projectId}/instances/${id}/`)
}

export function createInstance ({ projectId, ...options }) {
  return HTTP.post(`/projects/${projectId}/instances/`, options)
}

export function updateInstance ({ projectId, id, ...options }) {
  return HTTP.put(`/projects/${projectId}/instances/${id}/`, options)
}

export function destroyInstance ({ projectId, id }) {
  return HTTP.delete(`/projects/${projectId}/instances/${id}/`)
}
