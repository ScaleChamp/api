<template>
  <Modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('accept_invite.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <p class="text-base">{{ $t('accept_invite.question', { name }) }}</p>
      <BaseButton class="bg-primary text-white hover:bg-primary-100 w-full"
                  @click="acceptInvite"
                  :is-loading="isConfirmInviteLoading">
        {{ $t('accept_invite.accept') }}
      </BaseButton>
    </ModalBody>
  </Modal>
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
  mixins: [ModalMixin],
  props: ['name'],
  computed: {
    ...mapState('members', [
      'isConfirmInviteLoading'
    ])
  },
  methods: {
    ...mapActions('members', [
      'confirmInvite'
    ]),
    async acceptInvite () {
      await this.confirmInvite({
        id: this.$route.query.invite
      })
      this.success()
    }
  }
}
</script>
