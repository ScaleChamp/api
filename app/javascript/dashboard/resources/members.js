import HTTP from './client/http'

export function getMembers ({ projectId }) {
  return HTTP.get(`/projects/${projectId}/members`)
}

export function inviteMember ({ projectId, ...args }) {
  return HTTP.post(`/projects/${projectId}/members`, args)
}

export function updateMember ({ projectId, id, ...args }) {
  return HTTP.patch(`/projects/${projectId}/members/${id}`, args)
}

export function destroyMember ({ projectId, id }) {
  return HTTP.delete(`/projects/${projectId}/members/${id}`)
}

export function getProjectByInvite ({ id }) {
  return HTTP.get(`/invitations/${id}`)
}

export function confirmInvite ({ id }) {
  return HTTP.put(`/invitations/${id}`)
}
