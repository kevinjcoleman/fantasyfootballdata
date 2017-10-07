<template>
  <div id="roster">
    <transition name="fade-up">
      <loader v-if="isLoading"></loader>
    </transition>
    <template v-if="!isLoading">
      <h1>Team id: {{ team.team.name }}</h1>
      <hr>
      <h2>Stats</h2>
      <tr v-for="stat in team.stats">
        <td>{{stat.average}}</td>
      </tr>
      <vue-good-table
        title="Demo Table"
        :columns="columns"
        :rows="rows"
        :paginate="true"
        :lineNumbers="true"
        :sortable='true'/>
      </template>
  </div>
</template>


<script type="text/javascript">
import { mapState } from 'vuex'
import Loader from './Loader.vue'

export default {
  components: { Loader },
  data(){
    return {
      columns: [
        {
          label: 'Name',
          field: 'name',
          filterable: true,
        },
        {
          label: 'Age',
          field: 'age',
          type: 'number',
          html: false,
          filterable: true,
        },
        {
          label: 'Percent',
          field: 'score',
          type: 'percentage',
          html: false,
        },
      ],
      rows: [
        {id:1, name:"John",age:20,createdAt: '201-10-31:9:35 am',score: 0.03343},
        {id:2, name:"Jane",age:24,createdAt: '2011-10-31',score: 0.03343},
        {id:3, name:"Susan",age:16,createdAt: '2011-10-30',score: 0.03343},
        {id:4, name:"Chris",age:55,createdAt: '2011-10-11',score: 0.03343},
        {id:5, name:"Dan",age:40,createdAt: '2011-10-21',score: 0.03343},
        {id:6, name:"John",age:20,createdAt: '2011-10-31',score: 0.03343},
        {id:7, name:"Jane",age:24,createdAt: '20111031'},
        {id:8, name:"Susan",age:16,createdAt: '2013-10-31',score: 0.03343},
        {id:9, name:"Chris",age:55,createdAt: '2012-10-31',score: 0.03343},
        {id:10, name:"Dan",age:40,createdAt: '2011-10-31',score: 0.03343},
        {id:11, name:"John",age:20,createdAt: '2011-10-31',score: 0.03343},
        {id:12, name:"Jane",age:24,createdAt: '2011-07-31',score: 0.03343},
        {id:13, name:"Susan",age:16,createdAt: '2017-02-28',score: 0.03343},
        {id:14, name:"Chris",age:55,createdAt: '',score: 0.03343},
        {id:15, name:"Dan",age:40,createdAt: '2011-10-31',score: 0.03343},
        {id:19, name:"Chris",age:55,createdAt: '2011-10-31',score: 0.03343},
        {id:20, name:"Dan",age:40,createdAt: '2011-10-31',score: 0.03343},
      ],
      loading: true
    };
  },
  computed: {
    ...mapState(['team']),
    isLoading: function () {
      console.log(this.loading)
      return this.loading
    }
  },
  methods: {
    updateLoading() {
      var self = this
      setTimeout(function () {
        console.log(self)
        self.loading = false
      }, 1000)
    }
  },
  created () {
    this.$store.dispatch('loadTeam'),
    this.$store.dispatch('loadStats'),
    this.updateLoading()
  }
}
</script>

<style>

</style>
