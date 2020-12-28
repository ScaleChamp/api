<template>
  <div id="edit-instance">
    <LoadingTab v-if="loading"/>
    <template v-else-if="queryPlansError">{{ queryPlansError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('plans.upgrade_plan') }}</h1>
      <div class="space-y-4">
        <h2>1. {{ $t('choose_version') }}</h2>
        <BaseSelect v-model="planId" class="bg-white">
          <option
            v-for="p in versions"
            :key="p.id"
            :value="p.id"
            :selected="p.id == planId">
            {{ p.version }}
          </option>
        </BaseSelect>
      </div>
      <div class="space-y-4">
        <h2>2. {{ $t('choose_cloud') }}</h2>
        <div class="flex flex-wrap -mx-2 w-full">
          <label
            v-for="p in clouds"
            :key="p.id"
            :class="`${p.cloud} block px-2 mb-4 text-center`">
            <input type="radio" :id="p.cloud" :value="p.id" v-model="planId" class="hidden" />
            <span class="transition ease-out duration-300 block rounded-sm h-40 w-40 cursor-pointer">
              <img
                :src="require(`@/assets/${p.cloud}.svg`)"
                :alt="$t(p.cloud)"
                :title="$t(p.cloud)"
                :class="providerClassNames(p.cloud)"
              />
            </span>
          </label>
        </div>
      </div>
      <div class="space-y-4">
        <h2>3. {{ $t('choose_region') }}</h2>
        <BaseSelect v-model="planId"
                    class="bg-white">
          <optgroup v-for="(value, key) in regions" :key="key" :label="$t(key)" >
            <option
              v-for="p in value"
              :value="p.id"
              :key="p.id"
              :selected="p.id == planId">
              {{ $t(p.region) }}
            </option>
          </optgroup>
        </BaseSelect>
      </div>

      <div class="space-y-4">
        <h2>3.1. {{ $t('choose_placement') }}</h2>
        <BaseSelect v-model="placement" class="bg-white">
          <option :value="{ virtualNetworkId: undefined }">{{  $t('default') }}</option>
          <option v-for="network in networks" :key="network.id" :value="{ virtualNetworkId: network.id }">VPC {{ network.id }}</option>
        </BaseSelect>
      </div>

      <div class="space-y-4">
        <h2>4. {{ $t('choose_plan') }}</h2>
        <div class="flex -mx-2">
          <div class="w-1/2 px-2 space-y-2">
            <div :class="classIfSelected(1)">
              <div class="text-xl font-semibold">
                {{ $t('plans.personal.title') }}
              </div>
              <p v-html="$t('plans.personal.desc')" />
              <BaseSelect v-model="planId"
                          class="bg-white"
                          :border="isTwoNodePlan ? '' : 'border-primary'"
                          :class="{ 'text-gray-500': isTwoNodePlan }">
                <option :value="plan.id"
                        :disabled="true"
                        :selected="isTwoNodePlan"
                        :key="plan.id"
                        v-if="isTwoNodePlan">
                  {{ $t('plans.business.choosen') }}
                </option>
                <option v-for="p in personal"
                        :value="p.id" :key="p.id">
                  {{ p.name }} - {{ p.vcpus }} vCPU / {{ p.memory | readableBytes }} RAM / {{ p.disk }} GB Disk
                </option>
              </BaseSelect>
            </div>
          </div>
          <div class="w-1/2 px-2 space-y-2">
            <div :class="classIfSelected(2)">
              <div class="text-xl font-semibold">
                {{ $t('plans.business.title') }}
              </div>
              <p v-html="$t('plans.business.desc')" />
              <BaseSelect v-model="planId"
                          class="bg-white"
                          :border="isOneNodePlan ? '' : 'border-primary'"
                          :class="{ 'text-gray-500': isOneNodePlan }">
                <option :value="plan.id"
                        :disabled="true"
                        :selected="isOneNodePlan"
                        :key="plan.id"
                        v-if="isOneNodePlan">
                  {{ $t('plans.personal.choosen') }}
                </option>
                <option v-for="p in business"
                        :value="p.id"
                        :key="p.id">
                  {{ p.name }} - {{ p.vcpus }} vCPU / {{ p.memory | readableBytes }} RAM / {{ p.disk }} GB Disk
                </option>
              </BaseSelect>
            </div>
          </div>
        </div>
        <span>
          <i18n tag="div"
                path="plans.support"
                class="pt-3 text-gray-500">
            <template #more>
              <router-link :to="{ name: 'support' }" class="text-primary">{{ $t('plans.more') }}</router-link>
            </template>
          </i18n>
        </span>
      </div>
      <section class="relative">
        <img src="@/assets/newspaper.svg" class="h-16 absolute top-0 right-0 m-6 inline" alt="">
        <div class="space-y-4">
          <h4 class="font-semibold text-4xl">{{ $t('instance_operation.summary') }}</h4>
          <ol class="text-lg list-decimal ml-5 space-y-2">
            <i18n tag="li" path="instance_operation.price">
              <template #kind>{{ $t(plan.kind) }}</template>
              <template #price><b>{{ plan.price | currency(3) }}</b></template>
              <template #monthly><b>{{ Math.round(plan.price * 720) | currency(0) }}</b></template>
            </i18n>
            <i18n tag="li" path="instance_operation.location">
              <template #kind>{{ $t(plan.kind) }}</template>
              <template #cloud><b>{{ $t(plan.cloud) }}</b></template>
              <template #region><b>{{ plan.region }}</b></template>
            </i18n>
            <i18n tag="li" path="instance_operation.configuration">
              <template #kind>{{ $t(plan.kind) }}</template>
              <template #vcpus><b>{{ plan.vcpus }} vCPU</b></template>
              <template #memory><b>{{ plan.memory | readableBytes }} RAM</b></template>
              <template #disk><b>{{ plan.disk }} GB Disk Space</b></template>
            </i18n>
            <i18n tag="li" path="instance_operation.topology">
              <template #kind>{{ $t(plan.kind) }}</template>
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

      <BaseButton class="disabled:bg-gray-300 bg-green-400 hover:bg-green-500 text-white focus:shadow-outline"
                  :disabled="this.instance.plan.id === plan.id"
                  :is-loading="isUpgradeInstanceLoading"
                  @click="upgrade">
        <i18n path="instance_operation.upgrade">
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
import calculator from '@/mixins/calculator'

