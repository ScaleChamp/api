import kv from '@/lib/kv'

const components = kv(require.context('@/components', false, /\.(vue)$/), /(\.\/|\.vue)/g)

export default {
  install (Vue) {
    for (const key in components) {
      Vue.component(key, components[key])
    }
  }
}
