<template>
    <div class="d-flex flex-column">
      <router-view class="w-full h-full" />
      <modal-container />
    </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState('sessions', [
    'user'
  ]),
  created () {
    this.$pusher.connect()
    this.$pusher.subscribe(`private-user-${this.user.id}`)
  },
  beforeDestroy () {
    this.$pusher.disconnect()
  }
}
</script>
