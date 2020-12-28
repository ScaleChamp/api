<template>
    <div v-if="loading" key="user-page-loading" />
    <div class="w-full overflow-y-auto flex flex-col" id="user" v-else key="user-page">
      <header class="w-full bg-white border-b border-bottom">
        <div class="px-4 lg:px-8 mx-auto flex items-center">
          <router-link :to="{ name: 'projects' }">
            <Logo class="h-8 fill-current text-primary-100" />
          </router-link>
          <div class="ml-auto flex space-x-6 flex-row items-center">
            <div v-for="link in links" :key="link.id">
              <router-link
                :class="{ 'nav-active': $route.name === link.name }"
                class="font-semibold text-gray-800 hover:text-gray-700"
                :to="link"
                :exact="link.exact">
                {{ $t(link.name) }}
              </router-link>
            </div>
            <div class="relative">
              <div @click.prevent.stop="toggle" class="cursor-pointer py-5">
                <ProfileIcon class="fill-current h-6"/>
              </div>
              <FadeTransition>
                <span v-show="shown"
                      v-click-outside="hide"
                      class="absolute border box-border border-gray-400 top-full right-0 rounded-sm bg-white space-y-4 px-4 py-4 shadow">
                  <div @click="hide">
                    <router-link :to="{ name: 'profile' }">
                      <UserLink :user="user" />
                    </router-link>
                  </div>
                  <div v-for="link in dropdown" :key="link.id" @click="hide">
                    <router-link :to="link" class="block">
                      {{ $t(link.name) }}
                    </router-link>
                  </div>
                  <a href="/logout" class="block">
                    {{ $t('sign_out') }}
                  </a>
                </span>
              </FadeTransition>
            </div>
          </div>
        </div>
      </header>
      <div class="px-4 lg:px-8 flex-1">
        <router-view class="py-8 container mx-auto space-y-5 text-gray-800" />
      </div>
      <footer class="border-t border-gray-400 py-4 px-4 lg:px-8">
        <ul class="float-right flex justify-center items-center space-x-5 w-full">
          <li class="mr-auto text-gray-600">
            {{ $t('copyright_full') }}
          </li>
          <li>
            <a href="https://scalechamp.com/pricing" rel="noopener" target="_blank">{{ $t('footer.pricing')}}</a>
          </li>
          <li>
            <a class="cursor-not-allowed">{{ $t('footer.careers')}}</a>
          </li>
          <li>
            <a href="https://github.com/scalechamp/goss" rel="noopener" target="_blank">SDK</a>
          </li>
          <li>
            <a href="https://github.com/scalechamp" rel="noopener" target="_blank">{{ $t('footer.os')}}</a>
          </li>
          <li>
            <a href="https://status.scalechamp.com" rel="noopener" target="_blank">{{ $t('footer.status')}}</a>
          </li>
          <li>
            <a href="mailto:support@scalechamp.com">{{ $t('footer.help')}}</a>
          </li>
        </ul>
      </footer>
    </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import FadeTransition from '@/transitions/FadeTransition'
import { tabByRole } from '@/lib/tabrole'

export default {
  components: {
    FadeTransition
  },
  data () {
    return {
      loading: false,
      shown: false,
      links: [
        { name: 'projects', id: Math.random(), exact: true },
        { name: 'security-log', id: Math.random() }
      ],
      dropdown: [
        { name: 'profile', id: Math.random(), exact: true }
      ]
    }
  },
  computed: {
    ...mapState('sessions', ['user'])
  },
  methods: {
    ...mapActions('projects', ['queryProjects']),
    toggle () {
      this.shown = !this.shown
    },
    hide () {
      this.shown = false
    }
  },
  async created () {
    if (this.$route.query.invite || this.$route.query.page) {
      return
    }
    if (this.$route.name === 'projects' && [undefined, null, 'login', 'signup'].includes(this.$router.referer?.name)) {
      try {
        this.loading = true
        const { data: [project, ...otherProjects] } = await this.queryProjects()
        if (project && !otherProjects.length) {
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
}
</script>
