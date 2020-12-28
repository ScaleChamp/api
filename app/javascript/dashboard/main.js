import Vue from 'vue'
import Vuelidate from 'vuelidate'
import router from './router'
import store from './store'
import App from './App.vue'
import PusherPlugin from './plugins/pusher'
import RefererPlugin from './plugins/referer'
import ModalPlugin from './plugins/modal'
import FilterPlugin from './plugins/filter'
import ComponentsPlugin from './plugins/components'
import i18n from './i18n'
import PaddlePlugin from './plugins/paddle'
import VueAnalytics from 'vue-analytics'
import './assets/css/ScaleChamp_Control_Panel.css'

const environment = process.env.NODE_ENV || 'development'
const production = environment === 'production'

Vue.config.productionTip = production

Vue.use(ComponentsPlugin)
Vue.use(FilterPlugin)
Vue.use(ModalPlugin)
Vue.use(PusherPlugin)
Vue.use(RefererPlugin)
Vue.use(PaddlePlugin)
Vue.use(Vuelidate)
Vue.use(VueAnalytics, {
  id: 'UA-174042865-1',
  linkers: ['www.scalechamp.com'],
  debug: {
    sendHitTask: production
  }
})

new Vue({
  i18n,
  router,
  store,
  render: h => h(App)
}).$mount('#app')
