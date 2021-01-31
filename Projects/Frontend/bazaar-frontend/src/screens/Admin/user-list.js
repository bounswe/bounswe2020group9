import React, { Component } from "react";
import axios from 'axios'
import { read_cookie } from 'sfcookies';
import DataTable, { createTheme } from 'react-data-table-component';
import { Button } from "react-bootstrap";
import { serverUrl } from '../../utils/get-url'

import { faBan, faCheckCircle, faTruck, faBoxOpen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

import "./admin-pages.scss";

createTheme('custom-theme', {

  background: {
    default: '#e8ffff',
  },
  context: {
    background: '#cb4b16',
    text: '#FFFFFF',
  },
  divider: {
    default: '#073642',
  },
  action: {
    button: 'rgba(0,0,0,.54)',
    hover: 'rgba(0,0,0,.08)',
    disabled: 'rgba(0,0,0,.12)',
  },
});

export default class UserList extends Component {

  constructor() {
    super();
    this.state = {
      users: [],
      reports: []
    }

  }



  componentDidMount() {
    let myCookie = read_cookie('user');
    const header = { headers: { Authorization: "Token " + myCookie.token } };

    console.log(serverUrl + "api/message/admin/ban/", header)
    axios.get(serverUrl + "api/message/admin/report/", header)
    .then(res => {
      this.setState({reports: res.data})
    })
    axios.get(serverUrl + "api/message/admin/ban/", header)
      .then(res => {

        for (let i = 0; i < res.data.length; i++) {

          var reportsOfUser = this.state.reports.filter(function (report) {
            return report.reported_user == res.data[i].id
          });
          res.data[i].report_count = reportsOfUser.length
        }
        this.setState({ users: res.data })

      })


  }

  banUser = (event) => {

    let myCookie = read_cookie('user');
    const headers = {
      'Authorization': 'Token '+myCookie.token
    }
    const data = {
      user_id: event.target.id
    }

    
    axios.post(serverUrl + 'api/message/admin/ban/', data, {
        headers: headers
      })
      .then(res => {

        axios.get(serverUrl + 'api/message/admin/ban/', {
          headers: headers
        })
          .then(res => {

            this.setState({ users: res.data })

          })

      }).catch(error => {
        console.log(error)
      })

    //ban user
  }


  render() {

    const { users } = this.state;

    for (let i = 0; i < users.length; i++) {
      if (users[i].user_type === 1 || users[i].user_type === 2) {
        users[i].type = (users[i].user_type === 1) ? "Customer" : "Vendor";
        if (!users[i].is_banned) {
          users[i].action = <div>
            <Button variant="danger" className="ban-button"
              onClick={(event) => this.banUser(event)} id={users[i].id}>
              Ban User
                              </Button>
          </div>
        } else {
          users[i].action = <div>
            <Button variant="success" className="ban-button"
              onClick={(event) => this.banUser(event)} id={users[i].id}>
              Remove Ban
                              </Button>
          </div>
        }
      } else {
        users[i].type = "admin"
      }
    }

    const columns = [

      {
        name: "ID",
        selector: "id",
        sortable: true,
        maxWidth: "150px"
      },
      {
        name: "Type",
        selector: "type",
        sortable: true,
        maxWidth: "180px",
      },
      {
        name: "Email",
        selector: "email",
        sortable: true,
        minWidth: "300px",
      },
      {
        name: "First Name",
        selector: "first_name",
        sortable: true,
        minWidth: "180px"
      },
      {
        name: "Last Name",
        selector: "last_name",
        sortable: true,
        compact: true
      },
      {
        name: "Report count",
        selector: "report_count",
        sortable: true,
        compact: true
      },
      {
        name: "Action",
        selector: "action",
        sortable: true,
        minWidth: "200px",
        center: true,
      }
    ];

    return (
      <div className="admin-list-display background">

        <DataTable
          title="Users"
          columns={columns}
          data={this.state.users}
          defaultSortField="id"
          pagination
          theme="custom-theme"
        />
      </div>

    );
  }
}