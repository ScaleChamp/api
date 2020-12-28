<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">{{ $t('show_access_key') }}</h2>
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <h3 class="text-center font-semibold">
        {{ secret }}
      </h3>
      <BaseButton class="bg-primary text-white hover:bg-primary-100 w-full"
                  @click="failure">
        {{ $t('done') }}
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
  mixins: [ModalMixin],
  props: ['secret']
}
</script>
