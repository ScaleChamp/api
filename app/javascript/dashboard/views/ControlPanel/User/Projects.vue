<template>
  <main>
    <LoadingTab v-if="loading" />
    <template v-else-if="queryProjectsError">{{ queryProjectsError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('projects') }}</h1>
      <section class="flex flex-row items-center">
        <p class="text-lg long-and-truncated pr-2">{{ $t('projects_info') }}</p>
        <BaseButton class="bg-primary hover:bg-primary-100 text-white ml-auto" @click="showModal">{{ $t('create_project') }}</BaseButton>
      </section>
      <div class="flex flex-row flex-wrap -mx-2">
        <div class="px-2 w-full md:w-1/2 lg:w-1/3" v-if="$route.query.invite && !loading && project">
          <div class="cursor-pointer h-56 mb-4 bg-primary rounded-sm overflow-hidden hover:bg-primary-100 illuminate"
               :title="$t('click_to_join')"
               @click="confirmAndRedirect">
            <div class="flex items-center justify-center">
              <h2 class="text-2xl text-white px-6 py-3 font-semibold">
                {{ project.name }}
              </h2>
              <Loading class="ml-auto text-white fill-current h-6 w-6 mr-6" />
            </div>
          </div>
        </div>
        <div class="px-2 w-full md:w-1/2 lg:w-1/3 mb-4" v-else>
          <div @click="showModal"
               class="cursor-pointer border-2 hover:border-gray-600 border-dashed h-56 flex items-center justify-center border-gray-500 hover:text-gray-600 text-gray-500">
            <h2 class="text-2xl font-semibold">
              {{ $t('create_project') }}
            </h2>
          </div>
        </div>
        <ProjectCard
          v-for="project in projects"
          :project="project"
          :key="project.id"
        />
      </div>
      <Pagination :links="links" :page="page" :name="'projects'" />
    </template>
  </main>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import parseLinkHeader from 'parse-link-header'
import { tabByRole } from '@/lib/tabrole'

export default {
  data () {
    return {
      loading: false,
      links: null,
      page: 1
    }
  },
  computed: {
    ...mapState('projects', [
      'projects',
      'isQueryProjectsLoading',
      'queryProjectsError'
    ]),
    ...mapState('sessions', [
      'user'
    ]),
    ...mapState('members', [
      'project'
    ])
  },
  methods: {
    ...mapActions('projects', [
      'pollProjects',
      'queryProjects'
    ]),
    ...mapActions('members', [
      'getProject'
    ]),
    async confirmAndRedirect () {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/AcceptInviteModal'), { name: this.project.name })
        this.$modal.hide()
        this.$router.replace({ name: tabByRole(this.project.role), params: { projectId: this.project.id } })
      } catch (err) {
        this.$modal.hide()
      }
    },
    async showModal () {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/CreateProjectModal'))
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  watch: {
    '$route.query.page': {
      async handler () {
        const { headers } = await this.pollProjects(this.$route.query)
        this.page = this.$route.query.page
        this.links = parseLinkHeader(headers.link)
      }
    }
  },
  async created () {
    try {
      this.loading = true
      if (this.$route.query.invite) {
        await this.getProject({ id: this.$route.query.invite })
      }
      const { data: [project, ...otherProjects], headers } = await this.queryProjects(this.$route.query)
      this.page = this.$route.query.page || 1
      this.links = parseLinkHeader(headers.link)

      if (!this.$route.query.invite &&
        project &&
        otherProjects.length === 0 &&
        (this.$route.query.page || 1) === 1 &&
        [undefined, null, 'login', 'signup'].includes(this.$router.referer?.name)) {
        this.$router.replace({
          name: tabByRole(project.role),
          params: {
            projectId: project.id
          }
        })
      }
    } finally {
      this.loading = false
    }
  }
}
</script>
