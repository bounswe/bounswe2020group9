import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import DataTable from 'react-data-table-component';

import "./inventory.scss";

export default class Inventory extends Component {

    constructor() {
        super();
        this.state = {
          products: []
        }
      }

      componentDidMount() {
        let myCookie = read_cookie('user')
        axios.get(`http://13.59.236.175:8000/api/product/`)
          .then(res => {
            let myProducts = res.data.filter(product => product.vendor === myCookie.user_id)
            this.setState({ products: myProducts })
          })
        

        }

      handleChange = (state) => {
        // You can use setState or dispatch with something like Redux so we can use the retrieved data
        console.log('Selected Rows: ', state.selectedRows);
      };


    render() {

      const columns = [
        {
          name: "Name",
          selector: "name",
          sortable: true
        },
        {
          name: "Brand",
          selector: "brand",
          sortable: true
        },
        {
          name: "Price",
          selector: "price",
          sortable: true,
          right: true
        },
        {
          name: "Stock",
          selector: "stock",
          sortable: true,
          right: true
        }
      ];

        return (
          <div className="profile-form">
            <DataTable 
              title="My Inventory"
              columns={columns}
              data={this.state.products}
              defaultSortField="title"
              pagination
              selectableRows
            />
          </div>
      
        );
    }
}