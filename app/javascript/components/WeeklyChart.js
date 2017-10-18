import { Line } from 'vue-chartjs'

export default Line.extend({
  props: ['datasets', 'labels', 'isTitle', 'title'],
  mounted () {
    // Overwriting base render method with actual data.
    this.renderChart({
      labels: this.labels,
      datasets: this.datasets
    },
    {title: {
      display: this.isTitle,
      text: this.title
      }
    })
  },
  watch: {
    datasets: function(newDatasets, oldDatasets) {
      this.renderChart({
        labels: this.labels,
        datasets: newDatasets
      },
      {title: {
        display: this.isTitle,
        text: this.title
        }
      })
    },
    labels: function(newLabels, oldlabels) {
      this.renderChart({
        labels: newLabels,
        datasets: this.datasets
      },
      {title: {
        display: this.isTitle,
        text: this.title
        }
      })
    },
  }
})
