import axios from 'axios'
import router from '@/router'
import store from '@/store'

const client = axios.create({
  withCredentials: true,
  baseURL: '/api/v1/',
  timeout: 20000,
  xsrfCookieName: '_csrf_token',
  xsrfHeaderName: 'X-CSRF-Token',
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/json'
  }
})

function onFulfilled (response) {
  return response
}

function onRejected (err) {
  if (err.response.status === 401 && router.currentRoute.path !== '/login') {
    store.dispatch('sessions/logout')
    router.replace({ name: 'login' })
  }
  return Promise.reject(err)
}

client.interceptors.response.use(onFulfilled, onRejected)

export default client
