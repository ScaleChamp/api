<template>
    <div>
      <LoadingTab v-if="isQueryNodesLoading"/>
      <template v-else-if="queryNodesError">{{ queryNodesError.message }}</template>
      <template v-else-if="nodes.length">
        <BaseTable>
          <thead>
            <tr>
              <th>{{ $t('nodes_page.id') }}</th>
              <th>{{ $t('nodes_page.status') }}</th>
              <th>{{ $t('nodes_page.role') }}</th>
              <th>{{ $t('nodes_page.created') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="node in nodes" :key="node.id">
              <td>{{ node.id.slice(0, 8) }}</td>
              <td>{{ $t(node.state) }}</td>
              <td>{{ $t(node.role) }}</td>
              <td>{{ node.created_at | fromNow($i18n.locale) }}</td>
            </tr>
          </tbody>
        </BaseTable>
      </template>
      <template v-else>
        <section class="text-center space-y-2 py-24">
          <span class="pixel-sorting rounded-full h-40 w-40 inline-block circle-banner" />
          <h3 class="text-2xl font-semibold">{{ $t('nodes_page.title') }}</h3>
          <p class="text-lg">{{ $t('nodes_page.info') }}</p>
        </section>
      </template>
    </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  computed: mapState('nodes', [
    'isQueryNodesLoading',
    'queryNodesError',
    'nodes'
  ]),
  methods: mapActions({
    queryNodes: 'nodes/queryNodes',
    pollNodes: 'nodes/pollNodes'
  }),
  created () {
    const { id, projectId } = this.$route.params
    this._interval = setInterval(() => this.pollNodes({ id, projectId }), 10 * 1000)
    this.queryNodes({ id, projectId })
  },
  beforeDestroy () {
    clearInterval(this._interval)
  }
}
</script>
