import * as VPCsClient from '@/resources/vpcs'
import { success, query, M, action } from 'vuexi'
import { generateSearchTreeByFields, byField } from '@/lib/tree'

const QUERY_VPCS = M.of('QUERY_VPCS')

export default {
  state: {
    vpcs: [],
    queryVPCsError: null,
    isQueryVPCsLoading: false,
  },
  getters: {
    byCloud: byField('vpcs', 'cloud'),
  },
  actions: {
    queryVPCs: query(QUERY_VPCS, VPCsClient.getVPCs)
  },
  mutations: {
    ...action(QUERY_VPCS, 'isQueryVPCsLoading', 'vpcs', 'queryVPCsError', success)
  }
}
