import Vue from 'vue'
import Vuex from 'vuex'
import crosstab from './plugins/crosstab'
import kv from '@/lib/kv'

const modules = kv(require.context('@/store/modules', false, /\.(js)$/), /(\.\/|\.js)/g)

for (const name in modules) {
  modules[name].namespaced = true
}

Vue.use(Vuex)

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules,
  plugins: [crosstab]
})
