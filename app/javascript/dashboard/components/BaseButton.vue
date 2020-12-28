<template>
  <component
    :is="$attrs.to ? 'router-link' : ($attrs.href ? 'a' : 'button')"
    v-bind="$attrs"
    v-on="$listeners"
    class="transition ease-out duration-300 inline-block whitespace-no-wrap h-12 border border-transparent px-4 leading-none rounded-sm font-semibold tracking-wide appearance-none outline-none focus:outline-none base-button"
    :class="{ 'is-loading': isLoading }"><slot>{{ $attrs.textContent }}</slot></component>
</template>

<script>
export default {
  props: ['isLoading']
}
</script>
