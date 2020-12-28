<template>
  <div>
    <LoadingTab v-if="isQueryProjectLoading"/>
    <template v-else-if="queryProjectError">
      {{ profileError.message }}
    </template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('project') }}</h1>
      <section class="flex items-center justify-between items-stretch space-x-5">
        <div class="min-h-full" style="width: 150px; height: 150px">
          <img :src="project.avatar_url" class="h-full w-full rounded-full" alt="Project Avatar" />
        </div>
        <div class="flex-1 min-h-full flex justify-center flex-col text-lg">
          <h2 class="font-semibold capitalize">{{ project.name }}</h2>
          <h2>{{ project.description }}</h2>
          <h2>{{ project.currency.toUpperCase() }}</h2>
          <router-link :to="{ name: 'support' }" class="text-primary hover:text-primary-100">
            {{ $t('project_profile.services_limit') }}{{ project.services_count_limit }}
          </router-link>
        </div>
        <div class="flex flex-col justify-between text-right">
          <div>
            <BaseButton class="disabled:bg-gray-300 disabled:text-white text-gray-600"
                        :class="{ 'border border-gray-500 hover:bg-gray-500 hover:text-white': project.role == 'owner', 'cursor-not-allowed': project.role != 'owner' }"
                        :disabled="project.role != 'owner'"
                        @click="showEditProjectModal">
              {{ $t('project_profile.edit') }}
            </BaseButton>
          </div>
          <div>
            <p class="font-semibold text-gray-500">
              {{ $t('instance_created') }} {{ $d(new Date(project.created_at), 'short') }}
            </p>
          </div>
        </div>
      </section>
      <section class="flex flex-row items-center">
        <div class="space-y-4">
          <h2 class="text-2xl">
            {{ $t('project_profile.security') }}
          </h2>
          <p class="text-lg">
            {{ $t('project_profile.tfa') }}
          </p>
        </div>
        <BaseButton class="ml-auto mt-auto text-white bg-gray-300"
                    :class="{ 'cursor-not-allowed': true }"
                    :disabled="true">
          {{ $t('project_profile.activate') }}
        </BaseButton>
      </section>
      <section class="flex flex-row items-center bg-red-100 border-red-500" v-if="project.role == 'owner'">
        <div class="space-y-4">
          <h2 class="text-2xl font-semibold text-red-500">
            {{ $t('project_profile.deactivate') }}
          </h2>
          <p class="text-lg">
            {{ $t('project_profile.deactivate_info') }}
          </p>
        </div>
        <BaseButton class="ml-auto mt-auto text-white border border-red-500 bg-red-500 hover:bg-red-600"
                    :is-loading="isDestroyProjectLoading"
                    @click="destroyProjectAndRedirect">
          {{ $t('project_profile.deactivate_please') }}
        </BaseButton>
      </section>
      <VuelidateError v-if="error">
        {{ $t(error) }}
      </VuelidateError>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  data () {
    return {
      error: null
    }
  },
  watch: {
    destroyProjectError (err) {
      this.error = err ? err.response.data.message : null
    }
  },
  computed: mapState('project', [
    'project',
    'isQueryProjectLoading',
    'queryProjectError',
    'isDestroyProjectLoading',
    'destroyProjectError'
  ]),
  methods: {
    ...mapActions({
      pollProject: 'project/pollProject',
      destroyProject: 'project/destroyProject'
    }),
    async showEditProjectModal () {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/EditProjectModal'))
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    },
    async destroyProjectAndRedirect () {
      await this.destroyProject({
        id: this.$route.params.projectId
      })
      this.$router.replace({ name: 'projects' })
    }
  },
  created () {
    this.pollProject({ id: this.$route.params.projectId })
  }
}
</script>
