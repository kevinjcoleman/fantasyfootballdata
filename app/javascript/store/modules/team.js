import team from '../../api/team'
import * as types from '../mutation-types'
import _ from 'lodash'
import randomColor from 'randomColor'

// initial state
const state = {
  team: {},
  players: [],
  currentPositions: []
}

export const HEADER_ATTRIBUTES_TO_SKIP = ["id", "week", "isProjections"]

// getters
const getters = {
  fetchTeam: state => state.team,
  playerStats: state => state.stats,
  currentPlayers: state => {
    if (state.currentPositions.length > 0) {
      return _.filter(state.players, (player) => {
        return _.includes(state.currentPositions, player.position)
      })
    } else {
      return state.players
    }
  },
  currentWeekPlayerStats: (state, getters) => {
    return _.map(getters.currentPlayers, (player) => {
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
  playerStatsForLineChart: (state, getters) => {
    return _.map(getters.currentPlayers, (player) => {
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
  playerStatsForPieChart: (state, getters) => {
    var playerStats = _.map(getters.currentPlayers, (player) => {
      var playerHash = {}
      playerHash.label = player.name
      playerHash.color = randomColor()
      var actualStats = _.map(_.filter(player.stats, {isProjection: false}), (stat) => {
        return stat.total
      })
      playerHash.value = _.sum(actualStats).toFixed(2)
      return playerHash
    })
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
  },
  filterForPositions ({commit}, positions) {
    commit(types.ADD_CURRENT_POSITIONS, {positions})
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
  },
  [types.ADD_CURRENT_POSITIONS] (state, { positions }) {
    state.currentPositions = positions
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
