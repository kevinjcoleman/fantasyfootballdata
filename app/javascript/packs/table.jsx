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
    this.logPositionSelectChange = this.logPositionSelectChange.bind(this);
    this.state = {
      players: [],
      loading: true,
      filter_criteria: {team: null,
                        position: null},
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
        if (filterCriteria.team || filterCriteria.position) {filteredPlayers = this.filterPlayers(filterCriteria, this.state.players);}
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
    if (filterCriteria.position) {
      console.log("filtering players by:", filterCriteria.position);
      players = players.filter(player => player.position == filterCriteria.position);
    }
    return players;
  }

  logSelectChange(val) {
    let criteriaCopy = this.state.filter_criteria
    if (val) {
      console.log(val.value);
      criteriaCopy.team = val.value
      this.setState({filter_criteria: criteriaCopy});
      let filteredPlayers = this.filterPlayers(this.state.filter_criteria, this.state.players);
      this.setState({filteredPlayers: filteredPlayers});
    } else {
      criteriaCopy.team = null;
      this.setState({filter_criteria: criteriaCopy,
                    filteredPlayers: this.state.players})
    }
  }

  logPositionSelectChange(val) {
    let criteriaCopy = this.state.filter_criteria
    if (val) {
      console.log(val.value);
      criteriaCopy.position = val.value
      this.setState({filter_criteria: criteriaCopy});
      let filteredPlayers = this.filterPlayers(criteriaCopy, this.state.players);
      this.setState({filteredPlayers: filteredPlayers});
    } else {
      criteriaCopy.position = null;
      this.setState({filter_criteria: criteriaCopy,
                    filteredPlayers: this.state.players})
    }
  }

  hasFilterCriteria() {
    this.state.filter_criteria.team != null || this.state.filter_criteria.position != null
  }

  render() {
    var positionOptions = [
      { value: 'QB', label: 'QB' },
      { value: 'RB', label: 'RB' },
      { value: 'WR', label: 'WR' },
      { value: 'TE', label: 'TE' }
    ];
    return (
      <div>
        <div className="row">
          <div className='col-md-6'>
            <label>Fantasy team</label>
            <Select
              name="form-field-name"
              value={this.state.filter_criteria.team || null }
              options={this.state.teams}
              onChange={this.logSelectChange}
            />
          </div>
          <div className='col-md-6'>
            <label>Position</label>
            <Select
              name="form-field-name"
              value={this.state.filter_criteria.position || null }
              options={positionOptions}
              onChange={this.logPositionSelectChange}
            />
          </div>
        </div>
        <ReactTable
          data={this.hasFilterCriteria ? this.state.filteredPlayers : this.state.players}
          className="col-md-12"
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
