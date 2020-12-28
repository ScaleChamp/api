<template>
    <div>
      <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="signUpError">
        {{ signUpError.response.data && signUpError.response.data.message || signUpError.message }}
      </div>
      <div class="text-green-600 border border-green-500 bg-green-100 bg-opacity-75 p-4 rounded-sm" v-if="success">{{ $t('sign_up.checkout_email') }}</div>
      <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="messages.length">
        <span v-for="message in messages" :key="message">{{ $t(message) }}</span>
      </div>
      <div class="space-y-2">
        <h1 class="text-4xl text-center md:text-left text-gray-900">{{ $t('sign_up.title') }}</h1>
        <p class="text-center md:text-left text-gray-700">{{ $route.query.invite ? $t('sign_up.invited') : $t('sign_up.info') }}</p>
      </div>
      <BaseForm @submit.prevent="validateAndSignUp">
        <BaseInput
          ref="email"
          :danger="$v.name.$error"
          v-model="$v.name.$model"
          type="text"
          :placeholder="$t('sign_up.full_name')"
        />
        <VuelidateError v-if="$v.name.$error">
          <template v-if="!$v.name.required">
            {{ $t('sign_up.name_required') }}
          </template>
        </VuelidateError>
        <BaseInput
          v-model="$v.email.$model"
          type="email"
          :danger="$v.email.$error"
          :placeholder="$t('login.email_placeholder')"
        />
        <VuelidateError v-if="$v.email.$error">
          <template v-if="!$v.email.required">{{ $t('sign_up.email_required') }}</template>
          <template v-if="!$v.email.email">{{ $t('sign_up.email_invalid') }}</template>
        </VuelidateError>
        <BaseInput v-model="$v.password.$model"
                   type="password"
                   :danger="$v.password.$error"
                   :placeholder="$t('login.password_placeholder')"
        />
        <VuelidateError v-if="$v.password.$error">
          <template v-if="!$v.password.required">
            {{ $t('sign_up.pass_required') }}
          </template>
          <template v-if="!$v.password.minLength">
            {{ $t('login.pass_invalid') }}
          </template>
        </VuelidateError>
        <AuthButton :disabled="isSignUpLoading" :is-loading="isSignUpLoading">
          {{ $t('sign_up.title') }}
        </AuthButton>
      </BaseForm>
      <OrLine>{{ $t('login.or') }}</OrLine>
      <BaseForm>
        <GoogleButton :href="searchForward('/registrations/google')">
          {{ $t('sign_up.google') }}
        </GoogleButton>
        <GithubButton :href="searchForward('/registrations/github')">
          {{ $t('sign_up.github') }}
        </GithubButton>
      </BaseForm>
      <i18n path="sign_up.tos" tag="div" class="w-full mt-4 text-gray-700 text-sm">
        <template #terms>
          <a href="https://www.scalechamp.com/terms-of-service.pdf" target="_blank" class="text-primary hover:text-primary-100">
            {{ $t('tos') }}
          </a>
        </template>
        <template #privacy>
          <a href="https://www.scalechamp.com/privacy.pdf" target="_blank" class="text-primary hover:text-primary-100">
            {{ $t('privacy') }}
          </a>
        </template>
      </i18n>
    </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import FlashMixin from '@/mixins/flash'
import { email, minLength, required } from 'vuelidate/lib/validators'

export default {
  mixins: [FlashMixin],
  data () {
    return {
      success: false,
      name: '',
      email: '',
      password: '',
      invite: null
    }
  },
  validations: {
    name: {
      required
    },
    email: {
      email,
      required
    },
    password: {
      required,
      minLength: minLength(8)
    }
  },
  mounted () {
    this.$refs.email.$el.focus()
  },
  computed: {
    ...mapState('sessions', [
      'user',
      'isSignUpLoading',
      'signUpError'
    ])
  },
  methods: {
    searchForward (pathname) {
      const u = new URL(window.location.origin)
      u.pathname = pathname
      if (this.$route.query.invite) {
        u.search = `invite=${this.$route.query.invite}`
      }
      if (this.$route.query.plan) {
        u.search = `plan=${this.$route.query.plan}`
      }
      return u
    },
    ...mapActions('sessions', ['signup']),
    async validateAndSignUp () {
      this.$v.$touch()
      if (this.$v.$invalid) {
        return
      }
      await this.signup({
        email: this.email,
        password: this.password,
        passwordConfirmation: this.password,
        name: this.name,
        invite: this.$route.query.invite,
        plan_id: this.$route.query.plan
      })
      if (this.user) {
        this.$router.replace({ name: 'projects' })
      } else {
        this.email = ''
        this.password = ''
        this.$v.$reset()
        this.success = true
      }
    }
  }
}
</script>
