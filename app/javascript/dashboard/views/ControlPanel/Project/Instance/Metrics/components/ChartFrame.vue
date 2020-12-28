<template>
  <div class="border border-gray-400">
    <h3 class="text-lg text-center bg-gray-100 py-2 border-b border-gray-400">{{ name }}</h3>
    <div class="w-full relative p-2">
      <slot />
    </div>
  </div>
</template>

<script>
export default {
  props: ['name']
}
</script>
