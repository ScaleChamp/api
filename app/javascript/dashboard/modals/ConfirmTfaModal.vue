<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('tfa_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <p class="text-sm">
        {{ $t('tfa_modal.info') }} <b>{{ response.headers.location }}</b>
      </p>
      <p class="text-sm">
        {{ $t('tfa_modal.info1') }}
      </p>
      <div class="text-center">
        <QrcodeVue
          :value="response.data"
          level="H"
          size="200"
          class="inline-block"
        />
      </div>
      <p class="text-sm">
        {{ $t('tfa_modal.info2') }}
      </p>
      <div>
        <BaseInput v-model="code"
                   :placeholder="$t('tfa_modal.confirm_otp')"
                   :danger="$v.code.$error || error"
                   @blur="$v.code.$touch"
        />
        <VuelidateError v-if="$v.code.$error">
          <template v-if="!$v.code.required">{{ $t('tfa_modal.otp_required') }}</template>
        </VuelidateError>
        <VuelidateError v-if="error">{{ $t(error.message) }}</VuelidateError>
      </div>
      <BaseButton @click="confirmOtpAndNext"
                  :is-loading="loading"
                  class="w-full bg-primary text-white hover:bg-primary-100">
        {{ $t('tfa_modal.confirm') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { required } from 'vuelidate/lib/validators'
import { mapActions } from 'vuex'
import ModalHeader from './components/ModalHeader'
import ModalBody from './components/ModalBody'
import Close from './components/Close'
import Modal from './components/Modal'
import QrcodeVue from 'qrcode.vue'

export default {
  components: {
    QrcodeVue,
    Modal,
    ModalHeader,
    ModalBody,
    Close
  },
  mixins: [ModalMixin],
  props: ['response'],
  data () {
    return {
      code: '',
      error: null,
      loading: false
    }
  },
  validations: {
    code: {
      required
    }
  },
  methods: {
    ...mapActions({
      confirmOtp: 'sessions/confirmOtp'
    }),
    async confirmOtpAndNext () {
      try {
        this.loading = true
        const { headers: { location } } = await this.confirmOtp({
          code: this.code
        })
        this.success(location.split(','))
      } catch (err) {
        this.error = err?.response?.data || err.message
      } finally {
        this.loading = false
      }
    }
  }
}
</script>
