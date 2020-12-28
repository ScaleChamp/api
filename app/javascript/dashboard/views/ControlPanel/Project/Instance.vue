<template>
  <div id="instance">
    <LoadingTab v-if="isQueryInstanceLoading"/>
    <template v-else-if="queryInstanceError">
      <h1 class="text-4xl">Hmm... It is unexpected</h1>
      <div class="text-center space-y-2 py-24">
        <span
          class="pixel-sorting rounded-full h-40 w-40 inline-block circle-banner"
        />
        <h2 class="text-2xl font-semibold">{{ queryInstanceError.message }}</h2>
        <p class="text-lg">
          Try again later or <router-link :to="{ name: 'support' }" class="text-primary">contact support</router-link>
        </p>
      </div>
    </template>
    <template v-else>
        <div class="flex items-center w-full">
          <div class="p-3 rounded-full border-2 border-primary bg-opacity-75 fill-current text-primary relative">
              <span class="absolute w-5 h-4 rounded-full bg-white flex items-center justify-center bottom-0 right-0">
                <span class="absolute w-2 h-2 rounded-circle" :class="stateColors" />
              </span>
              <SingleNodeCluster v-if="instance.plan.nodes < 2" />
              <MultiNodeCluster v-else />
          </div>
          <div class="px-4">
            <h1 class="text-4xl leading-none mb-2">
              <span class="relative">
                {{ instance.name }}
              </span>
            </h1>
            <p class="leading-none text-gray-600 text-base long-and-truncated">
              <span>{{ $t(instance.kind) }} {{ instance.plan.version }}</span> /
              <span>{{ instance.plan.name }}</span> /
              <span>{{ $t(instance.plan.cloud) }}</span> /
              <span>{{ instance.plan.region }}</span> /
              <span>{{ instance.plan.vcpus }} vCPU</span> /
              <span>{{ instance.plan.memory | readableBytes }} RAM</span> /
              <span>{{ instance.plan.disk }} GB HDD</span> /
              <span>{{ $tc('nodes_c', instance.plan.nodes) }}</span> /
              <span class="text-sm px-2 font-semibold text-sm rounded-sm text-white uppercase" :class="stateColors">
                {{ $t(instance.state) }}
              </span>
            </p>
          </div>
        </div>
        <ul class="flex flex-row space-x-6 font-semibold border-b-2 border-gray-300 text-gray-600 text-md capitalize">
          <li
            v-for="link in links"
            class="block whitespace-no-wrap"
            :class="link.class"
            style="margin-bottom: -2px"
            :key="link.name">
            <router-link :to="link.name" class="block py-2" active-class="active" :exact="link.exact">
              {{ $t(link.name) }}
            </router-link>
          </li>
        </ul>
        <router-view :channel="_channel" />
    </template>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex'

export default {
  computed: {
    stateColors () {
      return {
        'hide-and-show': this.instance.state === 'pending',
        'bg-gray-500': ![ 'unhealthy', 'running'].includes(this.instance.state),
        'bg-green-400': this.instance.state === 'running',
        'bg-red-400': this.instance.state === 'unhealthy'
      }
    },
    links () {
      return [
        {
          name: 'settings',
          exact: true
        },
        { name: 'snapshots' },
        {
          name: 'firewall',
          exact: true,
          hide: this.instance.whitelist.length === 0 && !this.ownerOrAdministrator
        },
        { name: 'metrics', exact: true },
        { name: 'log', exact: true },
        { name: 'nodes', exact: true },
        { name: 'jobs', exact: true }
      ].filter(link => !link.hide)
    },
    ...mapGetters('project', ['ownerOrAdministrator']),
    ...mapState('instance', [
      'isQueryInstanceLoading',
      'queryInstanceError',
      'instance'
    ]),
    ...mapState('sessions', [
      'user'
    ])
  },
  methods: mapActions({
    queryInstance: 'instance/queryInstance',
    queryInstanceDirectly: 'instance/queryInstanceDirectly',
    pollInstance: 'instance/pollInstance',
    updateState: 'instance/updateState'
  }),
  created () {
    const { id, projectId } = this.$route.params
    this._channel = this.$pusher.subscribe(`private-instance-${id}`)
    this._channel.bind('instance:initialized', this.updateState)
    this._interval = setInterval(() => this.pollInstance({ id, projectId }), 60 * 1000)
    if (this.$router.referer.name === 'services') {
      this.queryInstance({ id, projectId })
    } else {
      this.queryInstanceDirectly({ id, projectId })
    }
  },
  beforeDestroy () {
    clearInterval(this._interval)
    this._channel.unbind('instance:initialized', this.updateState)
    this._channel.unsubscribe()
  }
}
</script>
