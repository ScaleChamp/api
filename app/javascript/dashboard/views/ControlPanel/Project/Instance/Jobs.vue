<template>
    <div>
      <LoadingTab v-if="isQueryTasksLoading"/>
      <template v-else-if="queryTasksError">{{ queryTasksError.message }}</template>
      <template v-else>
        <BaseTable>
          <thead class="bg-gray-100">
            <tr>
              <th>{{ $t('actions.job') }}</th>
              <th>{{ $t('actions.status') }}</th>
              <th>{{ $t('actions.duration') }}</th>
              <th>{{ $t('actions.started') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="event in tasks" :key="event.id">
              <td>{{ $t(`actions.${event.action}`) }}</td>
              <td>{{ $t(`actions.state.${event.state}`) }}</td>
              <td>{{ event.updated_at ? duration(event, $i18n.locale) : $t('not_finished_yet')  }}</td>
              <td>{{ $d(new Date(event.created_at), 'long') }}</td>
            </tr>
          </tbody>
        </BaseTable>
      </template>
    </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import dayjs from '@/lib/dayjs'

export default {
  computed: mapState('tasks', [
    'isQueryTasksLoading',
    'queryTasksError',
    'tasks'
  ]),
  methods: {
    ...mapActions({
      queryTasks: 'tasks/queryTasks',
      pollTasks: 'tasks/pollTasks'
    }),
    duration (event, locale) {
      return dayjs.duration(dayjs(event.updated_at) - dayjs(event.created_at)).locale(locale).humanize()
    }
  },
  created () {
    const { id, projectId } = this.$route.params
    this._interval = setInterval(() => this.pollTasks({ id, projectId }), 10 * 1000)
    this.queryTasks({ id, projectId })
  },
  beforeDestroy () {
    clearInterval(this._interval)
  }
}
</script>
