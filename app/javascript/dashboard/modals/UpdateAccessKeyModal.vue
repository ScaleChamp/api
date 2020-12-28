<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('update_access_key_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="updateAccessKeyAndAlert">
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('update_access_key_modal.select_scope') }} <b>{{ accessKey.name }}</b>:</h3>
          <BaseSelect v-model="permission">
            <option v-for="option in ['ro', 'rw']"
                    :key="option"
                    :value="option">
              {{ $t(option) }}
            </option>
          </BaseSelect>
        </div>
      </BaseForm>
      <BaseButton @click="updateAccessKeyAndAlert"
                  class="bg-primary text-white hover:bg-primary-100 disabled:bg-gray-300 w-full"
                  :disabled="accessKey.permission == permission"
                  :is-loading="isUpdateKeyLoading">
        {{ $t('update_access_key_modal.title') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { mapActions, mapState } from 'vuex'
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
  props: ['accessKey'],
  mixins: [ModalMixin],
  data () {
    return {
      permission: this.accessKey.permission
    }
  },
  computed: mapState('keys', ['isUpdateKeyLoading']),
  methods: {
    ...mapActions({
      updateAccessKey: 'keys/updateAccessKey'
    }),
    async updateAccessKeyAndAlert () {
      try {
        await this.updateAccessKey({
          projectId: this.$route.params.projectId,
          id: this.accessKey.id,
          permission: this.permission
        })
        this.success()
      } catch (err) {
        this.failure(err)
      }
    }
  }
}
</script>
