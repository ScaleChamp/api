<template>
  <div class="space-y-8">
    <div class="space-y-8" v-if="wasEmpty || secureYourService">
      <div class="space-y-4">
        <h2 class="text-2xl font-semibold">{{ $t('whitelist.title') }}</h2>
        <p class="text-lg">{{ $t('whitelist.desc') }}</p>
      </div>
      <BaseTable>
        <thead class="bg-gray-100">
          <tr>
            <th>{{ $t('whitelist.source') }}</th>
            <th>{{ $t('whitelist.target_port') }}</th>
            <th>{{ $t('whitelist.protocol') }}</th>
            <th>{{ $t('whitelist.description') }}</th>
            <th />
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in $v.whitelist.$each.$iter" :key="index">
            <td>
              <BaseInput v-model.trim="item.ip.$model"
                         :danger="item.ip.$error"
                         class="border-gray-400"
                         :placeholder="$t('ipv4_or_6')"
              />
            </td>
            <td>{{ port }}</td>
            <td>TCP</td>
            <td>{{ $t('whitelist.traffic') }}</td>
            <td class="text-red-600 cursor-pointer"
                @click="removeEntry(index)">
              {{ $t('whitelist.delete') }}
            </td>
          </tr>
          <tr>
            <td>
              <span @click="addEntry" class="h-12 text-gray-500 flex items-center justify-center border border-gray-400 rounded-sm hover:cursor-pointer">
                {{ $t('whitelist.add_ip') }}
              </span>
            </td>
            <td/>
            <td/>
            <td/>
            <td/>
          </tr>
        </tbody>
      </BaseTable>
      <BaseButton :class="buttonDisabledClass"
                  @click="convertWhitelistAndUpgradeInstance"
                  class="bg-primary hover:bg-primary-100 text-white"
                  :is-loading="isEditFirewallInstanceLoading"
                  :disabled="!['running'].includes(instance.state)">
        {{ $t('apply') }}
      </BaseButton>
    </div>
    <section v-else
             class="flex items-center justify-between pixel-sorting shadow-lg banner">
      <div class="space-y-4 text-white">
        <p class="text-xl font-semibold">{{ $t('whitelist.desc') }}</p>
      </div>
      <BaseButton class="bg-white"
                  @click="secureYourService = true">
        {{ $t('whitelist.action') }}
      </BaseButton>
    </section>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import { required, helpers } from 'vuelidate/lib/validators'

const ipv4Address = helpers.regex('ipv4', /^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$/)

export default {
  data () {
    return {
      loading: false,
      entry: '0.0.0.0/0',
      whitelist: [],
      secureYourService: false,
      wasEmpty: false
    }
  },
  validations: {
    whitelist: {
      required,
      $each: {
        ip: {
          required,
          ipAddress: ipv4Address
        }
      }
    }
  },
  computed: {
    port () {
      switch (this.instance.kind) {
        case 'redis':
        case 'keydb':
        case 'keydb-pro':
          return 6379
        case 'pg':
          return 5432
        case 'mysql':
          return 3306
        default:
          return 0
      }
    },
    ...mapState('instance', [
      'instance',
      'isEditFirewallInstanceLoading'
    ]),
    buttonDisabledClass () {
      return {
        'cursor-not-allowed': this.instance.state === 'terminated',
        'cursor-wait': this.instance.state === 'pending'
      }
    }
  },
  methods: {
    ...mapActions('instance', [
      'editFirewall'
    ]),
    convertWhitelistAndUpgradeInstance () {
      this.editFirewall({
        id: this.instance.id,
        projectId: this.instance.project_id,
        whitelist: this.whitelist.map(x => x.ip)
      })
    },
    removeEntry (index) {
      this.whitelist.splice(index, 1)
    },
    addEntry () {
      this.whitelist.push({ ip: '' })
    }
  },
  created () {
    this.whitelist = this.instance.whitelist.concat().map(ip => ({
      ip
    }))
    this.wasEmpty = !!this.whitelist.length
  }
}
</script>
