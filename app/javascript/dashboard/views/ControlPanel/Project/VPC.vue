<template>
  <div>
    <template v-if="true">
      <h1 class="text-4xl">{{ $t('project_vpc') }}</h1>
      <div class="flex items-center justify-between shadow py-6 px-6 rounded-sm pixel-sorting banner">
        <div class="text-xl text-white font-semibold">{{ $t('vpc_comming_soon') }}</div>
        <BaseButton class="bg-white flex justify-center items-center" :to="{ name: 'new-instance' }">{{ $t('notification_placeholder') }}</BaseButton>
      </div>
    </template>
    <LoadingTab v-else-if="isQueryNetworksLoading"/>
    <template v-else-if="queryNetworksError">{{ queryNetworksError.message }}</template>
    <template v-else-if="networks.length">
      <h1 class="text-4xl">{{ $t('project_vpc') }}</h1>
      <section class="flex items-center justify-between">
        <div class="text-xl long-and-truncated" :title="$t('vpc_page.info')">{{ $t('vpc_page.info') }}</div>
        <BaseButton class="bg-primary hover:bg-primary-100 text-white" @click.prevent="createNetworkAndAlert">{{ $t('vpc_page.action') }}</BaseButton>
      </section>
      <BaseTable>
        <thead>
          <tr>
            <th>{{ $t('vpc_page.cloud') }}</th>
            <th>{{ $t('vpc_page.network') }}</th>
            <th>{{ $t('vpc_page.state') }}</th>
            <th>{{ $t('vpc_page.created') }}</th>
            <th class="w-40" />
          </tr>
        </thead>
        <tbody>
          <tr v-for="network in networks" :key="network.id">
            <td><router-link class="text-primary cursor-pointer" :to="{ name: 'peers', params: { id: network.id } }">{{ network.cloud }}-{{ network.region }}</router-link></td>
            <td>{{ network.network }}</td>
            <td>{{ network.state }}</td>
            <td>{{ network.created_at | fromNow($i18n.locale) }}</td>
            <td>
                <span v-if="removingMap[network.id]" class="text-gray-400 cursor-not-allowed">
                  {{ $t('vpc_page.removing') }}
                </span>
                <span v-else
                    class="text-red-600 cursor-pointer"
                    @click.prevent="deleteNetworkAndShowLoading({ projectId: $route.params.projectId, id: network.id })">
                  {{ $t('vpc_page.remove') }}
                </span>
            </td>
          </tr>
        </tbody>
      </BaseTable>
    </template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('project_vpc') }}</h1>
      <div class="flex items-center justify-between shadow py-6 px-6 rounded-sm pixel-sorting banner">
        <div class="text-xl text-white font-semibold">{{ $t('vpc_page.info') }}</div>
        <BaseButton class="bg-white flex justify-center items-center" @click.prevent="createNetworkAndAlert">{{ $t('vpc_page.action') }}</BaseButton>
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
      removingMap: {}
    }
  },
  computed: {
    ...mapState('vpcs', [
      'vpcs'
    ]),
    ...mapState('networks', [
      'networks',
      'queryNetworksError',
      'isQueryNetworksLoading'
    ])
  },
  methods: {
    ...mapActions({
      queryNetworks: 'networks/queryNetworks',
      pollNetworks: 'networks/pollNetworks',
      deleteNetwork: 'networks/deleteNetwork',
      queryVPCs: 'vpcs/queryVPCs',
    }),
    async deleteNetworkAndShowLoading (params) {
      Vue.set(this.removingMap, params.id, true)
      await this.deleteNetwork(params)
      Vue.delete(this.removingMap, params.id)
    },
    async createNetworkAndAlert () {
      try {
        if (this.vpcs.length == 0) {
          await this.queryVPCs()
        }
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/CreateNetworkModal'))
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  async created () {
    const { projectId } = this.$route.params
    await this.queryNetworks({ projectId })
    this._interval = setInterval(() => this.pollNetworks({ projectId }), 15 * 1000)
  },
  beforeDestroy () {
    clearInterval(this._interval)
  }
}
</script>
