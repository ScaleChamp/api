<template>
  <div class="px-2 w-full md:w-1/2 lg:w-1/3">
    <router-link :to="`/projects/${project.id}`"
                  :title="`${project.name} with ${project.role} role`">
      <div class="cursor-pointer h-56 mb-4 bg-gray-900 border-2 border-gray-900 rounded-sm overflow-hidden hover:border-gray-700 hover:bg-gray-700">
        <div class="flex items-center">
          <h2 class="text-2xl text-white px-6 py-3 font-semibold">
            {{ project.name }}
          </h2>
          <Loading v-if="project.role === 'owner'" class="ml-auto text-white fill-current h-6 w-6 mr-6" />
        </div>
        <div class="bg-white rounded-sm">
          <p class="text-sm text-center text-gray-800 font-semibold py-12 uppercase">
            {{ project.description || project.name }}
          </p>
          <div class="flex">
            <p class="ml-auto text-sm text-gray-800 px-6 py-3 text-right font-semibold">
              {{ $t('instance_created') }} {{ project.created_at | fromNow($i18n.locale) }}
            </p>
          </div>
        </div>
      </div>
    </router-link>
  </div>
</template>

<script>
export default {
  props: ['to', 'project']
}
</script>
