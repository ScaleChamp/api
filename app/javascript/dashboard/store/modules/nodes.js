import * as NodesClient from '@/resources/nodes'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_NODES = M.of('QUERY_NODES')

export default {
  state: {
    nodes: [],
    isQueryNodesLoading: false,
    queryNodesError: null
  },
  actions: {
    queryNodes: query(QUERY_NODES, NodesClient.getNodes),
    pollNodes: poll(QUERY_NODES, NodesClient.getNodes)
  },
  mutations: {
    ...action(QUERY_NODES, 'isQueryNodesLoading', 'nodes', 'queryNodesError', success)
  }
}
