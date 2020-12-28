<template>
  <label class="block w-full">
    <textarea
      :disabled="disabled"
      v-on="listeners"
      @input="input"
      :value="value"
      class="transition ease-out duration-300 block tracking-wide text-black placeholder-gray-500 font-semibold appearance-none w-full px-3 py-3 h-24 leading-tight border border-gray-400 rounded-sm focus:outline-none"
      :class="{
         'border-red-400 focus:border-red-400 focus:shadow-outline-red': danger,
         'focus:shadow-outline focus:border-primary': !danger
      }"
      v-bind="$attrs"
    />
  </label>
</template>

<script>
export default {
  inheritAttrs: false,
  props: [
    'value',
    'disabled',
    'danger'
  ],
  computed: {
    listeners () {
      const { input, ...listeners } = this.$listeners
      return listeners
    }
  },
  methods: {
    input (event) {
      this.$emit('input', event.target.value)
    }
  }
}
</script>
