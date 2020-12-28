<template>
  <div id="billing">
    <LoadingTab v-if="loading"/>
    <template v-else-if="queryHistoryError">{{ queryHistoryError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('project_billing.title') }}</h1>
      <div class="flex items-center space-x-4">
        <section class="space-y-4 w-1/2">
          <h2>{{ $t('project_billing.project_balance') }}</h2>
          <p class="long-and-truncated" :title="$t('project_billing.project_balance_info')">{{ $t('project_billing.project_balance_info') }}</p>
          <div class="text-4xl">{{ project.credit === 0 ? 0 : -project.credit | currency(2) }}</div>
        </section>
        <section class="space-y-4 w-1/2">
          <h2>{{ $t('project_billing.current_usage') }}</h2>
          <p class="long-and-truncated" :title="$t('project_billing.current_usage_info')">{{ $t('project_billing.current_usage_info') }}</p>
          <div class="text-4xl">{{ project.usage.toFixed(3) | currency(2) }}</div>
        </section>
      </div>
      <section class="space-y-4" v-if="ownerOrAccountant">
        <h2>{{ $t('project_billing.fill_balance') }}</h2>
        <div class="flex space-x-5 w-full">
          <div class="w-full">
            <BaseInput
              v-model.number="$v.amount.$model"
              :danger="$v.amount.$error"
              prefix="$"
              class="block"
            />
            <VuelidateError v-if="$v.amount.$error">
              <template v-if="!$v.amount.required">{{ $t('project_billing.fill_balance_amount_required') }}</template>
              <template v-if="!$v.amount.minValue">{{ $t('project_billing.fill_balance_amount_greater') }}</template>
            </VuelidateError>
            <span class="text-sm font-semibold text-gray-500" v-else>{{ $t('project_billing.fill_balance_amount_greater') }}</span>
          </div>
          <BaseButton
            @click="checkoutPaddle"
            :is-loading="pay"
            :disabled="$v.amount.$invalid"
            class="bg-primary text-white disabled:bg-gray-300">
            {{ $t('project_billing.pay') }}
          </BaseButton>
        </div>
      </section>

      <section class="space-y-4" v-if="ownerOrAccountant">
        <h2>{{ $t('project_billing.charge_currency') }}</h2>
        <div class="flex justify-between">
          <i18n tag="p" path="project_billing.charge_currency_info">
            <template #break>
              <br>
            </template>
          </i18n>
          <div class="w-1/3">
            <BaseSelect :value="project.currency" @change="updateProjectCurrency">
              <option v-for="cur in currencies" :value="cur" :key="cur">
                {{ $t(cur) }}
              </option>
            </BaseSelect>
          </div>
        </div>
      </section>

      <div class="space-y-4" v-if="ownerOrAccountant">
        <h2>{{ $t('project_billing.history') }}</h2>
        <BaseTable>
          <thead class="bg-gray-100 text-gray-800">
          <tr>
            <th>{{ $t('project_billing.history_date') }}</th>
            <th>{{ $t('project_billing.history_description') }}</th>
            <th>{{ $t('project_billing.history_amount') }}</th>
            <th />
          </tr>
          </thead>
          <tbody>
          <tr v-for="log in history" :key="log.id">
            <td>{{ $d(new Date(log.created_at), 'long') }}</td>
            <td>
              {{ $t(log.metadata.description) }}
            </td>
            <td class="font-semibold">
              <span v-if="log.data.amount != 0"
                    class="text-white rounded-full px-2"
                    :class="{
                      'bg-green-500': log.data.amount > 0,
                      'bg-red-500': log.data.amount < 0
                    }">
                {{ log.data.amount > 0 ? '' : '-' }}{{ Math.abs(log.data.amount) | currency(2) }}
              </span>
            </td>
            <td />
          </tr>
          </tbody>
        </BaseTable>
        <Pagination :page="page" :links="links" name="billing"/>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex'
