<template>
  <div class="flex items-center space-x-2">
    <div class="w-8 h-8 rounded-sm overflow-hidden bg-gray-100">
      <img :src="user.avatar_url" :alt="user.name" class="w-full h-full">
    </div>
    <div>
      <div>{{ user.name }}</div>
      <div class="text-sm text-gray-500">{{ user.email }}</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['user']
}
</script>
