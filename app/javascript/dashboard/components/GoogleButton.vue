<template>
  <BaseButton v-bind="$attrs"
              v-on="$listeners"
              class="transition w-full duration-300 ease-in-out flex items-center justify-center space-x-4 border text-blue-700 border-blue-700 hover:bg-primary hover:border-primary hover:text-white">
    <div class="rounded p-1 -mr-1 bg-white -mt-1 -mb-1" style="width: calc(24px + 0.5rem)">
      <img alt="Google" src="@/assets/google.svg" class="w-full h-full"/>
    </div>
    <span>
      <slot/>
    </span>
  </BaseButton>
</template>
