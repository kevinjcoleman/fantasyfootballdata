import { Line } from 'vue-chartjs'

export default Line.extend({
  mounted () {
    // Overwriting base render method with actual data.
    this.renderChart({
      labels: ['Week 1', 'Week 2', 'Week3', 'Week 4', 'Week 5'],
      datasets: [
        {
          label: 'Dak prescott',
          backgroundColor: '#f87979',
          data: [40, 20, 12, 39, 10]
        }
      ]
    })
  }
})
