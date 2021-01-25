import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import DataTable, {createTheme} from 'react-data-table-component';
import { Modal, Button, Alert } from "react-bootstrap";
import { serverUrl } from '../../utils/get-url'

import { faBan } from "@fortawesome/free-solid-svg-icons";
import { faCheckCircle } from "@fortawesome/free-solid-svg-icons";
import { faTruck } from "@fortawesome/free-solid-svg-icons";
import { faBoxOpen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

import "./my-orders-vendor.scss";

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

export default class MyOrdersVendor extends Component {

  constructor() {
    super();
    this.state = {
      products: [],
      customers: [],
      orders: [],

    }

  }



  componentDidMount() {
    let months = {
      "01": "Jan",
      "02": "Feb",
      "03": "Mar",
      "04": "Apr",
      "05": "May",
      "06": "Jun",
      "07": "Jul",
      "08": "Aug",
      "09": "Seb",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec"
    }
    let statusTypes = {
      1: <div className="preparing">
        <FontAwesomeIcon icon={faBoxOpen}/> Preparing
        </div>,

      2: <div className="on-the-way">
      <FontAwesomeIcon icon={faTruck}/> On the Way
      </div>,
      3: <div className="delivered">
      <FontAwesomeIcon icon={faCheckCircle}/> Delivered
      </div>,
      4: <div className="cancelled">
      <FontAwesomeIcon icon={faBan}/> Cancelled
      </div>
    }
    let myCookie = read_cookie('user');
    const header = { headers: { Authorization: "Token " + myCookie.token } };

    axios.get(serverUrl + `api/product/vendor_order/`, header)
      .then(res => {
        //this.setState({orders: res})
        this.setState({ orders: res.data })

        let products = [];
        let customers = [];
        console.log("res.data", res.data)
        const { orders } = this.state;
        for (let i = 0; i < orders.length; i++) {

          axios.get(serverUrl + 'api/product/' + orders[i].product_id + '/', header)
            .then(res => {
              //this.setState({orders: res})
              products.push(res.data)
              let orders_temp = orders
              orders_temp[i]["product_name"] = res.data.name
              orders_temp[i]["price"] = res.data.price
              orders_temp[i]["status"] = statusTypes[orders_temp[i].current_status]
              
              let order_timestamp = orders[i].timestamp.split("T")
              orders_temp[i]["order_time"] = order_timestamp[0].substring(8, 10)+" "+months[order_timestamp[0].substring(5, 7)]+" "+order_timestamp[0].substring(0, 4)
              
              let delivery_timestamp = orders[i].delivery_time.split("T")
              
              if (orders_temp[i].current_status == 3) {
                orders_temp[i]["delivery_time"] = delivery_timestamp[0].substring(8, 10)+" "+months[delivery_timestamp[0].substring(5, 7)]+" "+delivery_timestamp[0].substring(0, 4)
              } else {
                orders_temp[i]["delivery_time"] = "-"
                if (orders_temp[i].current_status == 1) {
                  orders_temp[i].action =
                  <div>
                    <Button variant="warning" className="delivery-button" 
                    onClick={(event) => this.setStatus(event, 2)} id={orders_temp[i].id}>
                      On the Way
                    </Button> 
                    <Button variant="danger" className="delivery-button" 
                    onClick={(event) => this.setStatus(event, 4)} id={orders_temp[i].id}>
                      Cancel
                    </Button> 
                  </div> 
                } else if (orders_temp[i].current_status == 2) {
                  orders_temp[i].action = 
                    <Button variant="success" className="delivery-button" onClick={(event) => this.setStatus(event, 3)} id={orders_temp[i].id}>
                      Set to Delivered
                    </Button> 
                }
              }


              this.setState({ orders: orders_temp })

            }).catch(error => {
              console.log("error: " + JSON.stringify(error))
            })


          axios.get(serverUrl + 'api/user/' + orders[i].customer_id + '/', header)
            .then(res => {
              //this.setState({orders: res})
              customers.push(res.data)

              this.setState({ customers: customers })

            }).catch(error => {
              console.log("error: " + JSON.stringify(error))
            })

          


        }

      })


  }

  setStatus = (event, parameter) => {
    console.log("set status button pressed")
    console.log(event.target.id)
    console.log(parameter)

    let myCookie = read_cookie('user');
    const header = {
      headers: {
        Authorization: "Token " + myCookie.token
      }
    };

    const data = {
      delivery_id: event.target.id,
      status: parameter,
      delivery_time: {
        year: 2021,
        month: 1,
        day: 26
      }
    }

    axios.put(serverUrl + 'api/product/vendor_order/', data, header)
      .then(res => {
        //this.setState({orders: res})
        console.log(res.data)



      }).catch(res => {
        console.log(res)
      })

  }

  handleSubmit = event => {


  }

  handleChange = (event) => {
    // You can use setState or dispatch with something like Redux so we can use the retrieved data
    this.setState({ [event.target.name]: event.target.value });
    //console.log(this.state.category)
  };



  render() {

    const columns = [
      
      {
        name: "Brand",
        selector: "product_name",
        sortable: true
      },
      {
        name: "Price",
        selector: "price",
        sortable: true,
        right: true
      },
      {
        name: "Amount",
        selector: "amount",
        sortable: true,
        right: true
      },
      {
        name: "Action",
        selector: "action",
        sortable: true,
        middle: true
      },
      {
        name: "Status",
        selector: "status",
        sortable: true,
        right: true
      },{
        name: "Order Time",
        selector: "order_time",
        sortable: true,
        right: true
      },
      {
        name: "Delivery Time",
        selector: "delivery_time",
        sortable: true,
        right: true
      }
    ];

    return (
      <div className="vendor-orders-display background">

        <DataTable
          title="My Orders"
          columns={columns}
          data={this.state.orders}
          defaultSortField="product_id"
          pagination
          theme="custom-theme"
        />
      </div>

    );
  }
}