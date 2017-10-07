import Vue from 'vue'
import Roster from '../components/Roster.vue'
import store from '../store'
import VueGoodTable from 'vue-good-table';

Vue.use(VueGoodTable);

new Vue({
  el: '#roster',
  store,
  render: h => h(Roster)
})
