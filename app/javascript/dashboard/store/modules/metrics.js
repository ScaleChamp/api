import * as MetricsClient from '@/resources/metrics'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_METRICS = M.of('QUERY_METRICS')

export default {
  state: {
    metrics: [],
    isQueryMetricsLoading: false,
    queryMetricsError: null
  },
  actions: {
    queryMetrics: query(QUERY_METRICS, MetricsClient.getMetrics),
    pollMetrics: poll(QUERY_METRICS, MetricsClient.getMetrics)
  },
  mutations: {
    ...action(QUERY_METRICS, 'isQueryMetricsLoading', 'metrics', 'queryMetricsError', success)
  }
}
