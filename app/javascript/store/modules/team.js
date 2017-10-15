import team from '../../api/team'
import * as types from '../mutation-types'
import _ from 'lodash'
import randomColor from 'randomColor'

// initial state
const state = {
  team: {},
  players: []
}

export const HEADER_ATTRIBUTES_TO_SKIP = ["id", "week", "isProjections"]

// getters
const getters = {
  fetchTeam: state => state.team,
  playerStats: state => state.stats,
  currentWeekPlayerStats: state => {
    return _.map(state.players, (player) => {
      var dupePlayer = _.clone(player)
      var actualWeeklyStat = _.find(dupePlayer.stats, {week: state.team.filteredWeek, isProjection: false})
      if (!actualWeeklyStat) {
        dupePlayer.stats = _.find(dupePlayer.stats, {week: state.team.filteredWeek})
      } else {
        dupePlayer.stats = actualWeeklyStat
      }
      return dupePlayer
    })
  },
  statKeys: (state, getters) => {
    var firstPlayer = _.first(getters.currentWeekPlayerStats)
    while (!firstPlayer) {
      return null
      firstPlayer = _.first(getters.currentWeekPlayerStats)
    }
    return _.filter(_.keys(firstPlayer.stats), (header) => {
      return !_.includes(HEADER_ATTRIBUTES_TO_SKIP, header)
    })
  },
  playerStatsForLineChart: state => {
    return _.map(state.players, (player) => {
      var playerHash = {}
      playerHash.label = player.name
      playerHash.borderColor = randomColor()
      playerHash.fill = false
      var actualStats = _.filter(player.stats, {isProjection: false})
      playerHash.data = _.map(actualStats, (stat) => {
        return stat.total
      })
      return playerHash
    })
  },
  playerStatsForPieChart: state => {
    var playerStats = _.map(state.players, (player) => {
      var playerHash = {}
      playerHash.label = player.name
      playerHash.color = randomColor()
      var actualStats = _.map(_.filter(player.stats, {isProjection: false}), (stat) => {
        return stat.total
      })
      playerHash.value = _.sum(actualStats).toFixed(2)
      return playerHash
    })
    console.log(playerStats)
    return {labels: _.map(playerStats, (stat) => { return stat.label}),
            backgroundColor: _.map(playerStats, (stat) => { return stat.color}),
            data: _.map(playerStats, (stat) => { return stat.value})}
  }
}

// actions
const actions = {
  loadTeam ({ commit, rootState }) {
    team.getTeam(rootState.teamId).then(response => {
      var teamData = response.data
      commit(types.RECEIVE_TEAM, { teamData })
    })
  },
  loadStats ({ commit, rootState}) {
    console.log('loading stats')
    team.getPlayerStats(rootState.teamId).then(response => {
      var players = response.data
      commit(types.INITIALIZE_PLAYERS, { players })
    })
  },
  changeCurrentWeek ({commit}, newWeek ) {
    commit(types.CHANGE_WEEK, {newWeek})
  }
}

// mutations
const mutations = {
  [types.RECEIVE_TEAM] (state, { teamData }) {
    state.team = teamData
  },
  [types.INITIALIZE_PLAYERS] (state, { players }) {
    state.players = players
  },
  [types.CHANGE_WEEK] (state, { newWeek }) {
    state.team.filteredWeek = newWeek
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
