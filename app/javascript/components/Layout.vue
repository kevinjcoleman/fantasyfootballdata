<template>
  <div class="layout-wrap">
    <h1>Team id: {{ team.team.name }}</h1>
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

export default {
  name: 'Layout',

  computed: {
    ...mapState(['team']),
    ...mapGetters(['currentWeekPlayerStats', 'statKeys'])
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
