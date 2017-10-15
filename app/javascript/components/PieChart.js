import { Doughnut } from 'vue-chartjs'

export default Doughnut.extend({
  props: ['datasets', 'labels', 'isTitle', 'title'],
  mounted () {
    // Overwriting base render method with actual data.
    this.renderChart({
      labels: this.datasets.labels,
      datasets: [{backgroundColor: this.datasets.backgroundColor,
                 data: this.datasets.data}]
    },
    {title: {
      display: this.isTitle,
      text: this.title
      }
    })
  }
})
