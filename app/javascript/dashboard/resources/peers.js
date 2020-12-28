import HTTP from './client/http'

export function getPeers ({ projectId, networkId, ...params }) {
  return HTTP.get(`/projects/${projectId}/virtual_networks/${networkId}/peers/`, { params })
}

export function createPeer ({ projectId, networkId, ...params }) {
  return HTTP.post(`/projects/${projectId}/virtual_networks/${networkId}/peers/`, params)
}

export function destroyPeer ({ projectId, networkId, id  }) {
  return HTTP.delete(`/projects/${projectId}/virtual_networks/${networkId}/peers/${id}`)
}
