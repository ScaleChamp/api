<template>
  <router-view class="h-full w-full relative" />
</template>

<style lang="scss">
@tailwind base;
@tailwind components;
@tailwind utilities;

html, body {
  @apply h-full w-full p-0 m-0 overflow-hidden fixed box-border leading-normal font-sans text-gray-900 antialiased;
}
footer {
  a:hover {
    @apply text-primary-100;
  }
}
.rounded-circle {
  border-radius: 50%;
}
html {
  font-size: 14px;
}
@media only screen and (min-width: 1281px) {
  html {
    font-size: 16px;
  }
}
@media only screen and (min-width: 1920px) and (min-resolution: 192dpi) {
  html {
    font-size: 18px;
  }
}
.pixel-sorting {
  background-image: url("~@/assets/ScaleChamp11.jpg"),
    linear-gradient( 63deg, rgb(31,74,154) 0%, rgb(18,28,78) 37%, rgb(52,81,159) 72%, rgb(194,119,116) 100%);
  background-color: black;
}
.bg-error {
  background-image: url("~@/assets/pixer.jpg"),
    linear-gradient( -61deg, rgb(167,188,191) 0%, rgb(3,66,109) 35%, rgb(1,50,142) 71%, rgb(0,21,58) 100%);
}
#project {
  main > header {
    width: calc(100% - 16rem);
  }
  main {
    top: 0;
    left: 16rem;
    width: calc(100% - 16rem);
  }
  .nav-active, .nav-active:hover {
    @apply bg-gray-700;
  }
}
#user {
  .nav-active, .nav-active:hover {
    @apply text-primary;
  }
}
#instance {
  .active {
    @apply text-gray-900 border-b-2 border-primary;
  }
}
#new-instance, #edit-instance {
  h2 {
    @apply text-2xl;
  }
  label > input:checked + span {
    @apply bg-blue-100 border-primary-100 text-gray-800;
  }
  label > input + span {
    @apply border border-gray-400 text-gray-600 font-semibold flex items-center justify-center;
  }
  label:hover > input + span {
    @apply border-primary;
  }
  label.hetzner:hover > input + span {
    @apply border-red-400;
  }
  label.exoscale:hover > input + span {
    @apply border-red-400;
  }
  label.linode:hover > input + span {
    @apply border-green-400;
  }
  label.upcloud:hover > input + span {
    border-color: #7B00FF;
  }
  label.scw:hover > input + span {
    @apply border-purple-400;
  }
  label.aws:hover > input + span {
    @apply border-orange-400;
  }
  label.alibaba:hover > input + span {
    @apply border-orange-400;
  }
  label.hetzner > input:checked + span {
    @apply bg-red-100 border-red-400;
  }
  label.exoscale > input:checked + span {
    @apply bg-red-100 border-red-400;
  }
  label.linode > input:checked + span {
    @apply bg-green-100 border-green-400;
  }
  label.upcloud > input:checked + span {
    border-color: #7B00FF;
    @apply bg-indigo-100 text-primary;
  }
  label.aws > input:checked + span {
    @apply bg-orange-100 border-orange-400;
  }
  label.alibaba > input:checked + span {
    @apply bg-orange-100 border-orange-400;
  }
  label.scw > input:checked + span {
    @apply bg-purple-100 border-purple-400;
  }
  h2 > span:before {
    bottom: -2px;
    content: '?';
    display: inline-block;
    width: 1.1rem;
    height: 1.1rem;
    font-size: 0.8rem;
    line-height: 1rem;
    color: white;
    text-decoration: none;
    @apply bg-gray-400 text-white font-semibold rounded-full text-center absolute p-px;
  }
  h2 > span {
    @apply inline-block relative;
  }
}
td, th {
  @apply px-4 py-2;
}
th {
  @apply border-b border-gray-400;
}
tr {
  @apply border-b border-gray-400;
}
tr:last-of-type {
  @apply border-none;
}
table > thead {
  @apply bg-gray-100;
}
@variants focus {
  textarea.shadow-outline-red {
    box-shadow: 0 0 0 3px rgba(239, 87, 116, 0.25);
  }
  input.shadow-outline-red {
    box-shadow: 0 0 0 3px rgba(239, 87, 116, 0.25);
  }
}
.long-and-truncated {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  @apply pr-1;
}
.hide-and-show {
  animation: hide-and-show 1s linear infinite;
}
.illuminate {
  animation: illuminate 1s linear infinite;
}
@keyframes illuminate {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.95;
  }
}
@keyframes hide-and-show {
  0%, 100% {
    opacity: 1;
  }
  50%  {
    opacity: 0.5;
  }
}
.scale-and-scale {
  animation: scale-and-scale 1s infinite;
}
@keyframes scale-and-scale {
  0% {
    transform: scale(1.0);
  }
  50% {
    transform: scale(1.25);
  }
  100% {
    transform: scale(1.0);
  }
}
.base-button.is-loading {
  @apply relative text-transparent cursor-wait;
}
.base-button.is-loading::after {
  border: 3px solid white;
  width: 1.2em;
  height: 1.2em;
  border-radius: 50%;
  border-right-color: transparent;
  border-top-color: transparent;
  content: "";
  display: block;
  left: calc(50% - (1.2em / 2));
  top: calc(50% - (1.2em / 2));
  animation: spin 750ms infinite linear;
  position: absolute;
}
@keyframes spin {
  from {transform:rotate(0deg);}
  to {transform:rotate(360deg);}
}
.fade-enter,
.fade-leave-to {
  @apply opacity-0;
}
.fade-enter-active,
.fade-leave-active {
  @apply transition-opacity duration-200 ease-out;
}
.slide-enter,
.slide-leave-active {
  @apply opacity-0;
}
.slide-enter-active,
.slide-leave-active {
  @apply transition duration-200 ease-out;
}
.slide-enter,
.slide-leave-to {
  transform: translateY(-200px);
}
section {
  @apply border border-gray-400 py-6 px-6 rounded-sm;
}
.banner {
  background-position: 50% 30%;
  @apply bg-cover bg-no-repeat;
}
.circle-banner {
  background-position: 50% 40%;
}
#user-profile, #billing, #instance {
  h2 {
    @apply text-2xl;
  }
}
</style>
