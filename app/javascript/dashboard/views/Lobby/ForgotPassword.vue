<template>
    <div>
        <div class="text-green-600 border border-green-500 bg-green-100 bg-opacity-75 p-4 rounded-sm" v-if="success">
          {{ $t('sign_up.checkout_email') }}
        </div>
        <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="forgetPasswordError">
          {{ forgetPasswordError.response.data && forgetPasswordError.response.data.message || forgetPasswordError.message }}
        </div>
        <div class="space-y-2">
          <h1 class="text-4xl text-center md:text-left text-gray-900">{{ $t('forgot_password.title') }}</h1>
          <p class="block text-gray-700 text-center md:text-left">
            <template v-if="$route.query.token">{{ $t('forgot_password.info_new') }}</template>
            <template v-else>{{ $t('forgot_password.info') }}</template>
          </p>
        </div>
        <BaseForm v-if="$route.query.token" @submit.prevent="recoverPasswordAndRedirect">
          <BaseInput v-model="$v.confirm.password.$model"
                     type="password"
                     :placeholder="$t('forgot_password.password_placeholder')"
                     :danger="$v.confirm.password.$error"
          />
          <BaseInput v-model="$v.confirm.passwordConfirmation.$model"
                     type="password"
                     :placeholder="$t('forgot_password.password_placeholder')"
                     :danger="$v.confirm.passwordConfirmation.$error"
          />
          <AuthButton :disabled="isForgetPasswordLoading"
                      :is-loading="isRecoverPasswordLoading">
            {{ $t('forgot_password.recover_password') }}
          </AuthButton>
        </BaseForm>
        <BaseForm v-else @submit.prevent="forgetPasswordAndWait">
          <BaseInput
            ref="email"
            v-model.trim="$v.request.email.$model"
            type="email"
            :placeholder="$t('forgot_password.email_placeholder')"
            :danger="$v.request.email.$error"
          />
          <VuelidateError v-if="$v.request.email.$error">
            <template v-if="!$v.request.email.required">{{ $t('forgot_password.email_required') }}</template>
            <template v-if="!$v.request.email.email">{{ $t('forgot_password.email_invalid') }}</template>
          </VuelidateError>
          <AuthButton :disabled="isForgetPasswordLoading"
                      :is-loading="isForgetPasswordLoading">
            {{ $t('forgot_password.reset') }}
          </AuthButton>
        </BaseForm>
    </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import { email, minLength, required } from 'vuelidate/lib/validators'

export default {
  data () {
    return {
      success: false,
      request: {
        email: ''
      },
      confirm: {
        password: '',
        passwordConfirmation: ''
      }
    }
  },
  validations: {
    request: {
      email: {
        email,
        required
      }
    },
    confirm: {
      password: {
        required,
        minLength: minLength(8)
      },
      passwordConfirmation: {
        required,
        minLength: minLength(8)
      }
    }
  },
  computed: {
    ...mapState('passwords', [
      'isRecoverPasswordLoading',
      'isForgetPasswordLoading',
      'forgetPasswordError'
    ])
  },
  mounted () {
    this.$refs.email.$el.focus()
  },
  methods: {
    ...mapActions({
      forgetPassword: 'passwords/forgetPassword',
      recoverPassword: 'sessions/recoverPassword'
    }),
    async forgetPasswordAndWait () {
      this.$v.request.$touch()
      if (this.$v.request.$invalid) {
        return
      }
      await this.forgetPassword(this.request)
      this.request.email = ''
      this.success = true
    },
    async recoverPasswordAndRedirect () {
      this.$v.confirm.$touch()
      if (this.$v.confirm.$invalid) {
        return
      }
      await this.recoverPassword({
        id: this.$route.query.token,
        password: this.confirm.password,
        passwordConfirmation: this.confirm.passwordConfirmation
      })
      this.$router.push({ name: 'login' })
    }
  }
}
</script>
