<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('create_project') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <form @submit.prevent="createProjectAndRedirect">
        <h3 class="text-base">{{ $t('create_project_modal.choose_name') }}:</h3>
        <BaseInput v-model.trim="$v.name.$model"
                     required
                     class="w-full mt-2"
                     :placeholder="$t('create_project_modal.name')"
                     :danger="$v.name.$error"
                     @blur="$v.name.$touch"
        />
        <VuelidateError v-if="$v.name.$error">
          <template v-if="!$v.name.required">{{ $t('create_project_modal.name_required') }}</template>
        </VuelidateError>
        <h3 class="text-base mt-4">{{ $t('choose_description') }}:</h3>
        <BaseInput v-model.trim="$v.description.$model"
                   class="w-full mt-2"
                   :danger="$v.description.$error"
                   @blur="$v.description.$touch"
                   :placeholder="$t('create_project_modal.description')"
        />
        <VuelidateError v-if="$v.description.$error">
          <template v-if="!$v.description.required">{{ $t('create_project_modal.description_required') }}</template>
        </VuelidateError>
      </form>
      <BaseButton class="w-full text-white mt-6"
                  :class="{ 'bg-gray-300': $v.$invalid, 'hover:bg-primary-100 bg-primary': !$v.$invalid }"
                  :disabled="isCreateProjectLoading || $v.$invalid"
                  :is-loading="isCreateProjectLoading"
                  @click="createProjectAndRedirect">
        {{ $t('create_project') }}
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
import { required } from 'vuelidate/lib/validators'

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
      name: '',
      description: ''
    }
  },
  validations: {
    name: {
      required
    },
    description: {
      required
    }
  },
  computed: mapState('projects', [
    'isCreateProjectLoading',
    'createProjectError'
  ]),
  methods: {
    ...mapActions({
      createProject: 'projects/createProject'
    }),
    async createProjectAndRedirect () {
      console.log('one')
      this.$v.$touch()
      if (this.$v.$error) {
        return
      }
      const { data: project } = await this.createProject({
        name: this.name,
        description: this.description
      })
      this.$router.push({ name: 'services', params: { projectId: project.id } })
      this.success()
    }
  }
}
</script>
