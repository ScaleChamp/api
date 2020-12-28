<template>
  <div>
    <LoadingTab v-if="isQueryKeysLoading"/>
    <template v-else-if="queryKeysError">{{ queryKeysError.message }}</template>
    <template v-else-if="keys.length">
      <h1 class="text-4xl">{{ $t('api') }}</h1>
      <section class="flex items-center justify-between">
        <div class="text-xl long-and-truncated" :title="$t('api_keys.info')">{{ $t('api_keys.info') }}</div>
        <BaseButton class="bg-primary hover:bg-primary-100 text-white" @click.prevent="createAccessKeyAndAlert">{{ $t('api_keys.action') }}</BaseButton>
      </section>
      <BaseTable>
        <thead>
          <tr>
            <th>{{ $t('api_keys.name') }}</th>
            <th>{{ $t('api_keys.scope') }}</th>
            <th>{{ $t('api_keys.created') }}</th>
            <th class="w-40" />
          </tr>
        </thead>
        <tbody>
          <tr v-for="key in keys" :key="key.id">
            <td>
              <span class="text-primary cursor-pointer" v-text="key.name" @click="showUpdateModal(key)" />
            </td>
            <td>{{ $t(key.permission) }}</td>
            <td>{{ key.created_at | fromNow($i18n.locale) }}</td>
            <td>
              <span v-if="removingMap[key.id]" class="text-gray-400 cursor-not-allowed">
                {{ $t('api_keys.removing') }}
              </span>
              <span v-else
                    class="text-red-600 cursor-pointer"
                    @click.prevent="deleteAccessKeyAndShowLoading({ projectId: $route.params.projectId, id: key.id })">
                {{ $t('api_keys.remove') }}
              </span>
            </td>
          </tr>
        </tbody>
      </BaseTable>
    </template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('api') }}</h1>
      <div class="py-6 px-6 rounded-sm flex items-center justify-between pixel-sorting banner shadow-lg">
        <div class="text-xl text-white font-semibold long-and-truncated" :title="$t('api_keys.info')">{{ $t('api_keys.info') }}</div>
        <BaseButton class="bg-white text-black" @click.prevent="createAccessKeyAndAlert">{{ $t('api_keys.action') }}</BaseButton>
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
  methods: {
    ...mapActions({
      queryAccessKeys: 'keys/queryAccessKeys',
      deleteAccessKey: 'keys/deleteAccessKey'
    }),
    async deleteAccessKeyAndShowLoading (accessKey) {
      Vue.set(this.removingMap, accessKey.id, true)
      await this.deleteAccessKey(accessKey)
      Vue.delete(this.removingMap, accessKey.id)
    },
    async showUpdateModal (accessKey) {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/UpdateAccessKeyModal'), { accessKey })
      } finally {
        this.$modal.hide()
      }
    },
    async createAccessKeyAndAlert () {
      try {
        const secret = await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/CreateAccessKeyModal'))
        await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/ShowAccessKeyModal'), { secret })
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  computed: {
    ...mapState('keys', [
      'keys',
      'isQueryKeysLoading',
      'queryKeysError'
    ])
  },
  created () {
    const { projectId } = this.$route.params
    this.queryAccessKeys({ projectId })
  }
}
</script>
