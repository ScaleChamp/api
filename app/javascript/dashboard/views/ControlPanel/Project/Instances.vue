<template>
  <div>
    <LoadingTab v-if="isQueryInstancesLoading"/>
    <template v-else-if="queryInstancesError">{{ queryInstancesError.message }}</template>
    <template v-else-if="instances.length">
      <h1 class="text-4xl">{{ $t('services') }}</h1>
      <BaseTable>
        <thead>
          <tr>
            <th>{{ $t('instances_page.name') }}</th>
            <th class="hidden lg:block">{{ $t('instances_page.state') }}</th>
            <th>{{ $t('instances_page.kind') }}</th>
            <th>{{ $t('instances_page.cloud') }}</th>
            <th>{{ $t('instances_page.region') }}</th>
            <th>{{ $t('instances_page.plan') }}</th>
            <th class="hidden lg:block">{{ $t('instances_page.created') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="instance in instances" :key="instance.id">
            <td class="text-primary">
              <router-link
                :to="{ name: 'settings', params: { id: instance.id } }"
                v-text="instance.name"
              />
            </td>
            <td class="capitalize hidden lg:block">{{ $t(instance.state) }}</td>
            <td>{{ $t(instance.kind) }}</td>
            <td>{{ $t(instance.plan.cloud) }}</td>
            <td>{{ instance.plan.region }}</td>
            <td>{{ instance.plan.name }}</td>
            <td class="hidden lg:block">{{ instance.created_at | fromNow($i18n.locale) }}</td>
          </tr>
        </tbody>
      </BaseTable>
    </template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('services') }}</h1>
      <div class="flex items-center justify-between shadow py-6 px-6 rounded-sm pixel-sorting banner">
        <div class="text-xl text-white font-semibold long-and-truncated" :title="$t('instances_page.info')">
          {{ $t('instances_page.info') }}
        </div>
        <BaseButton class="bg-white flex justify-center items-center"
                    :to="{ name: 'new-instance' }">
          {{ $t('create_service') }}
        </BaseButton>
      </div>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import { CancelToken } from 'axios'

export default {
  computed: mapState('instances', [
    'instances',
    'isQueryInstancesLoading',
    'queryInstancesError'
  ]),
  methods: {
    ...mapActions('instances', [
      'queryInstances',
      'pollInstances'
    ]),
    fetch () {
      this.source = CancelToken.source()
      return this.queryInstances({
        projectId: this.$route.params.projectId,
        page: this.$route.query.page || 1,
        cancelToken: this.source.token
      })
    },
    poll () {
      this.source = CancelToken.source()
      return this.pollInstances({
        projectId: this.$route.params.projectId,
        page: this.$route.query.page || 1,
        cancelToken: this.source.token
      })
    }
  },
  watch: {
    $route (to, from) {
      if (to.params.projectId !== from.params.projectId) {
        this.source.cancel()
        this.fetch()
      }
    }
  },
  async created () {
    await this.fetch()
    this._interval = setInterval(this.poll.bind(this), 30 * 1000)
  },
  beforeDestroy () {
    this.source.cancel()
    clearInterval(this._interval)
  }
}
</script>
