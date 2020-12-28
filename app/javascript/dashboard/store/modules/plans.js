import * as PlansClient from '@/resources/plans'
import { action, success, query, M } from 'vuexi'
import { generateSearchTreeByFields, byField } from '@/lib/tree'

const QUERY_PLANS = M.of('QUERY_PLANS')

export default {
  state: {
    plans: [],
    isQueryPlansLoading: false,
    queryPlansError: null
  },
  getters: {
    byKind: byField('plans', 'kind'),
    searchTree (state) {
      return generateSearchTreeByFields(state.plans, ['kind', 'version', 'cloud', 'region', 'nodes', 'name'])
    }
  },
  actions: {
    queryPlans: query(QUERY_PLANS, PlansClient.getPlans)
  },
  mutations: {
    ...action(QUERY_PLANS, 'isQueryPlansLoading', 'plans', 'queryPlansError', success)
  }
}
