<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('create_peer_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="createPeerAndAlert">
        <div class="space-y-2">
          <h3 class="text-base space-x-1">{{ $t('create_peer_modal.aws_account_id') }}:</h3>
          <BaseInput v-model.trim="$v.aws_account_id.$model"
                     required
                     type="text"
                     class="w-full"
                     :placeholder="$t('create_peer_modal.aws_account_id')"
                     :danger="$v.aws_account_id.$error"
                     @blur="$v.aws_account_id.$touch"
          />
          <VuelidateError v-if="$v.aws_account_id.$error">
            <template v-if="!$v.aws_account_id.required">{{ $t('create_peer_modal.aws_account_id_required') }}</template>
          </VuelidateError>
        </div>
        <div class="space-y-2">
          <h3 class="text-base space-x-1">{{ $t('create_peer_modal.aws_vpc_id') }}:</h3>
          <BaseInput v-model.trim="$v.aws_vpc_id.$model"
                     required
                     type="text"
                     class="w-full"
                     :placeholder="$t('create_peer_modal.aws_vpc_id')"
                     :danger="$v.aws_vpc_id.$error"
                     @blur="$v.aws_vpc_id.$touch"
          />
          <VuelidateError v-if="$v.aws_vpc_id.$error">
            <template v-if="!$v.aws_vpc_id.required">{{ $t('create_peer_modal.aws_vpc_id_required') }}</template>
          </VuelidateError>
        </div>
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('create_peer_modal.aws_vpc_region') }}:</h3>
          <BaseSelect v-model="$v.aws_vpc_region.$model" :danger="$v.aws_vpc_region.$error" @blur="$v.aws_vpc_region.$touch">
            <option :value="null" disabled hidden>{{ $t('create_peer_modal.choose_region') }}</option>
            <option v-for="region in regions"
                    :key="region"
                    :value="region">
              {{ $t(region) }}
            </option>
          </BaseSelect>
          <VuelidateError v-if="$v.aws_vpc_region.$error">
            <template v-if="!$v.aws_vpc_region.required">{{ $t('create_peer_modal.aws_vpc_region_required') }}</template>
          </VuelidateError>
        </div>
      </BaseForm>
      <BaseButton @click="createPeerAndAlert"
                  class="w-full bg-primary text-white hover:bg-primary-100 disabled:bg-gray-300"
                  :disabled="$v.$invalid"
                  :is-loading="loading">
        {{ $t('create_peer_modal.title') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { mapActions } from 'vuex'
import { required } from 'vuelidate/lib/validators'
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
      loading: false,
      aws_account_id: '',
      aws_vpc_id: '',
      aws_vpc_region: null,
      regions: ['eu-north-1'],
    }
  },
  validations: {
    aws_account_id: {
      required
    },
    aws_vpc_id: {
      required
    },
    aws_vpc_region: {
      required
    }
  },
  methods: {
    ...mapActions({
      createPeer: 'peers/createPeer'
    }),
    async createPeerAndAlert () {
      try {
        this.loading = true
        const { projectId, id } = this.$route.params
        await this.createPeer({
          aws_peer_owner_id: this.aws_account_id,
          aws_peer_region: this.aws_vpc_region,
          aws_peer_vpc_id: this.aws_vpc_id,
          projectId,
          networkId: id,
        })
        this.success()
      } catch (err) {
        this.loading = false
        this.failure(err)
      }
    }
  }
}
</script>
