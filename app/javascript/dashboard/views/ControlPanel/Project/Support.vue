<template>
  <div>
    <h1 class="text-4xl">{{ $t('support') }}</h1>
    <template v-if="done">
      <div class="flex items-center justify-between pixel-sorting py-6 px-6 rounded-sm shadow-lg banner">
        <p class="text-xl text-white font-semibold">
          {{ $t('support_page.info') }}
        </p>
        <BaseButton class="bg-white"
                    @click.prevent="done = false">
          {{ $t('support_page.action') }}
        </BaseButton>
      </div>
    </template>
    <BaseForm v-else @submit.prevent="createTicketAndRedirect">
      <p class="text-lg">{{ $t('support_page.info2') }}</p>
      <div class="space-y-2">
        <h3 class="text-xl">{{ $t('support_page.topic') }}</h3>
        <BaseSelect type="text"
                    v-model="topic">
          <option v-for="option in $t('support_page.topics')"
                  :key="option"
                  :value="option">
            {{ option }}
          </option>
        </BaseSelect>
      </div>
      <div class="space-y-2">
        <h3 class="text-xl">{{ $t('support_page.severity') }}</h3>
        <BaseSelect type="text"
                    v-model="severity">
          <option v-for="option in $t('support_page.severities')"
                  :key="option"
                  :value="option">
            {{ option }}
          </option>
        </BaseSelect>
      </div>
      <div class="space-y-2">
        <h3 class="text-xl">{{ $t('support_page.title') }}</h3>
        <BaseInput
          v-model.trim="$v.title.$model"
          type="text"
          :placeholder="$t('support_page.title')"
          :danger="$v.title.$error"
        />
        <VuelidateError v-if="$v.title.$error">
          <template v-if="!$v.title.required">{{ $t('support_page.title_required') }}</template>
        </VuelidateError>
      </div>
      <div class="space-y-2">
        <h3 class="text-xl">{{ $t('support_page.desc') }}</h3>
        <BaseTextarea
          v-model.trim="$v.description.$model"
          :placeholder="$t('support_page.desc')"
          :danger="$v.description.$error"
        />
        <VuelidateError v-if="$v.description.$error">
          <template v-if="!$v.description.required">{{ $t('support_page.desc_required') }}</template>
        </VuelidateError>
      </div>
      <div>
        <BaseButton class="inline bg-primary hover:bg-primary-100 text-white disabled:bg-gray-300"
                    :is-loading="isCreateTicketLoading"
                    :disabled="$v.$invalid"
                    type="submit">
          {{ $t('create_ticket') }}
        </BaseButton>
      </div>
    </BaseForm>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import { required } from 'vuelidate/lib/validators'

export default {
  data () {
    return {
      title: '',
      description: '',
      severity: this.$t('support_page.severities')[0],
      topic: this.$t('support_page.topics')[0],
      done: false
    }
  },
  validations: {
    title: {
      required
    },
    description: {
      required
    }
  },
  computed: mapState('support', [
    'isCreateTicketLoading',
    'createTicketError'
  ]),
  methods: {
    ...mapActions('support', [
      'createTicket'
    ]),
    async createTicketAndRedirect () {
      const params = {
        title: this.title,
        description: this.description,
        severity: this.severity
      }
      const data = new FormData()
      Object.entries(params).forEach(([key, value]) => data.append(key, value))
      await this.createTicket({
        projectId: this.$route.params.projectId,
        data
      })
      this.title = ''
      this.description = ''
      this.severity = this.$t('support_page.severities')[0]
      this.topic = this.$t('support_page.topics')[0]
      this.done = true
      this.$v.$reset()
    }
  }
}
</script>
