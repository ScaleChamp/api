<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('create_vpc_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="createNetworkAndAlert">
        <div class="space-y-2">
          <h3 class="text-base space-x-1">{{ $t('create_vpc_modal.ip_range') }}:</h3>
          <BaseInput v-model.trim="$v.network.$model"
                     required
                     type="text"
                     class="w-full"
                     :placeholder="$t('create_vpc_modal.network')"
                     :danger="$v.network.$error"
                     @blur="$v.network.$touch"
          />
          <VuelidateError v-if="$v.network.$error">
            <template v-if="!$v.network.required">{{ $t('create_vpc_modal.ip_range_required') }}</template>
          </VuelidateError>
        </div>
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('create_vpc_modal.select_cloud') }}:</h3>
          <BaseSelect v-model="$v.vpcId.$model" :danger="$v.vpcId.$error" @blur="$v.vpcId.$touch">
            <option :value="null" disabled hidden>{{ $t('create_vpc_modal.select_cloud') }}</option>
            <optgroup :label="$t(cloud)" v-for="(vpcs, cloud) in byCloud" :key="cloud">
              <option v-for="vpc in vpcs"
                :key="vpc.id"
                :value="vpc.id">
                {{ $t(vpc.region) }}
              </option>
            </optgroup>
          </BaseSelect>
          <VuelidateError v-if="$v.vpcId.$error">
            <template v-if="!$v.vpcId.required">{{ $t('create_peer_modal.cloud_required') }}</template>
          </VuelidateError>
        </div>
      </BaseForm>
      <BaseButton @click="createNetworkAndAlert"
                  class="w-full bg-primary text-white hover:bg-primary-100 disabled:bg-gray-300"
                  :disabled="$v.$invalid"
                  :is-loading="loading">
        {{ $t('create_vpc_modal.title') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { mapActions, mapGetters } from 'vuex'
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
      network: '',
      vpcId: null
    }
  },
  validations: {
    network: {
      required
    },
    vpcId: {
      required
    }
  },
  computed: {
    ...mapGetters('vpcs', [
      'byCloud'
    ])
  },
  methods: {
    ...mapActions({
      createNetwork: 'networks/createNetwork'
    }),
    async createNetworkAndAlert () {
      try {
        this.loading = true
        await this.createNetwork({
          projectId: this.$route.params.projectId,
          network: this.network,
          vpc_id: this.vpcId
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
