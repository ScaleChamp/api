<template>
  <div>
    <LoadingTab v-if="isQuerySecurityLogsLoading"/>
    <template v-else-if="querySecurityLogsError">{{ querySecurityLogsError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('security_logs') }}</h1>
      <section class="flex flex-row items-center">
        <i18n tag="p" path="export_security_logs" class="text-lg">
          <template #json>
            <b>JSON</b>
          </template>
        </i18n>
        <BaseButton class="bg-primary hover:bg-primary-100 text-white ml-auto"
                    @click="exportSecurityLog">
          {{ $t('security_logs_export') }}
        </BaseButton>
      </section>
      <BaseTable>
        <thead class="bg-gray-100">
        <tr>
          <th>{{ $t('security_logs_action') }}</th>
          <th>{{ $t('security_logs_ip') }}</th>
          <th>{{ $t('security_logs_desc') }}</th>
          <th>{{ $t('security_logs_created') }}</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="log in securityLogs" :key="log.id">
          <td>{{ log.action_type }}</td>
          <td>{{ log.remote_ip }}</td>
          <td>{{ log.data && log.data.name || $t('not_available') }}</td>
          <td>{{ $d(new Date(log.created_at), 'long') }}</td>
        </tr>
        </tbody>
      </BaseTable>
      <Pagination :links="links" :page="page" name="security-log" />
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
  computed: mapState('security', [
    'securityLogs',
    'isQuerySecurityLogsLoading',
    'querySecurityLogsError'
  ]),
  methods: {
    ...mapActions({
      querySecurityLogs: 'security/querySecurityLogs',
      pollSecurityLogs: 'security/pollSecurityLogs'
    }),
    exportSecurityLog () {
      const json = JSON.stringify(this.securityLogs)
      const blob = new Blob([json], { type: 'application/json' })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.download = 'security-log.json'
      a.href = url
      a.textContent = ''
      a.click()
      a.remove()
    }
  },
  watch: {
    '$route.query.page': {
      async handler () {
        const { headers } = await this.pollSecurityLogs(this.$route.query)
        this.page = this.$route.query.page
        this.links = parseLinkHeader(headers.link)
      }
    }
  },
  async created () {
    const { headers } = await this.querySecurityLogs(this.$route.query)
    this.page = this.$route.query.page || 1
    this.links = parseLinkHeader(headers.link)
  }
}
</script>
