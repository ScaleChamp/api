import Vue from 'vue'
import Router from 'vue-router'
import { route } from 'vuexi'
import store from '@/store'
import ControlPanel from '@/views/ControlPanel'
import Instances from '@/views/ControlPanel/Project/Instances'
import NewInstance from '@/views/ControlPanel/Project/NewInstance'
import Billing from '@/views/ControlPanel/Project/Billing'
import Login from '@/views/Lobby/Login'
import Signup from '@/views/Lobby/Signup'
import User from '@/views/ControlPanel/User'
import Project from '@/views/ControlPanel/Project'
import Projects from '@/views/ControlPanel/User/Projects'
import Lobby from '@/views/Lobby'
import { tabByRole } from '@/lib/tabrole'

const SecurityLogs = () => import(/* webpackChunkName: "user", webpackPrefetch: 5 */ '@/views/ControlPanel/User/SecurityLogs')
const AuditLog = () => import(/* webpackChunkName: "user", webpackPrefetch: 8 */ '@/views/ControlPanel/Project/AuditLog')
const Notifications = () => import(/* webpackChunkName: "project", webpackPrefetch: 6 */ '@/views/ControlPanel/Project/Notifications')
const VPC = () => import(/* webpackChunkName: "project", webpackPrefetch: 6 */ '@/views/ControlPanel/Project/VPC')
const Peers = () => import(/* webpackChunkName: "project", webpackPrefetch: 5 */ '@/views/ControlPanel/Project/Peers')
const Connectors = () => import(/* webpackChunkName: "project", webpackPrefetch: 6 */ '@/views/ControlPanel/Project/Connectors')
const ProjectProfile = () => import(/* webpackChunkName: "project", webpackPrefetch: 8 */ '@/views/ControlPanel/Project/ProjectProfile')
const API = () => import(/* webpackChunkName: "project", webpackPrefetch: 8 */ '@/views/ControlPanel/Project/ApiKeys')
const Members = () => import(/* webpackChunkName: "project", webpackPrefetch: 8 */ '@/views/ControlPanel/Project/Members')
const Support = () => import(/* webpackChunkName: "project", webpackPrefetch: 6 */ '@/views/ControlPanel/Project/Support')
const ForgotPassword = () => import(/* webpackPrefetch: 9 */ '@/views/Lobby/ForgotPassword')
const NotFound = () => import(/* webpackPrefetch: 4 */ '@/views/NotFound')
const UserProfile = () => import(/* webpackChunkName: "user", webpackPrefetch: 7 */ '@/views/ControlPanel/User/UserProfile')
const Logs = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Logs')
const Instance = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance')
const InstanceSettings = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Settings')
const EditInstance = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/EditInstance')
const Firewall = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Firewall')
const Metrics = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Metrics')
const Nodes = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Nodes')
const Snapshots = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Snapshots')
const Jobs = () => import(/* webpackChunkName: "instance", webpackPrefetch: 7 */ '@/views/ControlPanel/Project/Instance/Jobs')

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    route('', ControlPanel, {
      children: [
        route('', User, {
          children: [
            route('', undefined, { redirect: { name: 'projects' } }),
            route('projects', Projects, { name: 'projects' }),
            route('profile', UserProfile, { name: 'profile' }),
            route('security-log', SecurityLogs, { name: 'security-log' })
          ]
        }),
        route('projects/:projectId', Project, {
          children: [
            route('', undefined, {
              redirect (to) {
                const tab = tabByRole(store.state.projects.projects.find(x => x.id === to.params.projectId).role)
                return `/projects/${to.params.projectId}/${tab}`
              }
            }),
            route('services', Instances, { name: 'services' }),
            route('audit-log', AuditLog, { name: 'audit-log' }),
            route('services/new', NewInstance, { name: 'new-instance' }),
            route('services/:id/edit', EditInstance, { name: 'edit-instance' }),
            route('notifications', Notifications, { name: 'notifications' }),
            route('vpcs', VPC, { name: 'vpc' }),
            route('vpcs/:id', Peers, { name: 'peers' }),
            route('connectors', Connectors, { name: 'connectors' }),
            route('members', Members, { name: 'members' }),
            route('project', ProjectProfile, { name: 'project' }),
            route('api', API, { name: 'api' }),
            route('billing', Billing, { name: 'billing' }),
            route('support', Support, { name: 'support' }),
            route('services/:id', Instance, {
              children: [
                route('', undefined, { redirect: { name: 'settings' } }),
                route('nodes', Nodes, { name: 'nodes' }),
                route('settings', InstanceSettings, { name: 'settings' }),
                route('snapshots', Snapshots, { name: 'snapshots' }),
                route('jobs', Jobs, { name: 'jobs' }),
                route('firewall', Firewall, { name: 'firewall' }),
                route('log', Logs, { name: 'log' }),
                route('metrics', Metrics, { name: 'metrics' })
              ]
            })
          ]
        })
      ]
    }),
    route('', Lobby, {
      children: [
        route('', undefined, { redirect: { name: 'login' } }),
        route('login', Login, {
          name: 'login',
          meta: {
            login: true
          }
        }),
        route('forgot/password', ForgotPassword, {
          name: 'forgot-password',
          meta: {
            login: true
          }
        }),
        route('register', Signup, {
          name: 'register',
          meta: {
            login: true
          }
        })
      ]
    }),
    route('*', NotFound, {
      name: 'not-found',
      meta: {
        missing: true
      }
    })
  ]
})

router.beforeEach(beforeEach)

function beforeEach (to, from, next) {
  if (to.meta.login) {
    onLogin(to, from, next)
  } else if (to.meta.missing) {
    onNotFound(next)
  } else {
    onUnauthorizedRedirectToLogin(to, from, next)
  }
}

function title (to) {
  if (to.name) {
    const routeName = to.name
      .split('-')
      .map(s => s.replace('api', 'API').replace('vpc', 'VPC').replace(/^./, s[0].toUpperCase()))
      .join(' ')
    const title = `ScaleChamp | ${routeName}`
    document.title = title + ' #1'
    document.title = title
  } else {
    document.title = 'ScaleChamp | Control Panel #1'
    document.title = 'ScaleChamp | Control Panel'
  }
  return to
}

function onUnauthorizedRedirectToLogin (to, from, next) {
  if (store.state.sessions.user) {
    next()
    Vue.nextTick(() => title(to))
  } else {
    next(title(redirect('login', to.params)))
  }
}

function onLogin (to, from, next) {
  if (store.state.sessions.user) {
    next(title(redirect('projects', to.params)))
  } else {
    title(to)
    next()
  }
}

function onNotFound (next) {
  console.log('fuck')
  title({ name: 'not-found' })
  next()
}

function redirect (name, params, replace = true) {
  return {
    params,
    name,
    replace
  }
}

export default router
