import * as PeersClient from '@/resources/peers'
import { action, success, query, push, poll, removeById, M } from 'vuexi'

const QUERY_PEERS = M.of('QUERY_PEERS')
const CREATE_PEER = M.of('CREATE_PEER')
const DELETE_PEER = M.of('DELETE_PEER')

export default {
  state: {
    peers: [],
    queryPeersError: null,
    isQueryPeersLoading: false,
    createPeerError: null,
    isCreatePeerLoading: false,
    deletePeerError: null,
    isDeletePeerLoading: false
  },
  actions: {
    queryPeers: query(QUERY_PEERS, PeersClient.getPeers),
    pollPeers: poll(QUERY_PEERS, PeersClient.getPeers),
    createPeer: query(CREATE_PEER, PeersClient.createPeer),
    deletePeer: query(DELETE_PEER, PeersClient.destroyPeer)
  },
  mutations: {
    ...action(QUERY_PEERS, 'isQueryPeersLoading', 'peers', 'queryPeersError', success),
    ...action(CREATE_PEER, 'isCreatePeerLoading', 'peers', 'createPeerError', push),
    ...action(DELETE_PEER, 'isDeletePeerLoading', 'peers', 'deletePeerError', removeById)
  }
}
