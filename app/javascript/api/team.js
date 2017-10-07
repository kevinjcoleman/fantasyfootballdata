import axios from 'axios';
/**
 * Mocking client-server processing
 */
const _team = {"id": 1, "name": "Rick and MorTDs", "currentWeek": 2, "leagueName": 'Killed the 12th fan'}


export default {
  getTeam (teamId) {
    return axios.get("/league_team/" + teamId + '.json');
  },
  getPlayerStats(teamId) {
    return axios.get("/league_team/" + teamId + '/stats.json');
  }
}
