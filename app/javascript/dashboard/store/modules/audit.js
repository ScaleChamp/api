import * as AuditsClient from '@/resources/audit'
import { action, success, query, M } from 'vuexi'

const QUERY_AUDIT_LOGS = M.of('QUERY_AUDIT_LOGS')

export default {
  state: {
    auditLogs: [],
    queryAuditLogsError: null,
    isQueryAuditLogsLoading: false
  },
  actions: {
    getAuditLogs: query(QUERY_AUDIT_LOGS, AuditsClient.getAuditLogs)
  },
  mutations: {
    ...action(QUERY_AUDIT_LOGS, 'isQueryAuditLogsLoading', 'auditLogs', 'queryAuditLogsError', success)
  }
}
