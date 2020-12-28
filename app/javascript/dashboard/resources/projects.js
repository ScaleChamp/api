import HTTP from './client/http'

export function getProjects (params = {}) {
  return HTTP.get(`/projects/`, { params })
}

export function getProject ({ id }) {
  return HTTP.get(`/projects/${id}`)
}

export function createProject (data) {
  return HTTP.post(`/projects/`, data)
}

export function destroyProject ({ id }) {
  return HTTP.delete(`/projects/${id}`)
}

export function updateProject ({ id, ...data }) {
  return HTTP.put(`/projects/${id}`, data)
}
