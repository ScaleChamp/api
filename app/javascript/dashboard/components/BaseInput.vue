<template>
  <label class="inline-block w-full relative text-black">
    <span v-if="prefix"
          class="absolute pl-4 font-semibold text-gray-500 flex items-center top-0 text-md"
          style="line-height: 3rem">
      {{ prefix }}
    </span>
    <input
      :disabled="disabled"
      v-on="listeners"
      @input="input"
      :value="value"
      class="transition ease-out duration-300 disabled:bg-white disabled:opacity-75 tracking-wide placeholder-gray-500 font-semibold appearance-none w-full h-12 px-3 leading-tight border rounded-sm outline-none focus:outline-none"
      :class="{
        'border-red-400 focus:border-red-400 focus:shadow-outline-red': danger,
        'border-gray-400 focus:shadow-outline focus:border-primary': !danger,
        'pl-8': prefix }"
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
    'danger',
    'prefix'
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
