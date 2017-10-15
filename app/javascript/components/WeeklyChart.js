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
  }
})
