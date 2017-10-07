import team from '../../api/team'
import * as types from '../mutation-types'
import _ from 'lodash'

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
