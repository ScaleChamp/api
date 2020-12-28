import * as InstancesClient from '@/resources/instances'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_INSTANCES = M.of('QUERY_INSTANCES')

export default {
  state: {
    instances: [],
    isQueryInstancesLoading: false,
    queryInstancesError: null
  },
  actions: {
    queryInstances: query(QUERY_INSTANCES, InstancesClient.getInstances),
    pollInstances: poll(QUERY_INSTANCES, InstancesClient.getInstances)
  },
  mutations: {
    ...action(QUERY_INSTANCES, 'isQueryInstancesLoading', 'instances', 'queryInstancesError', success)
  }
}
