import team from '../../api/team'
import * as types from '../mutation-types'

// initial state
const state = {
  team: {},
  stats: [],
  loading: true
}

// getters
const getters = {
  fetchTeam: state => state.team,
  playerStats: state => state.stats
}

// actions
const actions = {
  loadTeam ({ commit, rootState }) {
    team.getTeam(rootState.teamId,
      team => { commit(types.RECEIVE_TEAM, { team })}
    )
  },
  loadStats ({ commit, rootState}) {
    console.log('loading stats')
    team.getPlayerStats(rootState.teamId).then(response => {
      var stats = response.data
      commit(types.INITIALIZE_PLAYER_STATS, { stats })
    })
  }
}

// mutations
const mutations = {
  [types.RECEIVE_TEAM] (state, { team }) {
    state.team = team
  },
  [types.INITIALIZE_PLAYER_STATS] (state, { stats }) {
    state.stats = stats
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
