import * as EventsClient from '@/resources/events'
import { action, success, query, M } from 'vuexi'

const QUERY_EVENTS = M.of('QUERY_EVENTS')

export default {
  state: {
    events: [],
    isQueryEventsLoading: false,
    queryEventsError: null
  },
  actions: {
    queryEvents: query(QUERY_EVENTS, EventsClient.getInstanceEvents)
  },
  mutations: {
    ...action(QUERY_EVENTS, 'isQueryEventsLoading', 'events', 'queryEventsError', success)
  }
}
