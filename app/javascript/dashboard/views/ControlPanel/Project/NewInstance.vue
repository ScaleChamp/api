<template>
  <div id="new-instance">
    <LoadingTab v-if="loading"/>
    <template v-else-if="queryPlansError">{{ queryPlansError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('create_service') }} </h1>
      <div class="space-y-4">
        <h2 class="relative">
          1. {{ $t('choose_kind') }}
          <span :title="$t('new_instance_page.kind_of_db')" />
        </h2>
        <div class="flex flex-wrap -mx-2 w-full">
          <label v-for="p in kinds" :key="p.id" class="block text-center px-2 mb-4">
            <input
              type="radio"
              :value="p.id"
              v-model="planId"
              class="hidden"
            />
            <span class="transition ease-out duration-300 block rounded-sm w-40 h-40 cursor-pointer flex flex-col space-y-4">
            <svg v-if="p.kind === 'redis'" class="h-20" viewBox="0 0 256 220" preserveAspectRatio="xMinYMin meet"><path d="M245.97 168.943c-13.662 7.121-84.434 36.22-99.501 44.075-15.067 7.856-23.437 7.78-35.34 2.09-11.902-5.69-87.216-36.112-100.783-42.597C3.566 169.271 0 166.535 0 163.951v-25.876s98.05-21.345 113.879-27.024c15.828-5.679 21.32-5.884 34.79-.95 13.472 4.936 94.018 19.468 107.331 24.344l-.006 25.51c.002 2.558-3.07 5.364-10.024 8.988" fill="#912626"/><path d="M245.965 143.22c-13.661 7.118-84.431 36.218-99.498 44.072-15.066 7.857-23.436 7.78-35.338 2.09-11.903-5.686-87.214-36.113-100.78-42.594-13.566-6.485-13.85-10.948-.524-16.166 13.326-5.22 88.224-34.605 104.055-40.284 15.828-5.677 21.319-5.884 34.789-.948 13.471 4.934 83.819 32.935 97.13 37.81 13.316 4.881 13.827 8.9.166 16.02" fill="#C6302B"/><path d="M245.97 127.074c-13.662 7.122-84.434 36.22-99.501 44.078-15.067 7.853-23.437 7.777-35.34 2.087-11.903-5.687-87.216-36.112-100.783-42.597C3.566 127.402 0 124.67 0 122.085V96.206s98.05-21.344 113.879-27.023c15.828-5.679 21.32-5.885 34.79-.95C162.142 73.168 242.688 87.697 256 92.574l-.006 25.513c.002 2.557-3.07 5.363-10.024 8.987" fill="#912626"/><path d="M245.965 101.351c-13.661 7.12-84.431 36.218-99.498 44.075-15.066 7.854-23.436 7.777-35.338 2.087-11.903-5.686-87.214-36.112-100.78-42.594-13.566-6.483-13.85-10.947-.524-16.167C23.151 83.535 98.05 54.148 113.88 48.47c15.828-5.678 21.319-5.884 34.789-.949 13.471 4.934 83.819 32.933 97.13 37.81 13.316 4.88 13.827 8.9.166 16.02" fill="#C6302B"/><path d="M245.97 83.653c-13.662 7.12-84.434 36.22-99.501 44.078-15.067 7.854-23.437 7.777-35.34 2.087-11.903-5.687-87.216-36.113-100.783-42.595C3.566 83.98 0 81.247 0 78.665v-25.88s98.05-21.343 113.879-27.021c15.828-5.68 21.32-5.884 34.79-.95C162.142 29.749 242.688 44.278 256 49.155l-.006 25.512c.002 2.555-3.07 5.361-10.024 8.986" fill="#912626"/><path d="M245.965 57.93c-13.661 7.12-84.431 36.22-99.498 44.074-15.066 7.854-23.436 7.777-35.338 2.09C99.227 98.404 23.915 67.98 10.35 61.497-3.217 55.015-3.5 50.55 9.825 45.331 23.151 40.113 98.05 10.73 113.88 5.05c15.828-5.679 21.319-5.883 34.789-.948 13.471 4.935 83.819 32.934 97.13 37.811 13.316 4.876 13.827 8.897.166 16.017" fill="#C6302B"/><path d="M159.283 32.757l-22.01 2.285-4.927 11.856-7.958-13.23-25.415-2.284 18.964-6.839-5.69-10.498 17.755 6.944 16.738-5.48-4.524 10.855 17.067 6.391M131.032 90.275L89.955 73.238l58.86-9.035-17.783 26.072M74.082 39.347c17.375 0 31.46 5.46 31.46 12.194 0 6.736-14.085 12.195-31.46 12.195s-31.46-5.46-31.46-12.195c0-6.734 14.085-12.194 31.46-12.194" fill="#FFF"/><path d="M185.295 35.998l34.836 13.766-34.806 13.753-.03-27.52" fill="#621B1C"/><path d="M146.755 51.243l38.54-15.245.03 27.519-3.779 1.478-34.791-13.752" fill="#9A2928"/></svg>
            <svg v-else-if="p.kind === 'pg'" class="h-20" viewBox="0 0 433 446" xmlns="http://www.w3.org/2000/svg">
              <g fill="none" fill-rule="evenodd">
                <path d="M323.205 324.227c2.833-23.6 1.984-27.062 19.563-23.239l4.463.392c13.517.615 31.199-2.174 41.587-7 22.362-10.376 35.622-27.7 13.572-23.148-50.297 10.376-53.755-6.655-53.755-6.655 53.111-78.803 75.313-178.836 56.149-203.322C352.514-5.534 262.036 26.05 260.522 26.87l-.482.09c-9.938-2.063-21.06-3.295-33.554-3.497-22.761-.374-40.032 5.967-53.133 15.904 0 0-161.408-66.498-153.899 83.628 1.597 31.936 45.777 241.655 98.47 178.31 19.259-23.163 37.871-42.748 37.871-42.748 9.242 6.14 20.307 9.272 31.912 8.147l.897-.765c-.281 2.876-.157 5.69.359 9.02-13.572 15.166-9.584 17.83-36.723 23.415-27.457 5.66-11.326 15.734-.797 18.367 12.768 3.193 42.305 7.716 62.268-20.224l-.795 3.188c5.325 4.26 4.965 30.62 5.72 49.452.756 18.834 2.017 36.41 5.856 46.771 3.839 10.36 8.369 37.05 44.036 29.406 29.809-6.388 52.6-15.582 54.677-101.107" fill="#000" fill-rule="nonzero" stroke="#000" stroke-width="37.395"/>
                <path d="m402.4 271.23c-50.302 10.376-53.76-6.655-53.76-6.655 53.111-78.808 75.313-178.84 56.153-203.33-52.27-66.785-142.75-35.2-144.26-34.38l-0.486 0.087c-9.938-2.063-21.06-3.292-33.56-3.496-22.761-0.373-40.026 5.967-53.127 15.902 0 0-161.41-66.495-153.9 83.63 1.597 31.938 45.776 241.66 98.471 178.31 19.26-23.163 37.869-42.748 37.869-42.748 9.243 6.14 20.308 9.272 31.908 8.147l0.901-0.765c-0.28 2.876-0.152 5.69 0.361 9.02-13.575 15.166-9.586 17.83-36.723 23.415-27.459 5.66-11.328 15.734-0.796 18.367 12.768 3.193 42.307 7.716 62.266-20.224l-0.796 3.188c5.319 4.26 9.054 27.711 8.428 48.97-0.626 21.258-1.044 35.853 3.147 47.253s8.368 37.05 44.042 29.406c29.809-6.388 45.256-22.942 47.405-50.555 1.525-19.63 4.976-16.729 5.194-34.28l2.768-8.309c3.192-26.61 0.507-35.196 18.872-31.203l4.463 0.392c13.517 0.615 31.208-2.174 41.591-7 22.358-10.376 35.618-27.7 13.573-23.148h2e-3z" fill="#336791" fill-rule="nonzero"/>
                <path d="m215.87 286.48c-1.385 49.516 0.348 99.377 5.193 111.5 4.848 12.118 15.223 35.688 50.9 28.045 29.806-6.39 40.651-18.756 45.357-46.05 3.466-20.083 10.148-75.855 11.005-87.282m-155.22-254.44s-161.52-66.016-154.01 84.11c1.597 31.937 45.779 241.66 98.473 178.32 19.256-23.166 36.671-41.335 36.671-41.335m106.11-233.14c-5.591 1.753 89.848-34.889 144.09 34.417 19.159 24.484-3.043 124.52-56.153 203.33" stroke="#FFF" stroke-linecap="round" stroke-linejoin="round" stroke-width="12.465"/>
                <path d="m348.28 263.95s3.461 17.036 53.764 6.653c22.04-4.552 8.776 12.774-13.577 23.155-18.345 8.514-59.474 10.696-60.146-1.069-1.729-30.355 21.647-21.133 19.96-28.739-1.525-6.85-11.979-13.573-18.894-30.338-6.037-14.633-82.796-126.85 21.287-110.18 3.813-0.789-27.146-99.002-124.55-100.6-97.385-1.597-94.19 119.76-94.19 119.76" stroke="#FFF" stroke-linecap="round" stroke-linejoin="bevel" stroke-width="12.465"/>
                <path d="m188.6 274.33c-13.577 15.166-9.584 17.83-36.723 23.417-27.459 5.66-11.326 15.733-0.797 18.365 12.768 3.195 42.307 7.718 62.266-20.229 6.078-8.509-0.036-22.086-8.385-25.547-4.034-1.67-9.428-3.765-16.361 3.994h0z" stroke="#FFF" stroke-linecap="round" stroke-linejoin="round" stroke-width="12.465"/>
                <path d="m187.72 274.07c-1.368-8.918 2.93-19.529 7.536-31.943 6.922-18.626 22.893-37.255 10.117-96.339-9.523-44.029-73.396-9.163-73.436-3.193-0.039 5.968 2.889 30.26-1.067 58.548-5.162 36.913 23.488 68.132 56.479 64.938" stroke="#FFF" stroke-linecap="round" stroke-linejoin="round" stroke-width="12.465"/>
                <path d="M172.517 141.7c-.288 2.04 3.733 7.48 8.976 8.207 5.234.73 9.714-3.522 9.998-5.559.284-2.039-3.732-4.285-8.977-5.015-5.237-.73-9.719.333-9.996 2.367h-.001z" fill="#FFF" fill-rule="nonzero" stroke="#FFF" stroke-width="4.155"/>
                <path d="m331.94 137.54c0.284 2.04-3.732 7.48-8.976 8.207-5.238 0.73-9.718-3.522-10.005-5.559-0.277-2.039 3.74-4.285 8.979-5.015s9.718 0.333 10.002 2.368v-1e-3z" fill="#FFF" fill-rule="nonzero" stroke="#FFF" stroke-width="2.078"/>
                <path d="m350.68 123.43c0.863 15.994-3.445 26.888-3.988 43.914-0.804 24.748 11.799 53.074-7.191 81.435" stroke="#FFF" stroke-linecap="round" stroke-linejoin="round" stroke-width="12.465"/>
              </g>
            </svg>
            <img v-else-if="p.kind === 'keydb'" src="@/assets/keydb.png" class="h-20" alt="">
            <span v-else-if="p.kind === 'keydb-pro'" class="relative">
              <img src="@/assets/keydb.png" class="h-20" alt="">
              <span class="absolute top-0 font-semibold text-black right-0 -mt-2 -mr-2 text-xs">PRO</span>
            </span>
            <svg v-else-if="p.kind === 'mysql'"
                 class="w-20"
                 viewBox="0 0 256 252"
                 preserveAspectRatio="xMinYMin meet">
              <path d="M235.648 194.212c-13.918-.347-24.705 1.045-33.752 4.872-2.61 1.043-6.786 1.044-7.134 4.35 1.392 1.392 1.566 3.654 2.784 5.567 2.09 3.479 5.741 8.177 9.047 10.614 3.653 2.783 7.308 5.566 11.134 8.002 6.786 4.176 14.442 6.611 21.053 10.787 3.829 2.434 7.654 5.568 11.482 8.177 1.914 1.39 3.131 3.654 5.568 4.523v-.521c-1.219-1.567-1.567-3.828-2.784-5.568-1.738-1.74-3.48-3.306-5.22-5.046-5.045-6.784-11.308-12.7-18.093-17.571-5.567-3.828-17.747-9.047-20.008-15.485 0 0-.175-.173-.348-.347 3.827-.348 8.35-1.74 12.005-2.784 5.915-1.567 11.308-1.218 17.398-2.784 2.783-.696 5.567-1.566 8.35-2.436v-1.565c-3.13-3.132-5.392-7.307-8.698-10.265-8.873-7.657-18.617-15.137-28.707-21.4-5.394-3.48-12.354-5.742-18.095-8.699-2.086-1.045-5.567-1.566-6.784-3.306-3.133-3.827-4.873-8.872-7.134-13.396-5.044-9.57-9.917-20.182-14.267-30.272-3.13-6.786-5.044-13.572-8.872-19.834-17.92-29.577-37.406-47.497-67.33-65.07-6.438-3.653-14.093-5.219-22.27-7.132-4.348-.175-8.699-.522-13.048-.697-2.784-1.218-5.568-4.523-8.004-6.089C34.006 4.573 8.429-8.996 1.122 8.924c-4.698 11.308 6.96 22.442 10.96 28.185 2.96 4.001 6.786 8.524 8.874 13.048 1.218 2.956 1.565 6.09 2.783 9.221 2.785 7.653 5.393 16.18 9.048 23.314 1.914 3.653 4.001 7.48 6.437 10.786 1.392 1.913 3.827 2.784 4.35 5.915-2.435 3.48-2.61 8.7-4.003 13.049-6.263 19.66-3.826 44.017 5.046 58.457 2.783 4.348 9.395 13.92 18.268 10.265 7.83-3.131 6.09-13.048 8.35-21.747.524-2.09.176-3.48 1.219-4.872v.349c2.436 4.87 4.871 9.569 7.133 14.44 5.394 8.524 14.788 17.398 22.617 23.314 4.177 3.13 7.482 8.524 12.702 10.438v-.523h-.349c-1.044-1.566-2.61-2.261-4.001-3.48-3.131-3.13-6.612-6.958-9.047-10.438-7.306-9.744-13.745-20.53-19.486-31.665-2.783-5.392-5.22-11.308-7.481-16.701-1.045-2.09-1.045-5.22-2.784-6.263-2.61 3.827-6.437 7.133-8.351 11.83-3.304 7.481-3.653 16.702-4.871 26.27-.696.176-.349 0-.697.35-5.566-1.394-7.48-7.134-9.569-12.006-5.22-12.352-6.09-32.186-1.565-46.452 1.218-3.654 6.438-15.136 4.35-18.616-1.044-3.306-4.525-5.22-6.438-7.829-2.261-3.306-4.698-7.48-6.263-11.135-4.176-9.743-6.264-20.53-10.787-30.273-2.088-4.524-5.74-9.22-8.699-13.396-3.305-4.697-6.959-8.004-9.569-13.571-.869-1.913-2.088-5.045-.696-7.133.348-1.392 1.043-1.913 2.436-2.261 2.262-1.915 8.7.521 10.96 1.565 6.438 2.608 11.831 5.046 17.225 8.699 2.435 1.74 5.045 5.046 8.176 5.916h3.654c5.568 1.217 11.83.348 17.05 1.913 9.222 2.957 17.572 7.307 25.054 12.005 22.792 14.44 41.58 34.97 54.282 59.501 2.088 4 2.957 7.656 4.871 11.83 3.655 8.526 8.178 17.225 11.83 25.576 3.654 8.176 7.133 16.528 12.353 23.314 2.61 3.652 13.048 5.567 17.746 7.481 3.48 1.565 8.874 2.958 12.005 4.871 5.915 3.652 11.83 7.83 17.398 11.83 2.784 2.088 11.482 6.438 12.005 9.917z" fill="#00546B"/><path d="M58.186 43.022c-2.957 0-5.044.35-7.132.871v.348h.348c1.393 2.784 3.827 4.698 5.566 7.133 1.393 2.783 2.61 5.568 4.003 8.352.173-.175.347-.348.347-.348 2.437-1.741 3.654-4.524 3.654-8.7-1.044-1.217-1.218-2.435-2.088-3.653-1.043-1.741-3.306-2.61-4.698-4.003z" fill="#00546B"/>
            </svg>
            <span>{{ $t(p.kind) }}</span>
          </span>
          </label>
        </div>
        <template v-if="plan.kind == 'keydb-pro'">
          <div class="space-y-2">
            <h3 class="text-lg">
              {{ $t('write_license_key') }}
              <span :title="$t('new_instance_page.license_key_title')" />
            </h3>
            <BaseInput
              v-model="licenseKey"
              type="text"
              :danger="$v.licenseKey.$error"
              :placeholder="$t('paste_license')"
              @hook:beforeDestroy="$v.licenseKey.$reset"
              @blur="$v.licenseKey.$touch"
            />
            <VuelidateError v-if="$v.licenseKey.$error">
              <template v-if="!$v.licenseKey.required">{{ $t('plans.license_key_required') }}</template>
            </VuelidateError>
          </div>
        </template>
      </div>
      <div class="space-y-4">
        <h2>2. {{ $t('choose_version') }}</h2>
        <BaseSelect v-model="planId" class="bg-white">
          <option v-for="p in versions" :key="p.id" :value="p.id" :selected="p.id == planId">{{ p.version }}</option>
        </BaseSelect>
      </div>
      <div class="space-y-4">
        <h2>3. {{ $t('choose_cloud') }}</h2>
        <div class="flex flex-wrap -mx-2 w-full">
          <label v-for="p in clouds" :key="p.id" :class="`${p.cloud} block px-2 mb-4 text-center`">
            <input type="radio"  class="hidden" v-model="planId" :id="p.cloud" :value="p.id" />
            <span class="transition ease-out duration-300 block rounded-sm h-40 w-40 cursor-pointer">
              <img
                :src="require(`@/assets/${p.cloud}.svg`)"
                :key="`${p.cloud}-logo`"
                :alt="$t(p.cloud)"
                :title="$t(p.cloud)"
                :class="providerClassNames(p.cloud)"
              />
            </span>
          </label>
        </div>
      </div>
      <div class="space-y-4">
        <h2>4. {{ $t('choose_region') }}</h2>
        <BaseSelect v-model="planId" class="bg-white">
          <optgroup v-for="(value, key) in regions" :key="key" :label="$t(key)">
            <option v-for="p in value" :key="p.id" :value="p.id" :selected="p.id == planId">{{ $t(p.region) }}</option>
          </optgroup>
        </BaseSelect>
      </div>

      <div class="space-y-4">
        <h2>4.1. {{ $t('choose_placement') }}</h2>
        <BaseSelect v-model="placement" class="bg-white">
          <option :value="{ virtualNetworkId: undefined }">{{ $t('default') }}</option>
          <option v-for="network in networks" :key="network.id" :value="{ virtualNetworkId: network.id }">VPC {{ network.id }}</option>
        </BaseSelect>
      </div>

      <div class="space-y-4">
        <h2>5. {{ $t('choose_plan') }} <span :title="$t('new_instance_page.plan_info')" /></h2>
        <div class="flex -mx-2">
          <div class="w-1/2 px-2 space-y-2">
            <div :class="classIfSelected(1)" class="transition ease-out duration-300">
              <div class="text-xl font-semibold">
                {{ $t('plans.personal.title') }}
              </div>
              <p v-html="$t('plans.personal.desc')" />
              <BaseSelect v-model="planId" class="bg-white" :class="{ 'text-gray-500': isTwoNodePlan }" :border="isTwoNodePlan ? '' : 'border-primary'">
                <option :value="plan.id"
                        :disabled="true"
                        :selected="isTwoNodePlan"
                        :key="plan.id"
                        v-if="isTwoNodePlan">
                  {{ $t('plans.business.choosen') }}
                </option>
                <option v-for="p in personal" :key="p.id" :value="p.id">
                  {{ p.name }} - {{ p.vcpus }} vCPU / {{ p.memory | readableBytes }} RAM / {{ p.disk }} GB Disk
                </option>
              </BaseSelect>
            </div>
          </div>
          <div class="w-1/2 px-2 space-y-2">
            <div :class="classIfSelected(2)" class="transition ease-out duration-300">
              <div class="text-xl font-semibold">
                {{ $t('plans.business.title') }}
              </div>
              <p v-html="$t('plans.business.desc')" />
              <BaseSelect v-model="planId" class="bg-white" :class="{ 'text-gray-500': isOneNodePlan }" :border="isOneNodePlan ? '' : 'border-primary'">
                <option :key="plan.id"
                        :value="plan.id"
                        :selected="isOneNodePlan"
                        :disabled="true"
                        v-if="isOneNodePlan">
                  {{  $t('plans.personal.choosen') }}
                </option>
                <option
                  v-for="p in business"
                  :key="p.id"
                  :value="p.id">
                  {{ p.name }} - {{ p.vcpus }} vCPU / {{ p.memory | readableBytes }} RAM / {{ p.disk }} GB Disk
                </option>
              </BaseSelect>
            </div>
          </div>
        </div>
        <span>
          <i18n tag="div" path="plans.support" class="pt-3 text-gray-500">
            <template #more>
              <router-link :to="{ name: 'support' }" class="text-primary">{{ $t('plans.more') }}</router-link>
            </template>
          </i18n>
        </span>
      </div>

      <div class="space-y-4">
        <h2>6. {{ $t('choose_instance_name') }}</h2>
        <BaseInput v-model="$v.name.$model"
                   type="text"
                   :placeholder="$t('instance_name')"
                   :danger="$v.name.$error"
                   @blur="$v.name.$touch"
        />
        <VuelidateError v-if="$v.name.$error">
          <template v-if="!$v.name.required">{{ $t('instance_name_required') }}</template>
        </VuelidateError>
      </div>

    <section class="relative">
        <img src="@/assets/newspaper.svg" class="h-16 absolute top-0 right-0 m-6 inline" alt="">
        <div class="space-y-4">
          <h4 class="font-semibold text-4xl">{{ $t('instance_operation.summary') }}</h4>
          <ol class="text-lg list-decimal ml-5 space-y-2">
            <i18n tag="li" path="instance_operation.price">
              <template #kind>
                {{ $t(plan.kind) }} {{ plan.version }}
              </template>
              <template #price>
                <b>{{ plan.price | currency(3) }}</b>
              </template>
              <template #monthly>
                <b>{{ Math.round(plan.price * 720) | currency(0) }}</b>
              </template>
            </i18n>
            <i18n tag="li" path="instance_operation.location">
              <template #kind>{{ $t(plan.kind) }} {{ plan.version }}</template>
              <template #cloud><b>{{ $t(plan.cloud) }}</b></template>
              <template #region><b>{{ plan.region }}</b></template>
            </i18n>
            <i18n tag="li" path="instance_operation.configuration">
              <template #kind>{{ $t(plan.kind) }} {{ plan.version }}</template>
              <template #vcpus><b>{{ plan.vcpus }} vCPU</b></template>
              <template #memory><b>{{ plan.memory | readableBytes }} RAM</b></template>
              <template #disk><b>{{ plan.disk }} GB Disk Space</b></template>
            </i18n>
            <i18n tag="li" path="instance_operation.topology">
              <template #kind>{{ $t(plan.kind) }} {{ plan.version }}</template>
              <template #topology>
                <b v-if="plan.nodes > 1">{{ $t('new_instance_page.cluster', plan)  }}</b>
                <b v-else>{{ $t('new_instance_page.standalone') }}</b>
              </template>
            </i18n>
            <li v-html="$t('instance_operation.billing')"></li>
            <li v-html="$t('instance_operation.anytime')"></li>
          </ol>
        </div>
      </section>

      <div class="text-red-500 border border-red-500 bg-red-100 p-4 rounded-sm" v-if="error">
        <span>{{ $t(error.message) }}</span>
      </div>

      <BaseButton @click="createInstanceAndRedirect"
                  :disabled="isCreateInstanceLoading || $v.$invalid"
                  :is-loading="isCreateInstanceLoading"
                  :class="{ 'disabled:bg-gray-300': $v.$invalid, 'hover:bg-green-500': !isCreateInstanceLoading }"
                  class="bg-green-400 text-white focus:shadow-outline">
        <i18n path="instance_operation.create">
          <template #price>
            {{ plan.price | currency(3) }}
          </template>
        </i18n>
      </BaseButton>
    </template>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapState } from 'vuex'
