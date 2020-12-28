<template>
    <div id="project">
      <template v-if="queryProjectError">
        <div class="flex flex-col items-center justify-center w-full h-full space-y-5 ">
          <span class="pixel-sorting rounded-full h-64 w-64 inline-block circle-banner"/>
          <h2 class="text-2xl font-semibold">{{ queryProjectError.message }}</h2>
          <h2 class="text-lg">
            Try again later or email support <b>support@scalechamp.com</b>
          </h2>
          <h2 class="text-lg">
            Go back to
            <router-link :to="{ name: 'projects' }" class="text-primary">projects</router-link>
          </h2>
        </div>
      </template>
      <template v-else-if="!isQueryProjectLoading">
        <div class="flex flex-grow-0 h-full w-full">
          <aside class="bg-gray-900 text-white w-64 flex-shrink-0 overflow-y-auto h-full flex flex-col">
            <nav class="flex justify-center flex-col">
              <router-link :to="{ name: 'services' }" class="py-4 border-b border-grey-100 text-center">
                <Logo class="fill-current h-8 inline"/>
              </router-link>
              <ul class="w-full font-semibold">
                <li v-for="link in links" :key="link.name" class="w-full box-content">
                  <router-link
                    class="tracking-wide py-4 pl-10 text-gray-200 space-x-5 items-center hover:bg-gray-800 flex"
                    :to="link"
                    exact-active-class="nav-active">
                    <span>{{ $t(link.name) }}</span>
                  </router-link>
                </li>
              </ul>
            </nav>
            <div class="text-center py-4 text-gray-700 mt-auto border-t border-grey-100">
              {{ $t('copyright_short') }}
            </div>
          </aside>
          <main class="h-full w-full flex flex-col overflow-y-auto fixed">
            <div class="flex-1 px-4 lg:px-8 py-24">
              <router-view class="container mx-auto space-y-8" />
            </div>
            <header class="bg-white border-b border-bottom px-4 lg:px-8 flex items-center fixed">
              <h1 class="text-2xl">
                <router-link :to="{ name: 'projects' }">
                  {{ project.name }}
                  <svg class="inline h-2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 255 255">
                    <path d="M0 63.75l127.5 127.5L255 63.75z"/>
                  </svg>
                </router-link>
              </h1>
              <div class="ml-auto flex items-center space-x-5">
                <BaseButton :to="{ name: 'new-instance' }" v-if="ownerOrAdministrator" class="scale-90 transform bg-primary hover:bg-primary-100 text-white ml-auto flex items-center">{{ $t('create_service') }}</BaseButton>
                <router-link :to="{ name: 'billing' }" v-if="notMember">
                  {{ $t('project_billing.balance') }}
                  <br>
                  <b>{{ project.credit === 0 ? 0 : -project.credit | currency(2) }}</b>
                </router-link>
                <router-link :to="{ name: 'billing' }" v-if="notMember">
                  {{ $t('project_billing.usage') }}
                  <br>
                  <b>{{ project.usage | currency(2) }}</b>
                </router-link>
                <router-link :to="{ name: 'notifications' }" active-class="active">
                  <BellAlertIcon/>
                </router-link>
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
                      <div v-for="link in dropdown"
                           :key="link.id"
                           @click="hide">
                        <router-link class="capitalize block" :to="link">
                          {{ $t(link.name) }}
                        </router-link>
                      </div>
                      <a href="/logout" class="block">{{ $t('sign_out') }}</a>
                    </span>
                  </FadeTransition>
                </div>
              </div>
            </header>
            <footer class="border-t border-gray-400 py-4 clearfix px-4 lg:px-8">
              <ul class="float-right flex justify-center space-x-5">
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
          </main>
        </div>
      </template>
    </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import FadeTransition from '@/transitions/FadeTransition'

export default {
  components: {
    FadeTransition
  },
  data () {
    return {
      shown: false,
      dropdown: [
        { name: 'profile', id: Math.random() },
        { name: 'security-log', id: Math.random() }
      ]
    }
  },
  computed: {
    ...mapGetters('project', ['ownerOrAccountant', 'ownerOrAdministrator', 'notAccountant', 'notMember']),
    links () {
      return [
        { name: 'services', show: this.notAccountant },
        { name: 'members', show: this.ownerOrAdministrator },
        { name: 'api', show: this.ownerOrAdministrator },
        { name: 'vpc', show: this.ownerOrAdministrator },
        { name: 'connectors', show: this.ownerOrAdministrator },
        { name: 'project', show: this.ownerOrAdministrator },
        { name: 'support', show: true },
        { name: 'audit-log', show: this.ownerOrAdministrator },
        { name: 'billing', show: this.notMember }
      ].filter(link => link.show)
    },
    ...mapState('sessions', [
      'user'
    ]),
    ...mapState('projects', [
      'projects',
      'isQueryProjectsLoading',
      'queryProjectsError'
    ]),
    ...mapState('project', [
      'project',
      'isQueryProjectLoading',
      'queryProjectError'
    ])
  },
  methods: {
    ...mapActions('project', [
      'queryProject',
      'queryProjectDirectly'
    ]),
    toggle () {
      this.shown = !this.shown
    },
    hide () {
      this.shown = false
    }
  },
  created () {
    if (this.$router.referer?.name === 'projects') {
      this.queryProject({ id: this.$route.params.projectId })
    } else {
      this.queryProjectDirectly({ id: this.$route.params.projectId })
    }
  }
}
</script>
