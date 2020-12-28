<template>
  <BaseButton class="transition w-full duration-300 ease-in-out bg-primary hover:bg-primary-100 text-white"
              type="submit"
              v-bind="$attrs"
              :is-loading="isLoading"
              v-on="$listeners">
    <slot/>
  </BaseButton>
</template>

<script>
import BaseButton from './BaseButton'

export default {
  extends: BaseButton
}
</script>
