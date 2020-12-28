import readableBytes from 'readable-bytes'
import dayjs from '@/lib/dayjs'

function currency (value, minimumFractionDigits) {
  const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits
  })
  return formatter.format(value)
}

export default {
  install (Vue) {
    Vue.filter('currency', currency)
    Vue.filter('fromNow', (timestamp, locale) => dayjs(timestamp).locale(locale).fromNow())
    Vue.filter('readableBytes', value => readableBytes(value))

    function validate (binding) {
      if (typeof binding.value !== 'function') {
        return false
      }
      return true
    }

    function isPopup (popupItem, elements) {
      if (!popupItem || !elements) {
        return false
      }

      for (let i = 0, len = elements.length; i < len; i++) {
        try {
          if (popupItem.contains(elements[i])) {
            return true
          }
          if (elements[i].contains(popupItem)) {
            return false
          }
        } catch (e) {
          return false
        }
      }
      return false
    }

    Vue.directive('click-outside', {
      bind: function (el, binding, vNode) {
        if (!validate(binding)) return
        function handler (e) {
          if (!vNode.context) return
          let elements = e.path || (e.composedPath && e.composedPath())
          elements && elements.length > 0 && elements.unshift(e.target)
          if (el.contains(e.target) || isPopup(vNode.context.popupItem, elements)) return
          el.__vueClickOutside__.callback(e)
        }
        el.__vueClickOutside__ = {
          handler: handler,
          callback: binding.value
        }
        const clickHandler = 'ontouchstart' in document.documentElement ? 'touchstart' : 'click'
        document.addEventListener(clickHandler, handler)
      },
      update: function (el, binding) {
        if (validate(binding)) el.__vueClickOutside__.callback = binding.value
      },
      unbind: function (el, binding, vNode) {
        const clickHandler = 'ontouchstart' in document.documentElement ? 'touchstart' : 'click'
        el.__vueClickOutside__ && document.removeEventListener(clickHandler, el.__vueClickOutside__.handler)
        delete el.__vueClickOutside__
      }
    })
  }
}
