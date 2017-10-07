import team from '../../api/team'
import * as types from '../mutation-types'
import _ from 'lodash'

// initial state
const state = {
  loading: true
}

// getters
const getters = {
  loadingState: state => state.loading
}

// actions
const actions = {
  setLoadingState ({ commit }, loadState) {
    commit(types.UPDATE_LOADING, loadState)
  }
}

// mutations
const mutations = {
  [types.UPDATE_LOADING] (state, { loadState }) {
    setTimeout(function () {
      state.loading = loadState
    }, 1000)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
