<template>
  <div>
    <LoadingTab v-if="loading"/>
    <template v-else-if="queryPeersError">{{ queryPeersError.message }}</template>
    <template v-else-if="queryNetworkError">{{ queryNetworkError.message }}</template>
    <template v-else-if="peers.length">
      <h1 class="text-4xl">{{ $t('peers') }} ({{ network.cloud }}-{{ network.region }})</h1>
      <section class="flex items-center justify-between">
        <div class="text-xl long-and-truncated" :title="$t('peers_page.info')">{{ $t('peers_page.info') }}</div>
        <BaseButton class="bg-primary hover:bg-primary-100 text-white" @click.prevent="createPeerAndAlert">{{ $t('peers_page.action') }}</BaseButton>
      </section>
      <BaseTable>
        <thead>
          <tr>
            <th>{{ $t('peers_page.aws_account_id') }}</th>
            <th>{{ $t('peers_page.aws_vpc_id') }}</th>
            <th>{{ $t('peers_page.aws_vpc_region') }}</th>
            <th>{{ $t('peers_page.state') }}</th>
            <th>{{ $t('peers_page.created') }}</th>
            <th class="w-40" />
          </tr>
        </thead>
        <tbody>
          <tr v-for="peer in peers" :key="peer.id">
            <td>{{ peer.aws_peer_owner_id }}</td>
            <td>{{ peer.aws_peer_vpc_id }}</td>
            <td>{{ peer.aws_peer_region }}</td>
            <td>{{ peer.state }}</td>
            <td>{{ peer.created_at | fromNow($i18n.locale) }}</td>
            <td>
                <span v-if="removingMap[peer.id]" class="text-gray-400 cursor-not-allowed">
                  {{ $t('peers_page.removing') }}
                </span>
                <span v-else
                    class="text-red-600 cursor-pointer"
                    @click.prevent="deletePeerAndShowLoading({ projectId: $route.params.projectId, networkId: peer.virtual_network_id, id: peer.id })">
                  {{ $t('peers_page.remove') }}
                </span>
            </td>
          </tr>
        </tbody>
      </BaseTable>
    </template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('peers') }} ({{ network.cloud }}-{{ network.region }})</h1>
      <div class="flex items-center justify-between shadow py-6 px-6 rounded-sm pixel-sorting banner">
        <div class="text-xl text-white font-semibold">{{ $t('peers_page.info') }}</div>
        <BaseButton class="bg-white flex justify-center items-center" @click.prevent="createPeerAndAlert">{{ $t('peers_page.action') }}</BaseButton>
      </div>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import Vue from 'vue'

export default {
  data () {
    return {
      removingMap: {},
      loading: false,
    }
  },
  computed: {
    ...mapState('peers', [
      'peers',
      'queryPeersError',
      'isQueryPeersLoading'
    ]),
    ...mapState('vpcs', [
      'vpcs',
    ]),
    ...mapState('network', [
      'network',
      'queryNetworkError',
      'isQueryNetworkLoading'
    ])
  },
  methods: {
    ...mapActions({
      queryPeers: 'peers/queryPeers',
      pollPeers: 'peers/pollPeers',
      deletePeer: 'peers/deletePeer',
      queryVPCs: 'vpcs/queryVPCs',
      queryNetwork: 'network/queryNetwork',
    }),
    async deletePeerAndShowLoading (params) {
      Vue.set(this.removingMap, params.id, true)
      await this.deletePeer(params)
      Vue.delete(this.removingMap, params.id)
    },
    async createPeerAndAlert () {
      try {
        if (this.network.cloud == "aws") {
            await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/CreateAWSPeerModal'))
        }
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  async created () {
    try {
      this.loading = true
      const { projectId, id } = this.$route.params
      await Promise.all([
        this.queryNetwork({ projectId, id }),
        this.queryPeers({ projectId, networkId: id })
      ])
      this._interval = setInterval(() => this.pollPeers({ projectId, networkId: id }), 15 * 1000)
    } finally {
      this.loading = false
    }
  },
  beforeDestroy () {
    clearInterval(this._interval)
  }
}
</script>
