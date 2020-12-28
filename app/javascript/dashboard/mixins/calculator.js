export default {
  methods: {
    classIfSelected (nodes) {
      if (this.plan.nodes === nodes) {
        return 'border p-4 space-y-4 bg-blue-100 border-primary rounded-sm'
      }
      return 'border border-gray-400 p-4 space-y-4 rounded-sm'
    },
    providerClassNames (provider) {
      if (provider === 'upcloud') {
        return 'h-30 w-30'
      } else if (provider === 'hetzner' || provider === 'scw') {
        return 'h-24 w-24'
      } else if (provider === 'alibaba') {
        return 'w-24 h-24'
      } else {
        return 'w-20 h-20'
      }
    }
  },
  computed: {
    isTwoNodePlan () {
      return this.plan.nodes === 2
    },
    isOneNodePlan () {
      return this.plan.nodes === 1
    },
    plan () {
      return this.plans.find(plan => plan.id === this.planId)
    },
    kinds () {
      return Object.keys(this.searchTree)
        .map(kind =>
          this.plans.find(plan => this.planId === plan.id && kind === plan.kind) ||
          this.plans.find(plan => plan.kind === kind))
    },
    plansByKind () {
      return this.plans.filter(plan => plan.kind === this.plan.kind)
    },
    versions () {
      return Object.keys(this.searchTree[this.plan.kind])
        .map(version =>
          this.plans.find(plan => plan.id === this.planId && plan.version === version) ||
          this.plansByKind.find(plan => plan.version === version))
    },
    plansByKindVersion () {
      return this.plansByKind.filter(plan => plan.version === this.plan.version)
    },
    clouds () {
      return Object.keys(this.searchTree[this.plan.kind][this.plan.version])
        .map(cloud =>
          this.plans.find(plan => plan.id === this.planId && plan.cloud === cloud) ||
          this.plansByKindVersion.find(plan => plan.cloud === cloud))
    },
    plansByKindVersionCloud () {
      return this.plansByKindVersion.filter(plan => plan.cloud === this.plan.cloud)
    },
    regions () {
      return Object.keys(this.searchTree[this.plan.kind][this.plan.version][this.plan.cloud])
        .map(region =>
          this.plans.find(plan => plan.id === this.planId && plan.region === region) ||
          this.plansByKindVersionCloud.find(plan => plan.region === region))
        .reduce((groups, plan) => {
          groups[plan.location] = groups[plan.location] || []
          groups[plan.location].push(plan)
          return groups
        }, {})
    },
    plansByKindVersionCloudRegion () {
      return this.plansByKindVersionCloud.filter(plan => plan.region === this.plan.region)
    },
    business () {
      return Object.keys(this.searchTree[this.plan.kind][this.plan.version][this.plan.cloud][this.plan.region]['2'] || {})
        .map(name =>
          this.plans.find(plan => plan.id === this.planId && plan.name === name) ||
          this.plansByKindVersionCloudRegion.find(plan => plan.name === name))
    },
    personal () {
      return Object.keys(this.searchTree[this.plan.kind][this.plan.version][this.plan.cloud][this.plan.region]['1'] || {})
        .map(name =>
          this.plans.find(plan => plan.id === this.planId && plan.name === name) ||
          this.plansByKindVersionCloudRegion.find(plan => plan.name === name))
    }
  }
}
