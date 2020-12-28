<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('email_update_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <form class="space-y-4" @submit.prevent="updateEmailAndClose">
        <BaseInput v-model="$v.email.$model"
                   type="text"
                   :placeholder="$t('email_update_modal.email')"
                   :danger="$v.email.$error"
                   @blur="$v.email.$touch"
        />
        <VuelidateError v-if="$v.email.$error">
          <template v-if="!$v.email.required">{{ $t('email_update_modal.email_required') }}</template>
          <template v-if="!$v.email.email">{{ $t('email_update_modal.email_invalid') }}</template>
        </VuelidateError>
        <BaseInput v-model="$v.password.$model"
                   type="password"
                   :placeholder="$t('email_update_modal.new_pass')"
                   :danger="$v.password.$error"
                   @blur="$v.password.$touch"
        />
        <VuelidateError v-if="$v.password.$error">
          <template v-if="!$v.password.required">{{ $t('email_update_modal.pass_required') }}</template>
        </VuelidateError>
        <BaseInput v-model="$v.password.$model"
                   type="password"
                   :placeholder="$t('email_update_modal.confirm')"
                   :danger="$v.password.$error"
                   @blur="$v.password.$touch"
        />
        <VuelidateError v-if="$v.password.$error">
          <template v-if="!$v.password.required">{{ $t('email_update_modal.confirm_required') }}</template>
        </VuelidateError>
      </form>
      <BaseButton class="w-full bg-primary text-white hover:bg-primary-100"
                  :is-loading="isUpdateEmailLoading"
                  :disabled="isUpdateEmailLoading"
                  @click="updateEmailAndClose">
        {{ $t('apply') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { mapActions, mapState } from 'vuex'
import { email, required } from 'vuelidate/lib/validators'
import ModalHeader from './components/ModalHeader'
import ModalBody from './components/ModalBody'
import Close from './components/Close'
import Modal from './components/Modal'

export default {
  components: {
    Modal,
    ModalHeader,
    ModalBody,
    Close
  },
  mixins: [ModalMixin],
  data () {
    return {
      email: '',
      password: ''
    }
  },
  validations: {
    email: {
      required,
      email
    },
    password: {
      required
    }
  },
  computed: {
    ...mapState('sessions', [
      'isUpdateEmailLoading',
      'updateEmailError'
    ])
  },
  methods: {
    ...mapActions({
      updateEmail: 'sessions/updateEmail'
    }),
    async updateEmailAndClose () {
      await this.updateEmail({
        email: this.email,
        password: this.password
      })
      this.success()
    }
  }
}
</script>
