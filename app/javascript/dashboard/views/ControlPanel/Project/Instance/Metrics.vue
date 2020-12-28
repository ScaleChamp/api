<template>
  <div>
    <LoadingTab v-if="loading"/>
    <template v-else-if="queryMetricsError">
      {{ queryMetricsError.message }}
    </template>
    <template v-else>
      <div class="grid grid-cols-1 xl:grid-cols-2 gap-6 font-semibold">
        <component v-for="chart in charts"
                   :metrics="metrics"
                   :is="chart.default"
                   :key="chart.default.name"
        />
      </div>
    </template>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  data () {
    return {
      loading: false,
      charts: []
    }
  },
  computed: {
    ...mapState('metrics', [
      'isQueryMetricsLoading',
      'metrics',
      'queryMetricsError'
    ])
  },
  methods: mapActions({
    queryMetrics: 'metrics/queryMetrics',
    pollMetrics: 'metrics/pollMetrics'
  }),
  async created () {
    try {
      this.loading = true
      const charts = await Promise.all([
        import(/* webpackPrefetch: 8 */ './Metrics/CPU'),
        import(/* webpackPrefetch: 8 */ './Metrics/Disk'),
        import(/* webpackPrefetch: 8 */ './Metrics/Memory')
      ])
      this.charts = Object.freeze(charts)
      const { id, projectId } = this.$route.params
      this._interval = setInterval(() => this.pollMetrics({ id, projectId }), 35 * 1000)
      await this.queryMetrics({ id, projectId })
    } finally {
      this.loading = false
    }
  },
  beforeDestroy () {
    clearInterval(this._interval)
  }
}
</script>
