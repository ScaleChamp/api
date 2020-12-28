import * as ProjectsClient from '@/resources/projects'
import { action, success, query, push, poll, M } from 'vuexi'

const QUERY_PROJECTS = M.of('QUERY_PROJECTS')
const CREATE_PROJECT = M.of('CREATE_PROJECT')

export default {
  state: {
    projects: [],
    queryProjectsError: null,
    isQueryProjectsLoading: false,
    createProjectError: null,
    isCreateProjectLoading: false
  },
  actions: {
    queryProjects: query(QUERY_PROJECTS, ProjectsClient.getProjects),
    pollProjects: poll(QUERY_PROJECTS, ProjectsClient.getProjects),
    createProject: query(CREATE_PROJECT, ProjectsClient.createProject)
  },
  mutations: {
    ...action(QUERY_PROJECTS, 'isQueryProjectsLoading', 'projects', 'queryProjectsError', success),
    ...action(CREATE_PROJECT, 'isCreateProjectLoading', 'projects', 'createProjectError', push)
  }
}
