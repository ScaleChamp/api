<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('select_login_method_modal.choose_login') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <p class="text-base">{{ $t('select_login_method_modal.select_from_list') }}:</p>
      <div class="flex space-x-4">
        <div class="w-full">
          <BaseButton class="bg-primary w-full text-white hover:bg-primary-100"
                      @click="success('email')">
            {{ $t('select_login_method_modal.email') }}
          </BaseButton>
        </div>
        <div class="w-full">
          <GoogleButton @click="success('google')">
            Google
          </GoogleButton>
        </div>
        <div class="w-full">
          <GithubButton @click="success('github')">
            Github
          </GithubButton>
        </div>
      </div>
    </ModalBody>
  </modal>
</template>

<script>
import ModalMixin from '@/plugins/modal/mixin'
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
  mixins: [ModalMixin]
}
</script>
