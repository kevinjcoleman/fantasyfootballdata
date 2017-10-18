import { Doughnut, mixins } from 'vue-chartjs'

export default Doughnut.extend({
  props: ['datasets', 'isTitle', 'title'],
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
  },
  watch: {
    datasets: function(newVal, oldVal) { 
      this.renderChart({
        labels: newVal.labels,
        datasets: [{backgroundColor: newVal.backgroundColor,
                   data: newVal.data}]
      },
      {title: {
        display: this.isTitle,
        text: this.title
        }
      })
    }
  }
})
