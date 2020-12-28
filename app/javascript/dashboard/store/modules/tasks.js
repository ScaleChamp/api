import * as TasksClient from '@/resources/tasks'
import { action, success, query, poll, M } from 'vuexi'

const QUERY_TASKS = M.of('QUERY_TASKS')

export default {
  state: {
    tasks: [],
    isQueryTasksLoading: false,
    queryTasksError: null
  },
  actions: {
    queryTasks: query(QUERY_TASKS, TasksClient.getTasks),
    pollTasks: poll(QUERY_TASKS, TasksClient.getTasks)
  },
  mutations: {
    ...action(QUERY_TASKS, 'isQueryTasksLoading', 'tasks', 'queryTasksError', success)
  }
}
