<template>
  <ChartFrame :name="$t('metrics_comp.cpu')">
    <canvas ref="cpu"/>
  </ChartFrame>
</template>

<script>
import 'chartjs-plugin-colorschemes/src/plugins/plugin.colorschemes'
import Chart from './lib/chart'
import toMetric from '@/lib/metric'
import { Paired12 } from 'chartjs-plugin-colorschemes/src/colorschemes/colorschemes.brewer'
import ChartFrame from './components/ChartFrame'

export default {
  name: 'CPU',
  components: {
    ChartFrame
  },
  props: {
    metrics: Array
  },
  beforeDestroy () {
    this.cpu.destroy()
  },
  methods: {
    toMap (x, i) {
      return {
        pointStyle: 'line',
        fill: false,
        label: 'node-' + x.node_id.slice(0, 8),
        data: x.data.used_cpu_sys.map(toMetric).sort((a, b) => b.x - a.x),
        borderWidth: 2
      }
    }
  },
  mounted () {
    this.cpu = new Chart(this.$refs.cpu, {
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
        lineTension: 1,
        elements: {
          point: {
            radius: 0
          }
        },
        tooltips: {
          mode: 'index',
          intersect: false
        },
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
          yAxes: [
            {
              gridLines: {
                drawBorder: false,
                display: true
              },
              ticks: {
                callback: (label, index, labels) => (label <= 1 ? 0 : Math.round(label)),
                beginAtZero: true,
                padding: 10
              }
            }
          ]
        }
      }
    })
  },
  watch: {
    metrics () {
      this.cpu.data.datasets = this.metrics.map(this.toMap)
      this.cpu.update()
    }
  }
}
</script>
