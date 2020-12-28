<template>
  <transition name="fade" mode="out-in" v-bind="$attrs" v-on="$listeners">
    <slot/>
  </transition>
</template>
