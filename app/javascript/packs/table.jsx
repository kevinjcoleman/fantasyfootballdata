import React from 'react';
import { render } from "react-dom";
import ReactTable from 'react-table';
import styles from 'react-table/react-table.css';
import axios from 'axios';

class Table extends React.Component {
  constructor() {
    super();
    this.fetchData = this.fetchData.bind(this);
    this.state = {
      data: [],
      loading: true
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
        this.setState({
          data: response.data.players,
          loading: false
        });
    }.bind(this))
      .catch(function (error) {
        console.log(error);
    });
  }

  render() {
    const { data } = this.state;
    return (
      <div>
        <ReactTable
          data={data}
          loading={this.state.loading}
          columns={[{
              Header: 'Name',
              accessor: 'name' // String-based value accessors!
            }, {
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
