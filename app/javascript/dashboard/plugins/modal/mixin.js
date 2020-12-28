export default {
  methods: {
    success (event) {
      this.$emit('success', event)
    },
    failure (event) {
      this.$emit('failure', event)
    }
  }
}
