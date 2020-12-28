import * as SecurityClient from '@/resources/security'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_SECURITY_LOGS = M.of('QUERY_SECURITY_LOGS')

export default {
  state: {
    securityLogs: [],
    isQuerySecurityLogsLoading: false,
    querySecurityLogsError: null
  },
  actions: {
    querySecurityLogs: query(QUERY_SECURITY_LOGS, SecurityClient.getSecurityLogs),
    pollSecurityLogs: poll(QUERY_SECURITY_LOGS, SecurityClient.getSecurityLogs)
  },
  mutations: {
    ...action(QUERY_SECURITY_LOGS, 'isQuerySecurityLogsLoading', 'securityLogs', 'querySecurityLogsError', success)
  }
}
