<template>
  <div>
    <LoadingTab v-if="loading"/>
    <template v-else-if="error">{{ error.message }}</template>
    <template v-else>
      <div class="space-y-4">
        <div class="clearfix">
          <div class="float-left">
            <BaseSelect v-model="nodeId" :class="{ 'text-gray-500': mergedNodes.length === 0 }" :disabled="mergedNodes.length === 0">
              <option :value="null" v-if="mergedNodes.length === 0">
                {{ $t('logs_page.choose_node') }}
              </option>
              <option v-for="node in mergedNodes" :key="node.id" :value="node.id">
                {{ node.id.slice(0, 8) + (node.running ? ' - Active Log' : ' - History Log') }}
              </option>
            </BaseSelect>
          </div>
          <div class="float-right space-x-4">
            <BaseButton class="border border-gray-400 text-gray-800 disabled:opacity-75 disabled:text-gray-500"
                        :class="{ 'hover:bg-gray-100': mergedNodes.length > 0, 'cursor-not-allowed': mergedNodes.length === 0 }"
                        :disabled="mergedNodes.length === 0">
              {{ $t('logs_page.raw_log') }}
            </BaseButton>
            <BaseButton class="bg-red-500 text-white disabled:bg-red-400"
                        :class="{ 'hover:bg-red-600': mergedNodes.length > 0, 'cursor-not-allowed': mergedNodes.length === 0 }"
                        :disabled="mergedNodes.length === 0">
              {{ $t('logs_page.clear_log') }}
            </BaseButton>
          </div>
        </div>
        <div  class="bg-black py-2 px-4 rounded-sm overflow-x-auto text-white">
          <template v-if="byNodeId(nodeId).length">
            <pre v-for="log in byNodeId(nodeId)" :key="log.id" v-text="`${log.created_at} | ${log.data}`" />
          </template>
          <template v-else>
            <pre>{{ $t('logs_page.waiting') }}
            </pre>
          </template>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'

export default {
  data () {
    return {
      loading: false,
      error: null,
      nodeId: null,
      mergedNodes: []
    }
  },
  props: {
    channel: Object
  },
  computed: {
    ...mapState('logs', [
      'isQueryLogsLoading',
      'queryLogsError'
    ]),
    ...mapState('nodes', [
      'nodes'
    ]),
    ...mapGetters('logs', ['logs', 'byNodeId', 'nodesFromLogs'])
  },
  methods: mapActions({
    queryLogs: 'logs/queryLogs',
    addLog: 'logs/addLog',
    pollNodes: 'nodes/pollNodes'
  }),
  async created () {
    this.channel.bind('instance:logs', this.addLog)

    const { id, projectId } = this.$route.params

    const mergedNodes = x => {
      const node = this.nodes.find(z => z.id === x)
      return {
        id: node ? node.id : x,
        running: !!node
      }
    }
    const runningNodes = x => {
      return {
        id: x.id,
        running: true
      }
    }

    this._interval = setInterval(async () => {
      await this.pollNodes({ id, projectId })
      this.mergedNodes = this.nodesFromLogs.length > 0 ? this.nodesFromLogs.map(mergedNodes) : this.nodes.map(runningNodes)
    }, 30 * 1000)

    this.loading = true
    try {
      await Promise.all([
        this.queryLogs({ id, projectId }),
        this.pollNodes({ id, projectId })
      ])
      this.mergedNodes = this.nodesFromLogs.length > 0 ? this.nodesFromLogs.map(mergedNodes) : this.nodes.map(runningNodes)
      this.nodeId = (this.mergedNodes.length > 0 ? (this.nodes[0] ? this.nodes[0].id : this.nodesFromLogs[0]) : (this.nodesFromLogs[0] || null))
    } catch (err) {
      this.error = err
    } finally {
      this.loading = false
    }
  },
  beforeDestroy () {
    clearInterval(this._interval)
    this.channel.unbind('instance:logs', this.addLog)
  }
}
</script>
