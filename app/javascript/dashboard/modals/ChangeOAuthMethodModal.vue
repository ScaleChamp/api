<template>
  <Modal>
    <ModalHeader>
      <h2 class="text-2xl" v-text="title" />
      <Close @click="failure"/>
    </ModalHeader>
    <ModalBody>
      <BaseButton :href="link"
                  class="bg-primary text-white hover:bg-primary-100 flex items-center justify-center">
        {{ name }}
      </BaseButton>
    </ModalBody>
  </Modal>
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
  props: ['title', 'name', 'link']
}
</script>
