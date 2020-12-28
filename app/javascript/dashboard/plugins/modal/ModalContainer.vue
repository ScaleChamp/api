<template>
  <fade-transition @after-enter="presented = true">
    <div v-if="displayed"
         class="w-full h-full absolute left-0 top-0 bg-gray-900 bg-opacity-50 overflow-y-auto"
         @mousedown.self="close">
      <slide-transition @after-leave="afterLeave">
        <component
          v-if="presented"
          :key="key"
          :is="tag"
          v-bind="params"
          @success="resolve"
          @failure="reject"
        />
      </slide-transition>
    </div>
  </fade-transition>
</template>

<script>
import bus from './bus'
import FadeTransition from '@/transitions/FadeTransition'
import SlideTransition from '@/transitions/SlideTransition'

export default {
  components: {
    FadeTransition,
    SlideTransition
  },
  data () {
    return {
      key: null,
      params: null,
      tag: null,
      presented: false,
      displayed: false
    }
  },
  methods: {
    afterLeave () {
      if (!this.presented) {
        this.displayed = false
      }
    },
    onEsc (event) {
      if (event.keyCode === 27) {
        this.close()
      }
    },
    close (data) {
      if (this.displayed && this.presented) {
        this.reject(data)
      }
    },
    show (tag, props, resolve, reject, autoClose = false) {
      this.tag = tag
      this.params = props
      this.key = Math.random()

      if (autoClose) {
        this.resolve = (x) => {
          this.presented = false
          resolve(x)
        }
        this.reject = (x) => {
          this.presented = false
          reject(x)
        }
      } else {
        this.resolve = resolve
        this.reject = reject
      }
      this.displayed = true
    },
    hide () {
      this.reject = null
      this.resolve = null
      this.presented = false
    }
  },
  created () {
    this._onEsc = this.onEsc.bind(this)
    document.addEventListener('keyup', this._onEsc)

    this._show = this.show.bind(this)
    this._hide = this.hide.bind(this)

    bus.$on('show', this._show)
    bus.$on('hide', this._hide)
  },
  destroyed () {
    if (this.reject) this.reject()
    document.removeEventListener('keyup', this._onEsc)
    bus.$off('show', this._show)
    bus.$off('hide', this._hide)
  }
}
</script>
