import Vue from 'vue'
import Roster from '../components/Roster.vue'
import store from '../store'
import VueGoodTable from 'vue-good-table';
import Raven from 'raven-js';
import RavenVue from 'raven-js/plugins/vue';

Raven.config('https://f61ac8fb5f09402cbdbf5c7f89f4bd67@sentry.io/230517').addPlugin(RavenVue, Vue).install();

Vue.use(VueGoodTable);

new Vue({
  el: '#roster',
  store,
  render: h => h(Roster)
})
