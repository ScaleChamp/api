<template>
  <div class="space-y-8">
    <div class="space-y-4">
      <BaseTable>
        <thead class="bg-gray-100">
          <tr>
            <th>{{ $t('instance_settings_page.connection_info') }}</th>
            <th>{{ $t('instance_settings_page.value') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>{{ $t('instance_settings_page.cloud') }}</td>
            <td class="font-semibold">{{ $t(instance.plan.cloud) }}</td>
          </tr>
          <tr>
            <td>{{ $t('instance_settings_page.region') }}</td>
            <td class="font-semibold">{{ $t(instance.plan.location) }}, {{ $t(instance.plan.region) }}</td>
          </tr>
          <tr>
            <td>{{ $t('instance_settings_page.master_host') }}</td>
            <td class="font-semibold">{{ instance.connection_info.master_host }}</td>
          </tr>
          <tr v-if="instance.connection_info.replica_host">
            <td>{{ $t('instance_settings_page.replica_host') }}</td>
            <td class="font-semibold">{{ instance.connection_info.replica_host }}</td>
          </tr>
          <tr>
            <td>{{ $t('instance_settings_page.port') }}</td>
            <td class="font-semibold">{{ instance.port }}</td>
          </tr>
          <tr v-if="!['redis', 'keydb'].includes(instance.kind)">
            <td>{{ $t('instance_settings_page.username') }}</td>
            <td class="font-semibold">ssnuser</td>
          </tr>
          <tr>
            <td>{{ $t('instance_settings_page.password') }}</td>
            <td class="font-semibold">
              {{ revealPassword ? instance.password : '' }}
              <a v-if="!revealPassword"
                 @click.prevent="showPassword"
                 href
                 class="text-primary">
                {{ $t('instance_settings_page.show_password') }}
              </a>
              <a v-else
                 @click.prevent="hidePassword"
                 href
                 class="text-primary">
                {{ $t('instance_settings_page.hide') }}
              </a>
            </td>
          </tr>
          <tr v-if="!['redis', 'keydb'].includes(instance.kind)">
            <td>{{ $t('instance_settings_page.database') }}</td>
            <td class="font-semibold">ssndb</td>
          </tr>
          <tr>
            <td>URL</td>
            <td class="font-semibold">
              <a @click.prevent="copy" href class="inline text-primary">
                <input type="hidden" ref="url" :value="instance.master_url">{{ copied ? $t('instance_settings_page.copied') : $t('instance_settings_page.copy_url') }}
              </a>
            </td>
          </tr>
          <tr v-if="['pg', 'mysql'].includes(instance.kind)">
            <td>CA</td>
            <td class="font-semibold">
              <a @click.prevent="exportCA" class="inline text-primary" href>{{ $t('instance_settings_page.export_ca') }}</a>
            </td>
          </tr>
        </tbody>
      </BaseTable>
      <section class="flex justify-between items-end" v-if="ownerOrAdministrator">
        <div class="space-y-4">
          <h2 class="text-2xl font-semibold">{{ $t('instance_settings_page.change_plan') }}</h2>
          <i18n tag="p" path="instance_settings_page.current_plan_is" class="text-lg">
            <template #plan>
              <b>{{ instance.plan.name }}</b>
            </template>
            <template #price>
              <b>{{ instance.plan.price | currency(3) }}</b>
            </template>
          </i18n>
        </div>
        <BaseButton tag="button"
                    :to="{ name: 'edit-instance' }"
                    class="text-white bg-primary"
                    :class="buttonDisabledClassNotToSuspend"
                    :disabled="instance.state != 'running' || isQueryEditPasswordLoading">
          {{ $t('instance_settings_page.change') }}
        </BaseButton>
      </section>
      <section class="space-y-4 border" v-if="ownerOrAdministrator && ['redis', 'keydb', 'keydb-pro'].includes(instance.kind)">
        <h2 class="text-2xl font-semibold">{{ $t('instance_settings_page.eviction_policy') }}</h2>
        <div class="flex justify-between">
          <p class="text-lg">
            {{ $t('instance_settings_page.eviction_policy_info') }}
          </p>
          <div class="w-1/4">
            <BaseSelect :value="instance.eviction_policy"
                        :disabled="!['running', 'disabled'].includes(instance.state) || isUpgradeInstanceLoading"
                        @change="updateInstanceEvictionPolicy">
              <option v-for="policy in ['noeviction', 'allkeys-lru', 'volatile-lru', 'allkeys-random', 'volatile-random', 'volatile-ttl']"
                      :key="policy"
                      :value="policy">
                {{ policy }}
              </option>
            </BaseSelect>
          </div>
        </div>
      </section>
      <section class="space-y-4" v-if="ownerOrAdministrator">
        <h2 class="text-2xl font-semibold">{{ $t('instance_settings_page.update_pass') }}</h2>
        <p class="text-lg">{{ $t('instance_settings_page.pass_info') }}</p>
        <form class="flex justify-between items-center space-x-10"
              @submit.prevent="changePassword">
          <BaseInput v-model="password"
                     type="password"
                     :class="buttonDisabledClassNotToSuspend"
                     :placeholder="$t('type_pass_here')"
                     :danger="$v.password.$error"
                     :disabled="instance.state != 'running'"
                     autocomplete="new-password"
          />
          <BaseButton :disabled="instance.state != 'running' || isQueryEditPasswordLoading"
                      :class="buttonDisabledClassNotToSuspend"
                      @blur="$v.password.$reset()"
                      class="bg-primary text-white">
            {{ $t('apply') }}
          </BaseButton>
        </form>
        <VuelidateError v-if="$v.password.$error">
          <template v-if="!$v.password.required">{{ $t('instance_password.required') }}</template>
          <template v-if="!$v.password.minLength">{{ $t('instance_password.minLength') }}</template>
          <template v-if="!$v.password.maxLength">{{ $t('instance_password.maxLength') }}</template>
          <template v-if="!$v.password.alphaNum">{{ $t('instance_password.alphaNum') }}</template>
        </VuelidateError>
      </section>
      <section class="space-y-4 border" v-if="ownerOrAdministrator">
        <h2 class="text-2xl font-semibold">{{ $t('instance_settings_page.suspend') }}</h2>
        <div class="flex justify-between">
          <p class="text-lg">
            {{ $t('instance_settings_page.suspend_info') }}
          </p>
          <BaseButton :class="buttonDisabledClass"
                      :disabled="!['running', 'disabled'].includes(instance.state)"
                      class="bg-primary text-white"
                      @click="upgradeInstance({ id: instance.id, projectId: instance.project_id, enabled: !instance.enabled })">
            {{ instance.enabled ? $t('instance_settings_page.suspend_action') : $t('instance_settings_page.poweron_action') }}
          </BaseButton>
        </div>
      </section>
      <section class="space-y-4 border border-red-500 bg-red-100" v-if="ownerOrAdministrator">
        <h2 class="text-2xl font-semibold text-red-600">{{ $t('instance_settings_page.destruction') }}</h2>
        <div class="flex justify-between">
          <p class="text-lg">
            {{ $t('instance_settings_page.destruction_info') }}
          </p>
          <BaseButton class="border border-red-400 text-white bg-red-500"
                      :class="buttonDisabledClass"
                      :disabled="!['running', 'created', 'disabled'].includes(instance.state) || isQueryEditPasswordLoading"
                      :is-loading="isDestroyInstanceLoading"
                      @click="destroyInstanceAndRedirect">
            {{ $t('instance_settings_page.destruction_action') }}
          </BaseButton>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapState } from 'vuex'
import { minLength, required, maxLength, alphaNum } from 'vuelidate/lib/validators'

export default {
  data () {
    return {
      copied: false,
      password: '',
      revealPassword: false
    }
  },
  validations: {
    password: {
      required,
      alphaNum,
      minLength: minLength(24),
      maxLength: maxLength(32)
    }
  },
  computed: {
    ...mapGetters('project', ['ownerOrAdministrator']),
    ...mapState('instance', [
      'instance',
      'isDestroyInstanceLoading',
      'isQueryEditPasswordLoading',
      'isUpgradeInstanceLoading',
      'queryEditPasswordError'
    ]),
    ...mapState('project', [
      'project'
    ]),
    buttonDisabledClassNotToSuspend () {
      return {
        'cursor-not-allowed': ['terminated', 'unhealthy', 'disabled'].includes(this.instance.state),
        'cursor-wait': ['pending'].includes(this.instance.state)
      }
    },
    buttonDisabledClass () {
      return {
        'cursor-not-allowed': ['terminated', 'unhealthy'].includes(this.instance.state),
        'cursor-wait': ['pending'].includes(this.instance.state)
      }
    }
  },
  methods: {
    ...mapActions({
      destroyInstance: 'instance/destroyInstance',
      upgradeInstance: 'instance/upgradeInstance',
      editPassword: 'instance/editPassword'
    }),
    exportCA () {
      const blob = new Blob([this.project.certificate_authority.crt], { type: 'text/plain' })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.download = `project-${this.project.id}-ca.pem`
      a.href = url
      a.textContent = ''
      a.click()
      a.remove()
    },
    updateInstanceEvictionPolicy (event) {
      const { projectId, id } = this.$route.params
      this.upgradeInstance({
        eviction_policy: event.target.value,
        id,
        projectId
      })
    },
    async destroyInstanceAndRedirect () {
      await this.destroyInstance({
        id: this.instance.id,
        projectId: this.instance.project_id
      })
      this.$router.replace({ name: 'services', params: { projectId: this.$route.params.projectId } })
    },
    async changePassword () {
      this.$v.password.$touch()
      if (this.$v.password.$error) {
        return
      }
      try {
        await this.editPassword({
          id: this.instance.id,
          projectId: this.instance.project_id,
          password: this.password
        })
      } finally {
        this.password = ''
      }
    },
    showPassword () {
      this.revealPassword = true
    },
    hidePassword () {
      this.revealPassword = false
    },
    copy () {
      try {
        this.$refs.url.setAttribute('type', 'text')
        this.$refs.url.select()
        document.execCommand('copy')
        this.$refs.url.setAttribute('type', 'hidden')
        window.getSelection().removeAllRanges()
        this.copied = true
        setTimeout(() => {
          this.copied = false
        }, 200)
      } catch {
        alert('Oops, unable to copy')
      }
    }
  }
}
</script>
