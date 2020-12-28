import * as BillingClient from '@/resources/billing'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_HISTORY = M.of('QUERY_HISTORY')

export default {
  state: {
    history: [],
    isQueryHistoryLoading: false,
    queryHistoryError: null
  },
  actions: {
    queryHistory: query(QUERY_HISTORY, BillingClient.getBillingHistory),
    pollHistory: poll(QUERY_HISTORY, BillingClient.getBillingHistory)
  },
  mutations: {
    ...action(QUERY_HISTORY, 'isQueryHistoryLoading', 'history', 'queryHistoryError', success)
  }
}
