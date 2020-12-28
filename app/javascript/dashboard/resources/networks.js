import HTTP from './client/http'

export function getNetworks ({ projectId, ...params }) {
  return HTTP.get(`/projects/${projectId}/virtual_networks/`, { params })
}

export function getNetwork ({ projectId, id, ...params }) {
  return HTTP.get(`/projects/${projectId}/virtual_networks/${id}`, { params })
}

export function createNetwork ({ projectId, ...params }) {
  return HTTP.post(`/projects/${projectId}/virtual_networks/`, params)
}

export function destroyNetwork ({ projectId, id  }) {
  return HTTP.delete(`/projects/${projectId}/virtual_networks/${id}`)
}
