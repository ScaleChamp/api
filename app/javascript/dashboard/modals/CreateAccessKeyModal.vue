<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('create_api_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="createAccessKeyAndAlert">
        <div class="space-y-2">
          <h3 class="text-base space-x-1">{{ $t('create_api_modal.choose_name') }}:</h3>
          <BaseInput v-model.trim="$v.name.$model"
                     required
                     type="text"
                     class="w-full"
                     :placeholder="$t('create_api_modal.name')"
                     :danger="$v.name.$error"
                     @blur="$v.name.$touch"
          />
          <VuelidateError v-if="$v.name.$error">
            <template v-if="!$v.name.required">{{ $t('create_api_modal.name_required') }}</template>
          </VuelidateError>
        </div>
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('create_api_modal.select_scope') }}:</h3>
          <BaseSelect v-model="permission">
            <option v-for="option in ['ro', 'rw']"
                    :key="option"
                    :value="option">
              {{ $t(option) }}
            </option>
          </BaseSelect>
        </div>
      </BaseForm>
      <BaseButton @click="createAccessKeyAndAlert"
                  class="w-full bg-primary text-white hover:bg-primary-100 disabled:bg-gray-300"
                  :disabled="$v.$invalid"
                  :is-loading="loading">
        {{ $t('create_api_modal.title') }}
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
      name: '',
      permission: 'ro'
    }
  },
  validations: {
    name: {
      required
    }
  },
  methods: {
    ...mapActions({
      createAccessKey: 'keys/createAccessKey'
    }),
    async createAccessKeyAndAlert () {
      try {
        this.loading = true
        const { data: accessKey } = await this.createAccessKey({
          projectId: this.$route.params.projectId,
          name: this.name,
          permission: this.permission
        })
        this.success(accessKey.token)
      } catch (err) {
        this.failure(err)
      }
    }
  }
}
</script>