import parseLinkHeader from 'parse-link-header'
import { minValue, required } from 'vuelidate/lib/validators'

const currencies = Object.freeze([
  'ars',
  'aud',
  'gbp',
  'cad',
  'czk',
  'dkk',
  'eur',
  'hkd',
  'huf',
  'inr',
  'jpy',
  'mxn',
  'twd',
  'nzd',
  'nok',
  'pln',
  'rub',
  'sgd',
  'krw',
  'sek',
  'chf',
  'thb',
  'usd'
])

const amount = 5

export default {
  data () {
    return {
      currencies,
      loading: false,
      links: null,
      page: 1,
      pay: false,
      card: null,
      amount
    }
  },
  computed: {
    ...mapGetters('project', ['ownerOrAccountant']),
    ...mapState('paddle', [
      'isGeneratePayLinkLoading',
      'generatePayLinkError',
      'isPaddleCheckoutErrorLoading',
      'paddleCheckoutError'
    ]),
    ...mapState('history', ['history', 'queryHistoryError']),
    ...mapState('project', ['project'])
  },
  validations: {
    amount: {
      required,
      minValue: minValue(amount)
    }
  },
  methods: {
    ...mapActions({
      queryHistory: 'history/queryHistory',
      pollHistory: 'history/pollHistory',
      pollProject: 'project/pollProject',
      updateProject: 'project/updateProject',
      paddleCheckout: 'paddle/paddleCheckout',
      generatePayLink: 'paddle/generatePayLink'
    }),
    async checkoutPaddle () {
      if (this.$v.$anyError) {
        this.$ga.event({
          eventCategory: 'billing',
          eventAction: 'typo',
        })
        return
      }

      const { projectId } = this.$route.params
      try {
        this.pay = true
        this.$ga.event({
          eventCategory: 'billing',
          eventAction: 'try',
          eventValue: this.amount
        })
        const { headers: { location } } = await this.generatePayLink({
          projectId,
          amount: this.amount
        })
        const { checkout: { id } } = await this.$paddle.open(location, () => {
          this.pay = false
        })
        await this.paddleCheckout({
          projectId,
          id
        })
        this.$ga.event({
          eventCategory: 'billing',
          eventAction: 'complete',
          eventValue: this.amount
        })
        await Promise.all([
          this.pollProject({ id: projectId }),
          this.pollHistory(Object.assign({ projectId }, this.$route.query))
        ])
      } catch (err) {
        this.$ga.event({
          eventCategory: 'billing',
          eventAction: 'failed',
          eventValue: this.amount
        })
      } finally {
        this.pay = false
        this.amount = 0
        this.$v.$reset()
      }
    },
    async updateProjectCurrency (event) {
      try {
        this.$ga.event({
          eventCategory: 'currency',
          eventAction: 'tried',
          eventLabel: event.target.value
        })
        await this.updateProject({
          id: this.$route.params.projectId,
          currency: event.target.value
        })
        this.$ga.event({
          eventCategory: 'currency',
          eventAction: 'changed',
          eventLabel: event.target.value
        })
      } catch (err) {
        this.$ga.event({
          eventCategory: 'currency',
          eventAction: 'failed',
          eventLabel: event.target.value
        })
      }
    }
  },
  watch: {
    '$route.query.page': {
      async handler () {
        const { headers } = await this.pollHistory(Object.assign({}, this.$route.query, {
          projectId: this.$route.params.projectId
        }))
        this.page = this.$route.query.page || 1
        this.links = parseLinkHeader(headers.link)
      }
    }
  },
  async created () {
    try {
      this.loading = true
      const { projectId } = this.$route.params
      const [{ headers }] = await Promise.all([
        this.queryHistory(Object.assign({}, this.$route.query, {
          projectId
        })),
        this.pollProject({ id: projectId })
      ])
      this.page = this.$route.query.page || 1
      this.links = parseLinkHeader(headers.link)
    } finally {
      this.loading = false
    }
  }
}
</script>
