<template>
  <div class="layout-wrap">
    <h1>Team id: {{ team.team.name }}</h1>
    <div class='row'>
      <div class="weekly-chart col-md-6">
        <weekly-chart :datasets="playerStatsForLineChart"
                      :labels="team.team.weeks"
                      :isTitle="true"
                      :title="'Weekly stats by player'">
        </weekly-chart>
      </div>
      <div class="pie-chart col-md-6">
        <pie-chart :datasets="playerStatsForPieChart"
                      :isTitle="true"
                      :title="'Portion of season stats'">
        </pie-chart>
      </div>
    </div>
    <h2>Week {{team.team.filteredWeek}} stats</h2>
    <div class="btn-group" role="group">
      <button v-for="week in team.team.weeks"
              @click="changeCurrentWeek(week)"
              v-bind:class="week == team.team.filteredWeek ? 'btn-success' : ''"
              type="button"
              class="btn btn-default" >{{week}}</button>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th v-for="header in statKeys">{{header}}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="player in currentWeekPlayerStats">
          <td v-for="stat in playerStats(player)">{{stat}}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script type="text/javascript">
import { mapState, mapActions, mapGetters } from 'vuex'
import _ from 'lodash'
import WeeklyChart from './WeeklyChart'
import PieChart from './PieChart'

export default {
  name: 'Layout',
  components: {WeeklyChart, PieChart},
  computed: {
    ...mapState(['team']),
    ...mapGetters(['currentWeekPlayerStats',
                   'statKeys',
                   'playerStatsForLineChart',
                   'playerStatsForPieChart']),
    weeks: function() {
      return this.team.team.weeks
    }
  },
  methods: {
    ...mapActions([
      'changeCurrentWeek'
    ]),
    playerStats: function(player) {
      return _.map(this.statKeys, (key) => {
        return _.get(player.stats, key)
      })
    }
  }
}
</script>
