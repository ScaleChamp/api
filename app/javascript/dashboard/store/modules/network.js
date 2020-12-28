import * as NetworksClient from '@/resources/networks'
import { action, success, query, M, cached } from 'vuexi'

const QUERY_NETWORK = M.of('QUERY_NETWORK')

export default {
  state: {
    network: null,
    queryNetworkError: null,
    isQueryNetworkLoading: false,
  },
  actions: {
    queryNetwork: cached(QUERY_NETWORK, NetworksClient.getNetwork, 'networks', 'networks')
  },
  mutations: {
    ...action(QUERY_NETWORK, 'isQueryNetworkLoading', 'network', 'queryNetworkError', success)
  }
}
