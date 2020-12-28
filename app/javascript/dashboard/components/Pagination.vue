<template>
  <div class="flex items-center justify-center space-x-3 font-semibold text-decoration-none" v-if="links">
    <router-link v-if="links.prev" :to="{ name, query: { page: links.prev.page} }"  class="text-primary">
      {{ $t('pagination.previous') }}
    </router-link>
    <a v-else class="text-gray-300 cursor-default">
      {{ $t('pagination.previous') }}
    </a>

    <router-link class="text-primary hover:bg-gray-200 p-1 w-8 text-center text-white rounded-sm inline-block" :to="{ name, query: { page: links.first.page} }" v-if="links.first">{{ links.first.page }}</router-link>

    <span class="text-primary text-center text-white rounded-sm inline-block"
                 v-if="(+page) - 1 > 0 && (+page) - 1 != links.first.page">. . .</span>
    <span class="bg-primary p-1 w-8 text-center text-white rounded-sm inline-block">{{ page }}</span>
    <span class="text-primary text-center text-white rounded-sm inline-block"
          v-if="links.last && (+page) + 1 != links.last.page">. . .</span>

    <router-link class="text-primary bg-gray-100 hover:bg-gray-200 p-1 w-8 text-center text-white rounded-sm text-decoration-none inline-block" :to="{ name, query: { page: links.last.page} }" v-if="links.last">{{ links.last.page }}</router-link>

    <router-link v-if="links.next" :to="{ name, query: { page: links.next.page} }" class="text-primary">
      {{ $t('pagination.next') }}
    </router-link>
    <a v-else class="text-gray-300 cursor-default font-semibold text-decoration-none">
      {{ $t('pagination.next') }}
    </a>
  </div>
</template>

<script>
export default {
  props: {
    links: Object,
    name: String,
    page: {
      default: '1'
    }
  }
}
</script>
