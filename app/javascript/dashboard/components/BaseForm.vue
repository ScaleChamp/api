<template>
  <form v-on="$listeners" v-bind="$attrs" class="space-y-4">
    <slot/>
    <input type="submit" class="hidden">
  </form>
</template>
