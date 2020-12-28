<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('invite_member.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseForm @submit.prevent="inviteMemberAndClose">
        <div class="space-y-2">
          <h3 class="text-base">{{ $t('invite_member.write_email') }}:</h3>
          <BaseInput v-model="email"
                     type="text"
                     :placeholder="$t('invite_member.email')"
                     :danger="$v.email.$error"
                     @blur="$v.email.$touch"
          />
          <VuelidateError v-if="$v.email.$error">
            <template v-if="!$v.email.required">{{ $t('invite_member.email_required') }}</template>
            <template v-if="!$v.email.email">{{ $t('invite_member.email_invalid') }}</template>
          </VuelidateError>
        </div>
        <div class="space-y-2">
          <h3 class="text-base mt-2">{{ $t('invite_member.choose_role') }}:</h3>
          <BaseSelect v-model.number="role">
            <option v-for="option in roles"
                    :key="option.text"
                    :value="option.value">
              {{ option.text }}
            </option>
          </BaseSelect>
        </div>
      </BaseForm>
      <BaseButton class="bg-primary text-white hover:bg-primary-100 w-full"
                  :is-loading="isQueryInviteMemberLoading"
                  @click="inviteMemberAndClose">
        {{ $t('invite_member.invite') }}
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
    const roles = Object.freeze([
      { value: 3, text: this.$t('member') },
      { value: 2, text: this.$t('administrator') },
      { value: 1, text: this.$t('accountant') },
      { value: 0, text: this.$t('owner') }
    ])
    return {
      email: '',
      role: roles[0].value,
      roles
    }
  },
  validations: {
    email: {
      required,
      email
    }
  },
  computed: {
    ...mapState('members', [
      'isQueryInviteMemberLoading'
    ])
  },
  methods: {
    ...mapActions({
      inviteMember: 'members/inviteMember'
    }),
    async inviteMemberAndClose () {
      this.$v.$touch()
      if (this.$v.$error) {
        return
      }
      await this.inviteMember({
        email: this.email,
        role: this.role,
        projectId: this.$route.params.projectId
      })
      this.success()
    }
  }
}
</script>
