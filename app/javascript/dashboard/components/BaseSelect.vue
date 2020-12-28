<template>
  <label class="inline-block w-full">
    <select
      v-bind="$attrs"
      :disabled="disabled"
      class="transition ease-out duration-300 border cursor-pointer opacity-100 bg-white tracking-wide font-semibold appearance-none w-full h-12 px-3 leading-tight rounded-sm focus:border-primary outline-none focus:outline-none focus:shadow-outline"
      :class="{
        'border-red-400 focus:border-red-400 focus:shadow-outline-red': danger,
        'focus:shadow-outline focus:border-primary': !danger,
        'disabled:border-gray-400 disabled:opacity-75 cursor-not-allowed': disabled,
        [border || 'border-gray-400']: !disabled,
        'text-gray-500': value === null }"
      v-on="listeners"
      @input="input"
      :value="value">
      <slot></slot>
    </select>
  </label>
</template>

<script>
export default {
  inheritAttrs: false,
  props: ['value', 'disabled', 'danger', 'border'],
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
