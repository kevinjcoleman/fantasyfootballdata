<template>
  <div class="layout-wrap">
    <h1>{{ team.team.name }}</h1>
    <div class="well">
      <div class="btn-group" role="group">
        <button v-for="week in team.team.weeks"
                @click="changeCurrentWeek(week)"
                v-bind:class="week == team.team.filteredWeek ? 'btn-success' : ''"
                type="button"
                class="btn btn-default" >{{week}}</button>
      </div>
      <multiselect
        v-model="selectedPositions"
        :options="options"
        :searchable="false"
        :multiple="true"
        :close-on-select="false"
        :clear-on-select="false"
        :hide-selected="true"
        :preserve-search="true"
        placeholder="Filter by position"
        @input="selectedPositionChange">
      </multiselect>
    </div>
    <div class='well'>
      <div class="row">
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
    </div>
    <h2>Week {{team.team.filteredWeek}} stats</h2>
    <div class="well">
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
  </div>
</template>

<script type="text/javascript">
import { mapState, mapActions, mapGetters } from 'vuex'
import _ from 'lodash'
import WeeklyChart from './WeeklyChart'
import PieChart from './PieChart'
import Multiselect from 'vue-multiselect'

export default {
  name: 'Layout',
  components: {WeeklyChart, PieChart, Multiselect},
  data() {
    return {
      selectedPositions: null,
      options: ['QB', 'RB', 'WR', 'TE']
    }
  },
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
      'changeCurrentWeek',
      'filterForPositions'
    ]),
    playerStats: function(player) {
      return _.map(this.statKeys, (key) => {
        return _.get(player.stats, key)
      })
    },
    selectedPositionChange: function(value, id) {
      this.filterForPositions(value)
    }
  }
}
</script>
