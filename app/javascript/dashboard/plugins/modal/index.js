import ModalContainer from './ModalContainer'
import bus from './bus'

export default {
  install (Vue) {
    Vue.component('ModalContainer', ModalContainer)
    Vue.prototype.$modal = {
      show (tag, props = {}, autoClose = false) {
        return new Promise((resolve, reject) => {
          bus.$emit('show', tag, props, resolve, reject, autoClose)
        })
      },
      hide () {
        bus.$emit('hide')
      }
    }
  }
}
