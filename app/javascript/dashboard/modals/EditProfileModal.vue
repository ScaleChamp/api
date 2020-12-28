<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('edit_profile') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <form class="space-y-2" @submit.prevent="editProfile">
        <p class="text-base">{{ $t('write_down_your_name') }}:</p>
        <BaseInput v-model.trim="$v.name.$model"
                   type="text"
                   :placeholder="$t('edit_profile_modal.name')"
                   :danger="$v.name.$error"
                   @blur="$v.name.$touch"
        />
        <VuelidateError v-if="$v.name.$error">
          <template v-if="!$v.name.required">{{ $t('edit_profile_modal.name_required') }}</template>
        </VuelidateError>
      </form>
      <BaseButton class="w-full bg-primary text-white hover:bg-primary-100"
                  :is-loading="isUpdateUserLoading"
                  @click="editProfile">
        {{ $t('edit_profile_modal.update') }}
      </BaseButton>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
import { mapActions, mapState } from 'vuex'
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
      name: ''
    }
  },
  validations: {
    name: {
      required
    }
  },
  computed: {
    ...mapState('sessions', [
      'user',
      'isUpdateUserLoading',
      'updateUserError'
    ])
  },
  methods: {
    ...mapActions({
      updateUser: 'sessions/updateUser'
    }),
    async editProfile () {
      this.$v.$touch()
      if (this.$v.$invalid) {
        return
      }
      await this.updateUser({
        id: this.user.id,
        name: this.name
      })
      this.success({ name })
    }
  }
}
</script>
