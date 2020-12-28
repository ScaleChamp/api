<template>
  <transition name="slide" mode="out-in" v-bind="$attrs" v-on="$listeners">
    <slot/>
  </transition>
</template>
