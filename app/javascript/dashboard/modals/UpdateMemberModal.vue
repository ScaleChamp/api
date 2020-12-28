<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('update_member.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="updateMemberAndFinish">
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('update_member.email') }}:</h3>
          <p class="text-base px-4 border border-gray-400 rounded-sm h-12 flex items-center justify-between">
            <span class="font-semibold">{{ member.email }}</span>
            <span v-if="member.state == 'pending'"
                  class="text-primary cursor-pointer"
                  @click="resendInviteAndFinish">
            {{ $t('update_member.resend_invite') }}
          </span>
          </p>
        </div>
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('update_member.update_role') }}:</h3>
          <BaseSelect v-model.number="role">
            <option v-for="option in roles"
                    :key="option.text"
                    :value="option.value">
              {{ option.text }}
            </option>
          </BaseSelect>
        </div>
      </BaseForm>
      <BaseButton class="text-white w-full"
                  :is-loading="isUpdateMemberLoading"
                  :class="{ 'bg-gray-400': initialRole == role, 'bg-primary hover:bg-primary-100': initialRole != role }"
                  :disabled="initialRole == role"
                  @click="updateMemberAndFinish">
        {{ $t('update_member.update') }}
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
  props: ['member'],
  mixins: [ModalMixin],
  data () {
    const roles = Object.freeze([
      { value: 3, text: this.$t('member') },
      { value: 2, text: this.$t('administrator') },
      { value: 1, text: this.$t('accountant') },
      { value: 0, text: this.$t('owner') }
    ])
    const initialRole = roles.find(x => x.text === this.$t(this.member.role)).value
    return {
      initialRole,
      role: initialRole,
      roles
    }
  },
  computed: {
    ...mapState('members', [
      'isUpdateMemberLoading',
      'updateMemberError',
      'isResendInviteLoading',
      'resendInviteError'
    ])
  },
  methods: {
    ...mapActions({
      updateMember: 'members/updateMember',
      resendInvite: 'members/resendInvite'
    }),
    async resendInviteAndFinish () {
      await this.resendInvite({
        email: this.member.email,
        projectId: this.$route.params.projectId
      })
      this.success()
    },
    async updateMemberAndFinish () {
      await this.updateMember({
        id: this.member.id,
        role: this.role,
        projectId: this.$route.params.projectId
      })
      this.success()
    }
  }
}
</script>