export default {
  mixins: [calculator],
  data () {
    return {
      error: null,
      loading: false,
      planId: null,
      placement: null // initialize with data from instance cloudProfileId and virtualNetworkid
    }
  },
  computed: {
    ...mapGetters('plans', ['byKind', 'searchTree']),
    ...mapState('instance', [
      'instance',
      'isUpgradeInstanceLoading'
    ]),
    ...mapState('networks', [
      'networks',
      'queryNetworksError',
      'isQueryNetworksLoading'
    ]),
    ...mapState('plans', [
      'plans',
      'queryPlansError'
    ])
  },
  watch: {
    planId (newPlanId, oldPlanId) {
      // check id belongings and depending on it set one id and null another
      // if (newPlanId !== oldPlanId && newPlanId !== this.$route.query.plan) {
      //   this.$router.replace({ query: { plan: this.planId } })
      // }
    }
  },
  methods: {
    ...mapActions({
      queryNetworks: 'networks/queryNetworks',
      pollNetworks: 'networks/pollNetworks',
      queryPlans: 'plans/queryPlans',
      upgradeInstance: 'instance/upgradeInstance',
      queryInstance: 'instance/queryInstance'
    }),
    async upgrade () {
      try {
        const { projectId, id } = this.$route.params
        const request = {
          plan_id: this.plan.id,
          id,
          projectId,
          virtual_network_id: this.placement.virtualNetworkId
        }
        await this.upgradeInstance(request)
        this.$router.replace({
          name: 'settings',
          params: { id, projectId }
        })
      } catch (err) {
        this.error = err?.response?.data ?? err
      }
    }
  },
  async created () {
    const { id, projectId } = this.$route.params
    this.loading = true
    try {
      await Promise.all([
        this.queryInstance({ id, projectId }),
        this.queryPlans(),
        this.queryNetworks({ projectId: this.$route.params.projectId })
      ])
      this.placement = {
        virtualNetworkId: this.instance.virtual_network_id,
      }
      this.planId = this.instance.plan.id
    } finally {
      this.loading = false
    }
  }
}
</script>
