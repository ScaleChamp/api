import * as LogsClient from '@/resources/logs'
import { action, success, query, push, commit, M } from 'vuexi'

const QUERY_LOGS = M.of('QUERY_LOGS')
const ADD_LOG = 'ADD_LOG'

export default {
  state: {
    logs: [],
    isQueryLogsLoading: false,
    queryLogsError: null
  },
  getters: {
    logs (state) {
      return state.logs.map((line) => Object.assign({}, line, { nodeId: line.node_id.slice(0, 8) }))
    },
    nodesFromLogs (state) {
      const cache = {}
      return state.logs.reduce((acc, next) => {
        if (!cache[next.node_id]) {
          cache[next.node_id] = true
          acc.push(next.node_id)
        }
        return acc
      }, [])
    },
    byNodeId (state) {
      return nodeId => {
        return state.logs.filter(x => x.node_id.startsWith(nodeId))
          .map((line, index) => Object.assign({}, line, {
            nodeId: line.node_id.slice(0, 8),
            created_at: index + 1
          }))
      }
    }
  },
  actions: {
    queryLogs: query(QUERY_LOGS, LogsClient.getLogs),
    addLog: commit(ADD_LOG)
  },
  mutations: {
    ...action(QUERY_LOGS, 'isQueryLogsLoading', 'logs', 'queryLogsError', success),
    [ADD_LOG]: push('isQueryLogsLoading', 'logs')
  }
}
