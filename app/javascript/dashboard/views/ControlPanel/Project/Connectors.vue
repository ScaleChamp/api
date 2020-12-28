<template>
  <div>
    <h1 class="text-4xl">
      {{ $t('connectors') }}
    </h1>
    <div class="flex items-center justify-between shadow py-6 px-6 rounded-sm pixel-sorting banner">
      <div class="text-xl text-white font-semibold">
        {{ $t('connectors_comming_soon') }}
      </div>
      <BaseButton v-if="ownerOrAdministrator" class="bg-white flex justify-center items-center" :to="{ name: 'new-instance' }">
        {{ $t('notification_placeholder') }}
      </BaseButton>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters('project', ['ownerOrAdministrator'])
}
</script>
