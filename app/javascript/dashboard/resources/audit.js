import HTTP from './client/http'

export function getAuditLogs ({ projectId, ...params }) {
  return HTTP.get(`/projects/${projectId}/audit_logs/`, {
    params
  })
}
