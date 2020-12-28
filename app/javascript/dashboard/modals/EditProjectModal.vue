<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('edit_project_modal.title') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <form class="space-y-2" @submit.prevent="editProfile">
        <p class="text-base">{{ $t('edit_project_modal.edit_desc') }}:</p>
        <BaseInput
          v-model="description"
          type="text"
          :placeholder="$t('edit_project_modal.desc')"
          :danger="$v.description.$error"
          @blur="$v.description.$touch"
        />
        <VuelidateError v-if="$v.description.$error">
          <template v-if="!$v.description.required">{{ $t('edit_project_modal.desc_required') }}</template>
        </VuelidateError>
      </form>
      <BaseButton @click="editProfile"
                  class="w-full bg-primary text-white hover:bg-primary-100"
                  :is-loading="isProjectUpdating">
        {{ $t('edit_project_modal.update') }}
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
      description: ''
    }
  },
  validations: {
    description: {
      required
    }
  },
  computed: {
    ...mapState('project', [
      'isProjectUpdating',
      'projectUpdateError'
    ])
  },
  methods: {
    ...mapActions({
      updateProject: 'project/updateProject'
    }),
    async editProfile () {
      this.updateProject({
        id: this.$route.params.projectId,
        description: this.description
      })
      this.success()
    }
  }
}
</script>
