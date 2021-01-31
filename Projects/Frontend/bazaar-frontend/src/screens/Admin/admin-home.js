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

export default class AdminHome extends Component {

  constructor() {
    super();
    this.state = {
      reports: []

    }

  }



  componentDidMount() {
    let myCookie = read_cookie('user');
    const header = { headers: { Authorization: "Token " + myCookie.token } };

    axios.get(serverUrl + "api/message/admin/report/", header)
      .then(res => {


        this.setState({reports: res.data})
        let reportsTemp = res.data

        for (let i = 0; i < reportsTemp.length; i++){

          reportsTemp[i].action = <div>
            Please refer to {reportsTemp[i].type} page in the header.
          </div>

          if (reportsTemp[i].type == "User"){
            console.log("here user")
  
            axios.get(serverUrl + "api/user/"+reportsTemp[i].reported_user+"/")
            .then(res2 => {
  
              reportsTemp[i].reported_item_name = res2.data.first_name +" "+ res2.data.last_name
  
            })
  
          }
          this.setState({reports: reportsTemp})

        }

        

      })


  }


  render() {
    const {reports} = this.state;

    for (let i = 0;i <reports.length; i ++) {
      if (reports[i].report_type === 1){
        reports[i].type = "User"
        reports[i].reported_item = reports[i].reported_user

      } else {
        reports[i].type = "Comment"
        reports[i].reported_item = reports[i].comment
      }
      
    }

    const columns = [

      {
        name: "ID",
        selector: "id",
        sortable: true,
      },
      {
        name: "Report Type",
        selector: "type",
        sortable: true,
      },
      {
        name: "Reported item (ID)",
        selector: "reported_item",
        sortable: true,
      },
      {
        name: "Reported By (ID)",
        selector: "user",
        sortable: true,
      },
      {
        name: "Action",
        selector: "action",
        sortable: true,
        minWidth: "300px",
        center: true,
        button: true,
        compact: true
      }
    ];

    return (
      <div className="admin-list-display background">
        <h1 className="admin-title">
          Admin page
        </h1>
        <DataTable
          title="Reports"
          columns={columns}
          data={this.state.reports}
          defaultSortField="id"
          pagination
          theme="custom-theme"
        />
      </div>

    );
  }
}