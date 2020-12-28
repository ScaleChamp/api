import router from '@/router'

const userKey = 'user'
const refreshAction = 'sessions/refresh'
const logoutAction = 'sessions/logout'
const updateMutations = [
  'sessions/LOGIN',
  'sessions/LOGOUT',
  'sessions/SIGNUP'
]

export default function (store) {
  if (store.state.sessions[userKey]) {
    const data = JSON.stringify(store.state.sessions[userKey])
    localStorage.setItem(userKey, data)
  } else {
    localStorage.removeItem(userKey)
  }

  const onUser = ({ key, newValue, oldValue }) => {
    if (newValue && oldValue === null) {
      const value = JSON.parse(newValue)
      store.dispatch(refreshAction, value)
      router.replace({ name: 'projects' })
    } else if (newValue === null && oldValue) {
      store.dispatch(logoutAction)
      router.replace({ name: 'login' })
    } else {
      const value = JSON.parse(newValue)
      store.dispatch(refreshAction, value)
    }
  }

  const onStorage = (event) => {
    if (event.key === userKey) onUser(event)
  }

  if (window.chrome || window.webkit || window.opera) {
    window.addEventListener('storage', onStorage, false)
  } else {
    document.body.addEventListener('storage', onStorage, false)
  }

  store.subscribe((mutation, state) => {
    if (updateMutations.includes(mutation.type)) {
      if (!mutation.payload) {
        localStorage.removeItem(userKey)
      } else {
        const data = JSON.stringify(mutation.payload)
        localStorage.setItem(userKey, data)
      }
    }
  })
}
