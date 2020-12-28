<template>
  <div>
    <LoadingTab v-if="isQueryAuditLogsLoading"/>
    <template v-else-if="queryAuditLogsError">{{ queryAuditLogsError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('audit_log') }}</h1>
      <BaseTable>
        <thead class="bg-gray-100">
          <tr>
            <th>{{ $t('audit_log_page.action') }}</th>
            <th>{{ $t('audit_log_page.source_ip') }}</th>
            <th>{{ $t('audit_log_page.user_email') }}</th>
            <th>{{ $t('audit_log_page.desc') }}</th>
            <th>{{ $t('audit_log_page.created') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="log in auditLogs" :key="log.id">
            <td>{{ log.action_type }}</td>
            <td>{{ log.remote_ip }}</td>
            <td>{{ log.user && log.user.email || $t('not_available') }}</td>
            <td>{{ log.data && log.data.name || $t('not_available') }}</td>
            <td>{{ $d(new Date(log.created_at), 'long') }}</td>
          </tr>
        </tbody>
      </BaseTable>
      <Pagination :links="links" :page="page"  name="audit-log" />
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import parseLinkHeader from 'parse-link-header'

export default {
  data () {
    return {
      links: null,
      page: 1
    }
  },
  methods: {
    ...mapActions({
      getAuditLogs: 'audit/getAuditLogs'
    })
  },
  computed: {
    ...mapState('audit', [
      'auditLogs',
      'isQueryAuditLogsLoading',
      'queryAuditLogsError'
    ])
  },
  watch: {
    '$route.query.page': {
      immediate: true,
      async handler () {
        const { headers } = await this.getAuditLogs(Object.assign({}, this.$route.query, {
          projectId: this.$route.params.projectId
        }))
        this.page = this.$route.query.page || 1
        this.links = parseLinkHeader(headers.link)
      }
    }
  }
}
</script>
