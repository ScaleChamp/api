import * as ProjectsClient from '@/resources/projects'
import { action, success, query, poll, cached, M } from 'vuexi'

const QUERY_PROJECT = M.of('QUERY_PROJECT')
const UPDATE_PROJECT = M.of('UPDATE_PROJECT')
const DESTROY_PROJECT = M.of('DESTROY_PROJECT')

export default {
  state: {
    project: null,
    isQueryProjectLoading: false,
    queryProjectError: null,
    isProjectUpdating: false,
    projectUpdateError: null,
    isDestroyProjectLoading: false,
    destroyProjectError: null
  },
  getters: {
    ownerOrAccountant (state) {
      return state.project && ['owner', 'accountant'].includes(state.project.role)
    },
    ownerOrAdministrator (state) {
      return state.project && ['owner', 'administrator'].includes(state.project.role)
    },
    notAccountant (state) {
      return state.project && state.project.role !== 'accountant'
    },
    notMember (state) {
      return state.project && state.project.role !== 'member'
    }
  },
  actions: {
    queryProject: cached(QUERY_PROJECT, ProjectsClient.getProject, 'projects', 'projects'),
    queryProjectDirectly: query(QUERY_PROJECT, ProjectsClient.getProject),
    pollProject: poll(QUERY_PROJECT, ProjectsClient.getProject),
    updateProject: query(UPDATE_PROJECT, ProjectsClient.updateProject),
    destroyProject: query(DESTROY_PROJECT, ProjectsClient.destroyProject)
  },
  mutations: {
    ...action(DESTROY_PROJECT, 'isDestroyProjectLoading', 'project', 'destroyProjectError', success),
    ...action(QUERY_PROJECT, 'isQueryProjectLoading', 'project', 'queryProjectError', success),
    ...action(UPDATE_PROJECT, 'isProjectUpdating', 'project', 'projectUpdateError', success)
  }
}
