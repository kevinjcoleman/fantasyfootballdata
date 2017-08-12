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
        if (filterCriteria.team){
          filteredPlayers = response.data.players.filter(player => player.team == filterCriteria.team);
        };
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

  logSelectChange(val) {
    if (val) {
      let filteredPlayers = this.state.players.filter(player => player.team == val.value);
      console.log(val.value)
      this.setState({
        filteredPlayers: filteredPlayers,
        filter_criteria: {
          team: val.value,
        }
      })
    } else {
      this.setState({filter_criteria: {
                      team: null,
                    },
                    filteredPlayers: this.state.players})
    }
  }

  hasFilterCriteria() {
    this.state.filteredPlayers != [] && this.state.filter_criteria != {team: null}
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
