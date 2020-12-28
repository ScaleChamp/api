<template>
  <ChartFrame :name="$t('metrics_comp.memory')">
    <canvas ref="memory"/>
  </ChartFrame>
</template>

<script>
import 'chartjs-plugin-colorschemes/src/plugins/plugin.colorschemes'
import Chart from './lib/chart'
import readableBytes from 'readable-bytes'
import toMetric from '@/lib/metric'
import { Paired12 } from 'chartjs-plugin-colorschemes/src/colorschemes/colorschemes.brewer'
import ChartFrame from './components/ChartFrame'

export default {
  name: 'Memory',
  components: {
    ChartFrame
  },
  props: {
    metrics: Array
  },
  methods: {
    toMap (x) {
      return {
        pointStyle: 'line',
        fill: false,
        label: 'node-' + x.node_id.slice(0, 8),
        data: x.data.used_memory.map(toMetric).sort((a, b) => b.x - a.x),
        borderWidth: 2
      }
    }
  },
  watch: {
    metrics () {
      this.memory.data.datasets = this.metrics.map(this.toMap)
      this.memory.update()
    }
  },
  mounted () {
    this.memory = new Chart(this.$refs.memory, {
      type: 'line',
      data: {
        datasets: this.metrics.map(this.toMap)
      },
      options: {
        plugins: {
          colorschemes: {
            scheme: Paired12
          }
        },
        animation: {
          duration: 0
        },
        legend: {
          display: true,
          labels: {
            usePointStyle: true
          }
        },
        elements: {
          point: {
            radius: 0
          }
        },
        tooltips: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label (tooltipItem, data) {
              let label = data.datasets[tooltipItem.datasetIndex].label || ''
              if (label) {
                label += ': '
              }
              label += readableBytes(tooltipItem.yLabel)
              return label
            }
          }
        },
        lineTension: 1,
        scales: {
          xAxes: [
            {
              gridLines: {
                display: false
              },
              type: 'time',
              time: {
                unit: 'hour'
              }
            }
          ],
          yAxes: [{
            gridLines: {
              display: true
            },
            ticks: {
              callback: (label, index, labels) => readableBytes(label <= 1 ? 0 : Math.round(label)),
              beginAtZero: false,
              padding: 10
            }
          }]
        }
      }
    })
  },
  beforeDestroy () {
    this.memory.destroy()
  }
}
</script>
