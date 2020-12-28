<template>
  <modal>
    <ModalHeader>
      <h2 class="text-2xl">
        {{ $t('backup_codes') }}
      </h2>
      <Close @click="failure" />
    </ModalHeader>
    <ModalBody>
      <div class="font-semibold grid grid-cols-3">
        <div v-for="code in codes" :key="code">{{ code }}</div>
      </div>
      <BaseButton class="w-full bg-primary text-white hover:bg-primary-100"
                  @click="success">
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
  mixins: [ModalMixin],
  props: ['codes']
}
</script>
