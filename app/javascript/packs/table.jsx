import React from 'react';
import ReactDOM from 'react-dom';
import ReactTable from 'react-table';
import styles from 'react-table/react-table.css';

const data = [{
  name: 'Tanner Linsley',
  total_points: 432
},{
  name: 'Tanner Linsley',
  total_points: 534
}]

const columns = [{
    Header: 'Name',
    accessor: 'name' // String-based value accessors!
  }, {
    Header: 'Score',
    accessor: 'total_points'
}]

ReactDOM.render(
  <ReactTable
    data={data}
    columns={columns}
    className="-striped -highlight"
  />,
document.getElementById('root')
);
