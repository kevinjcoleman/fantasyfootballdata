import React from 'react';
import { render } from "react-dom";
import ReactTable from 'react-table';
import styles from 'react-table/react-table.css';
import styles2 from 'react-select/dist/react-select.css';
import axios from 'axios';
import Select from 'react-select';

class Table extends React.Component {
  constructor() {
    super();
    this.fetchData = this.fetchData.bind(this);
    this.filterData = this.fetchData.bind(this);
    this.logSelectChange = this.logSelectChange.bind(this);
    this.state = {
      players: [],
      loading: true,
      filter_criteria: {team: null},
      filteredPlayers: [],
      teams: []
    };
  }

  componentDidMount(){
    this.fetchData();
    setInterval(this.fetchData, 15000);
  }

  fetchData(){
    axios.get('/leagues/1/players.json')
      .then(function (response) {
        console.log(response.data)
        // filter players in the fetch method
        let filteredPlayers = response.data.players;
        let filterCriteria = this.state.filter_criteria;
        if (filterCriteria.team) {filteredPlayers = this.filterPlayers(filterCriteria, this.state.players);}
        this.setState({
          players: response.data.players,
          filteredPlayers: filteredPlayers,
          teams: response.data.teams,
          loading: false
        });
    }.bind(this))
      .catch(function (error) {
        console.log(error);
    });
  }

  filterPlayers(filterCriteria, players) {
    if (filterCriteria.team) {
      console.log("filtering by team by:", filterCriteria.team);
      players = players.filter(player => player.team == filterCriteria.team);
    }
    return players;
  }

  logSelectChange(val) {
    if (val) {
      console.log(val.value);
      this.state.filter_criteria.team = val.value
      this.setState({filter_criteria: {team: val.value}});
      let filteredPlayers = this.filterPlayers(this.state.filter_criteria, this.state.players);
      this.setState({filteredPlayers: filteredPlayers});
    } else {
      this.setState({filter_criteria: {team: null,},
                    filteredPlayers: this.state.players})
    }
  }

  hasFilterCriteria() {
    this.state.filter_criteria.team != null
  }

  render() {
    return (
      <div>
        <label>Filter by player status</label>
        <Select
          name="form-field-name"
          value={this.state.filter_criteria.team || null }
          options={this.state.teams}
          onChange={this.logSelectChange}
        />
        <ReactTable
          data={this.hasFilterCriteria ? this.state.filteredPlayers : this.state.players}
          loading={this.state.loading}
          columns={[{
              Header: 'Name',
              accessor: 'name' // String-based value accessors!
            }, {
              Header: 'Team',
              accessor: 'team'
            },{
              Header: 'Position',
              accessor: 'position'
            }, {
              Header: '2016 Score',
              accessor: 'total_points'
            }, {
              Header: '2016 Position ranking',
              accessor: 'position_ranking'
            }, {
              Header: '2016 Point differential',
              accessor: 'point_differential'
            }]}
          defaultPageSize={50}
          defaultSortDesc={true}
          className="-striped -highlight"
        />
        <br />
      </div>
    );
  }
}

render(<Table />, document.getElementById("root"));