import { required, requiredIf } from 'vuelidate/lib/validators'
import calculator from '@/mixins/calculator'

export default {
  mixins: [calculator],
  data () {
    return {
      planId: null,
      placement: { virtualNetworkId: undefined },
      loading: false,
      error: null,
      name: '',
      licenseKey: ''
    }
  },
  watch: {
    planId (newPlanId, oldPlanId) {
      // check id belongings and depending on it set one id and null another
      if (newPlanId !== oldPlanId && newPlanId !== this.$route.query.plan) {
        this.$router.replace({ query: { plan: this.planId } })
      }
    }
  },
  validations: {
    name: {
      required
    },
    licenseKey: {
      required: requiredIf(model => model.plan.kind === 'keydb-pro')
    }
  },
  computed: {
    ...mapState('instance', [
      'instance',
      'isCreateInstanceLoading',
      'createInstanceError'
    ]),
    ...mapState('networks', [
      'networks',
      'queryNetworksError',
      'isQueryNetworksLoading'
    ]),
    ...mapState('plans', ['plans', 'queryPlansError']),
    ...mapGetters('plans', ['byKind', 'searchTree'])
  },
  methods: {
    ...mapActions({
      queryNetworks: 'networks/queryNetworks',
      pollNetworks: 'networks/pollNetworks',
      queryPlans: 'plans/queryPlans',
      createInstance: 'instance/createInstance'
    }),
    async createInstanceAndRedirect () {
      try {
        const { projectId } = this.$route.params
        const request = Object.assign({
          projectId,
          plan_id: this.plan.id,
          name: this.name,
          virtual_network_id: this.placement.virtualNetworkId
        })
        if (this.plan.kind === 'keydb-pro') {
          request['license_key'] = this.licenseKey
        }
        this.$ga.event({
          eventCategory: 'services',
          eventAction: 'create',
        })
        const { data: instance } = await this.createInstance(request)
        this.$ga.event({
          eventCategory: 'services',
          eventAction: 'created',
        })
        this.$router.push({ name: 'settings', params: { id: instance.id, projectId } })
      } catch (err) {
        this.$ga.event({
          eventCategory: 'services',
          eventAction: 'failed',
        })
        this.error = err?.response?.data ?? err
      }
    }
  },
  async created () {
    try {
      this.loading = true
      await Promise.all([
        this.queryPlans(),
        this.queryNetworks({ projectId: this.$route.params.projectId })
      ])
      const plan = this.plans.find(x => x.id === this.$route.query.plan)
      this.planId = plan?.id || this.plans[0].id
    } finally {
      this.loading = false
    }
  }
}
</script>
