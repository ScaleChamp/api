<template>
  <BaseButton v-bind="$attrs"
              v-on="$listeners"
              class="transition w-full duration-300 ease-in-out flex items-center justify-center space-x-4 bg-blue-900 text-white hover:bg-gray-800">
    <Github fill="#fff" width="24"/>
    <span>
      <slot/>
    </span>
  </BaseButton>
</template>
