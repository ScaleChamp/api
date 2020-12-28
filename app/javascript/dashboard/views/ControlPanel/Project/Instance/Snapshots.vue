<template>
  <div>
    <LoadingTab v-if="isQuerySnapshotsLoading"/>
    <template v-else-if="querySnapshotsError">{{ querySnapshotsError.message }}</template>
    <template v-else-if="snapshots.length" >
      <BaseTable>
        <thead>
          <tr>
            <th>{{ $t('instance_snapshots.created') }}</th>
            <th>{{ $t('instance_snapshots.size') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="snapshot in snapshots" :key="snapshot.last_modified">
            <td>{{ snapshot.last_modified | fromNow($i18n.locale) }}</td>
            <td>{{ snapshot.size | readableBytes }}</td>
          </tr>
        </tbody>
      </BaseTable>
    </template>
    <template v-else>
      <section class="text-center space-y-2 py-24">
        <span class="pixel-sorting rounded-full h-40 w-40 inline-block circle-banner" />
        <h3 class="text-2xl font-semibold">{{ $t('instance_snapshots.title') }}</h3>
        <p class="text-lg">{{ $t('instance_snapshots.info') }}</p>
      </section>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  computed: mapState('snapshots', [
    'snapshots',
    'querySnapshotsError',
    'isQuerySnapshotsLoading'
  ]),
  methods: mapActions({
    querySnapshots: 'snapshots/querySnapshots'
  }),
  created () {
    const { id, projectId } = this.$route.params
    this.querySnapshots({ id, projectId })
  }
}
</script>
