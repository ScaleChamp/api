<template>
  <div id="user-profile">
    <template v-if="loading"><LoadingTab/></template>
    <template v-else-if="profileError">{{ profileError.message }}</template>
    <template v-else>
      <h1 class="capitalize text-4xl tracking-wide">{{ $t('profile') }}</h1>
      <section class="flex items-center justify-between items-stretch space-x-5">
        <div class="min-h-full">
          <img :src="user.avatar_url"
               class="h-full w-full rounded-full"
               alt="User Avatar"
          />
        </div>
        <div class="flex-1 min-h-full flex justify-center flex-col text-lg">
          <p class="font-semibold capitalize">{{ user.name }}</p>
          <p class="text-lg">{{ user.email }}</p>
          <p class="capitalize">{{ user.auth_method }}</p>
          <p>{{ user.tfa ? $t('tfa_enabled') : $t('tfa_disabled') }}</p>
        </div>
        <div class="flex flex-col justify-between text-right">
          <div>
            <BaseButton class="border border-gray-500 hover:bg-gray-500 text-gray-600 hover:text-white"
                        @click="editProfile">
              {{ $t('edit_profile') }}
            </BaseButton>
          </div>
          <div>
            <p class="font-semibold text-gray-500">
              {{ $t('instance_created') }}
              {{ $d(new Date(user.created_at), 'short') }}
            </p>
          </div>
        </div>
      </section>
      <section class="flex">
        <div class="space-y-4">
          <h2>{{ $t('login_method') }}</h2>
          <i18n tag="p" path="user_profile.info" class="text-lg">
            <template #method>
              <b class="capitalize">{{ user.auth_method }}</b>
            </template>
          </i18n>
        </div>
        <div class="ml-auto">
          <BaseButton class="border border-gray-500 hover:bg-gray-500 text-gray-600 hover:text-white"
                      @click="changeAuthMethod">
            {{ $t('change') }}
          </BaseButton>
        </div>
      </section>
      <section class="space-y-4 flex justify-between">
        <div class="space-y-4">
          <h2>{{ $t('localization') }}</h2>
          <p class="text-lg">{{ $t('about_localization')}}</p>
        </div>
        <div class="mt-auto flex items-center">
          <div class="flex items-center">
            <BaseSelect v-model="$i18n.locale" class="border-none">
              <option v-for="lang in langs" :key="lang" :value="lang">{{ $t(lang) }}</option>
            </BaseSelect>
          </div>
        </div>
      </section>

      <section v-if="user.auth_method === 'email'" class="flex flex-row items-center">
        <div class="space-y-4">
          <h2>{{ $t('user_profile.tfa') }}</h2>
          <p class="text-lg" v-if="user.tfa">{{ $t('user_profile.tfa_disable') }}</p>
          <p class="text-lg" v-else>{{ $t('user_profile.tfa_enable') }}</p>
        </div>
        <BaseButton
          v-if="user.tfa"
          :is-loading="isConfirmOtpLoading"
          class="ml-auto bg-primary hover:bg-primary-100 text-white"
          @click="disableOtp">
          {{ $t('user_profile.disable_tfa') }}
        </BaseButton>
        <BaseButton
          v-else
          class="ml-auto mt-auto bg-primary hover:bg-primary-100 text-white"
          :is-loading="enableOtpLoading"
          @click="enableTfa">
          {{ $t('user_profile.enable_tfa') }}
        </BaseButton>
      </section>

      <section class="flex flex-row items-center bg-red-100 border-red-500">
        <div class="space-y-4">
          <h2 class="font-semibold text-red-500">{{ $t('user_profile.deactivate_account') }}</h2>
          <p class="text-lg">{{ $t('user_profile.deactivate_account_info') }}</p>
        </div>
        <BaseButton
          class="ml-auto mt-auto text-white border border-red-500 bg-red-500 hover:bg-red-600"
          :is-loading="isDestroyProfileLoading"
          @click="destroyProfileAndRedirect">
          {{ $t('user_profile.deactivate') }}
        </BaseButton>
      </section>
      <VuelidateError v-if="error">
        {{ $t(error) }}
      </VuelidateError>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import * as OtpClient from '@/resources/otp'

export default {
  data () {
    return {
      loading: false,
      langs: ['ru', 'en', 'uk'],
      error: null,
      enableOtpLoading: false
    }
  },
  computed: {
    ...mapState('sessions', [
      'user',
      'isDestroyProfileLoading',
      'destroyProfileError',
      'profileError',
      'isConfirmOtpLoading'
    ])
  },
  watch: {
    destroyProfileError (err) {
      this.error = err ? err.response.data.message : null
    }
  },
  methods: {
    ...mapActions({
      queryProfile: 'sessions/queryProfile',
      destroyProfile: 'sessions/destroyProfile',
      disableOtp: 'sessions/disableOtp'
    }),
    async destroyProfileAndRedirect () {
      await this.destroyProfile(this.user)
      this.$router.replace({ name: 'login' })
    },
    async changeAuthMethod () {
      try {
        const result = await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/SelectLoginMethodModal'))
        switch (result) {
          case 'github':
            await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/ChangeOAuthMethodModal'), {
              ...this.$t('change_auth_method_modal.github'),
              link: '/logins/github'
            })
            break
          case 'google':
            await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/ChangeOAuthMethodModal'), {
              ...this.$t('change_auth_method_modal.google'),
              link: '/logins/google'
            })
            break
          default:
            await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/ConfirmEmailUpdateModal'))
            await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/EmailUpdateModal'))
        }
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    },
    async enableTfa () {
      try {
        this.enableOtpLoading = true
        const response = await OtpClient.enableOtp()
        this.enableOtpLoading = false
        const codes = await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/ConfirmTfaModal'), {
          response
        })
        await this.$modal.show(() => import(/* webpackPrefetch: 9 */ '@/modals/ShowBackupCodesModal'), {
          codes
        })
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    },
    async editProfile () {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/EditProfileModal'))
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  async created () {
    try {
      this.loading = true
      await this.queryProfile()
    } finally {
      this.loading = false
    }
  }
}
</script>
