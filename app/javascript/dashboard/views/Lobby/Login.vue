<template>
  <div>
    <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="messages.length">
      <span v-for="message in messages" :key="message">{{ $t(message) }}</span>
    </div>
    <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="loginError">
      {{ $t(loginError.response.data && loginError.response.data.message || loginError.message) }}
    </div>
    <div class="space-y-2">
      <h1 class="text-4xl text-gray-900 text-center md:text-left">{{ $t('login.title') }}</h1>
      <p class="text-center md:text-left text-gray-700">{{ $t('login.info') }}</p>
    </div>
    <template v-if="otp">
      <BaseForm @submit.prevent="verifyAndRedirect">
        <BaseInput v-model="tfa.code"
                   class="block"
                   type="text"
                   :placeholder="$t('otp_code')"
        />
        <BaseButton class="bg-primary text-white">{{ $t('login.title') }}</BaseButton>
      </BaseForm>
    </template>
    <template v-else>
      <BaseForm @submit.prevent="loginAndRedirect">
        <BaseInput v-model="$v.basic.email.$model"
                   ref="email"
                   autocomplete="username email"
                   type="text"
                   :placeholder="$t('login.email_placeholder')"
                   :danger="$v.basic.email.$error"/>
        <VuelidateError v-if="$v.basic.email.$error">
          <template v-if="!$v.basic.email.required">{{ $t('login.email_required') }}</template>
          <template v-if="!$v.basic.email.email">{{ $t('login.email_invalid') }}</template>
        </VuelidateError>
        <BaseInput v-model="$v.basic.password.$model"
                   autocomplete="current-password"
                   type="password"
                   :placeholder="$t('login.password_placeholder')"
                   :danger="$v.basic.password.$error"/>
        <VuelidateError v-if="$v.basic.password.$error">
          <template v-if="!$v.basic.password.required">
            {{ $t('login.pass_required') }}
          </template>
          <template v-if="!$v.basic.password.minLength">
            {{ $t('login.pass_invalid') }}
          </template>
        </VuelidateError>
        <AuthButton
          :disabled="isLoginLoading"
          :is-loading="isLoginLoading">
          {{ $t('login.with_password') }}
        </AuthButton>
      </BaseForm>
      <OrLine>{{ $t('login.or') }}</OrLine>
      <BaseForm>
        <GoogleButton href="/sessions/google">{{ $t('login_google') }}</GoogleButton>
        <GithubButton href="/sessions/github">{{ $t('login_github') }}</GithubButton>
      </BaseForm>
      <router-link
        :to="{ name: 'forgot-password' }"
        class="text-sm block text-primary hover:text-primary-100">
        {{ $t('login.forgot_password') }}
      </router-link>
    </template>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import FlashMixin from '@/mixins/flash'
import { required, maxLength, email, minLength } from 'vuelidate/lib/validators'

export default {
  mixins: [FlashMixin],
  data () {
    return {
      otp: false,
      basic: {
        email: '',
        password: ''
      },
      tfa: {
        code: ''
      }
    }
  },
  mounted () {
    this.$refs.email.$el.focus()
  },
  validations: {
    tfa: {
      code: {
        required,
        minLength: minLength(6),
        maxLength: maxLength(6)
      }
    },
    basic: {
      email: {
        email,
        required,
        maxLength: maxLength(255)
      },
      password: {
        required,
        minLength: minLength(8)
      }
    }
  },
  computed: {
    ...mapState('sessions', [
      'loginError',
      'isLoginLoading',
      'verifyError',
      'isVerifyLoading'
    ])
  },
  methods: {
    ...mapActions({
      login: 'sessions/login',
      verify: 'sessions/verify'
    }),
    async verifyAndRedirect () {
      this.$v.tfa.$touch()
      if (this.$v.tfa.$invalid) {
        return
      }
      const { headers } = await this.verify({
        email: this.basic.email,
        password: this.basic.password,
        code: this.tfa.code
      })
      if (headers.location) {
        this.$router.replace(headers.location)
      } else {
        this.$router.replace({ name: 'projects' })
      }
    },
    async loginAndRedirect () {
      this.$v.basic.$touch()
      if (this.$v.basic.$invalid) {
        return
      }
      const { headers, status } = await this.login({
        email: this.basic.email,
        password: this.basic.password
      })
      if (status === 202) {
        this.otp = true
      } else if (headers.location) {
        console.log(headers.location)
        this.$router.replace(headers.location)
      } else {
        this.$router.replace({ name: 'projects' })
      }
    }
  }
}
</script>
