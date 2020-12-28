import * as NetworksClient from '@/resources/networks'
import { action, success, query, push, poll, removeById, M } from 'vuexi'

const QUERY_NETWORKS = M.of('QUERY_NETWORKS')
const CREATE_NETWORK = M.of('CREATE_NETWORK')
const DELETE_NETWORK = M.of('DELETE_NETWORK')

export default {
  state: {
    networks: [],
    queryNetworksError: null,
    isQueryNetworksLoading: false,
    createNetworkError: null,
    isCreateNetworkLoading: false,
    deleteNetworkError: null,
    isDeleteNetworkLoading: false
  },
  actions: {
    queryNetworks: query(QUERY_NETWORKS, NetworksClient.getNetworks),
    pollNetworks: poll(QUERY_NETWORKS, NetworksClient.getNetworks),
    createNetwork: query(CREATE_NETWORK, NetworksClient.createNetwork),
    deleteNetwork: query(DELETE_NETWORK, NetworksClient.destroyNetwork)
  },
  mutations: {
    ...action(QUERY_NETWORKS, 'isQueryNetworksLoading', 'networks', 'queryNetworksError', success),
    ...action(CREATE_NETWORK, 'isCreateNetworkLoading', 'networks', 'createNetworkError', push),
    ...action(DELETE_NETWORK, 'isDeleteNetworkLoading', 'networks', 'deleteNetworkError', removeById)
  }
}
