<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('are_you_sure') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseButton @click="success" class="w-full bg-primary text-white hover:bg-primary-100">
        {{ $t('proceed') }}
      </BaseButton>
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
