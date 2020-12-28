import * as SnapshotsClient from '@/resources/snapshots'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_INSTANCE_SNAPSHOTS = M.of('QUERY_INSTANCE_SNAPSHOTS')

export default {
  state: {
    snapshots: [],
    querySnapshotsError: null,
    isQuerySnapshotsLoading: false
  },
  actions: {
    querySnapshots: query(QUERY_INSTANCE_SNAPSHOTS, SnapshotsClient.getSnapshots),
    pollSnapshots: poll(QUERY_INSTANCE_SNAPSHOTS, SnapshotsClient.getSnapshots)
  },
  mutations: {
    ...action(QUERY_INSTANCE_SNAPSHOTS, 'isQuerySnapshotsLoading', 'snapshots', 'querySnapshotsError', success)
  }
}
