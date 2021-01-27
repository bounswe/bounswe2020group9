import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import DataTable, { createTheme } from 'react-data-table-component';
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
        <FontAwesomeIcon icon={faBoxOpen} /> Preparing
        </div>,

      2: <div className="on-the-way">
        <FontAwesomeIcon icon={faTruck} /> On the Way
      </div>,
      3: <div className="delivered">
        <FontAwesomeIcon icon={faCheckCircle} /> Delivered
      </div>,
      4: <div className="cancelled">
        <FontAwesomeIcon icon={faBan} /> Cancelled
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
        let orders_temp = orders

        for (let i = 0; i < orders.length; i++) {
          console.log(orders[i].id, "delivery id")
          axios.get(serverUrl + 'api/product/' + orders[i].product_id + '/', header)
            .then(res => {
              //this.setState({orders: res})
              products.push(res.data)
              orders_temp[i]["product_name"] = res.data.name
              orders_temp[i]["del_id"] = res.data.id
              orders_temp[i]["status"] = statusTypes[orders_temp[i].current_status]

              let order_timestamp = orders[i].timestamp.split("T")
              orders_temp[i]["order_time"] = order_timestamp[0].substring(8, 10) + " " + months[order_timestamp[0].substring(5, 7)] + " " + order_timestamp[0].substring(0, 4) + " " + order_timestamp[1].substring(0, 5)

              let delivery_timestamp = orders[i].delivery_time.split("T")

              if (orders_temp[i].current_status == 3) {
                orders_temp[i]["delivery_date"] = delivery_timestamp[0].substring(8, 10) + " " + months[delivery_timestamp[0].substring(5, 7)] + " " + delivery_timestamp[0].substring(0, 4)
              } else {
                orders_temp[i]["delivery_date"] = "-"
                if (orders_temp[i].current_status == 1) {
                  orders_temp[i].action =
                    <div>
                      <Button variant="primary" className="delivery-button"
                        onClick={(event) => this.setStatus(event, 2)} id={orders_temp[i].id}>
                        Set to "On the Way"
                    </Button>
                    </div>
                } else if (orders_temp[i].current_status == 2) {
                  orders_temp[i].action =
                    <Button variant="success" className="delivery-button" onClick={(event) => this.setStatus(event, 3)} id={orders_temp[i].id}>
                      Set to "Delivered"
                    </Button>
                }
              }



            }).catch(error => {
              console.log("error: " + JSON.stringify(error))
            })


          axios.get(serverUrl + 'api/user/' + orders_temp[i].customer_id + '/', header)
            .then(res => {
              //this.setState({orders: res})
              customers.push(res.data)
              orders_temp[i]["customer_full_name"] = <a className="recipient-name" href={"/user/"+res.data.id+"/"}>{res.data.first_name} {res.data.last_name}</a>
              
              this.setState({ customers: customers })

            }).catch(error => {
              console.log("error: " + JSON.stringify(error))
            })

            this.setState({ orders: orders_temp })



        }

      })


  }

  setStatus = (event, parameter) => {
    console.log("set status button pressed")
    console.log(event.target.id)
    console.log(parameter)

    let statusTypes = {
      1: <div className="preparing">
        <FontAwesomeIcon icon={faBoxOpen} /> Preparing
        </div>,

      2: <div className="on-the-way">
        <FontAwesomeIcon icon={faTruck} /> On the Way
      </div>,
      3: <div className="delivered">
        <FontAwesomeIcon icon={faCheckCircle} /> Delivered
      </div>,
      4: <div className="cancelled">
        <FontAwesomeIcon icon={faBan} /> Cancelled
      </div>
    }

    let orders_temp = this.state.orders


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


        let deliveryToModifyTemp = orders_temp.filter(function (delivery) {
          return delivery.id == event.target.id;
        });
        let deliveryToModify = deliveryToModifyTemp[0];
        let deliveryToModifyID;
        for (let i = 0; i < orders_temp.length; i++) {
          if (orders_temp[i].id == deliveryToModify.id) {
            deliveryToModifyID = i;
            break;
          }
        }
        orders_temp[deliveryToModifyID]["status"] = statusTypes[parameter]
        console.log("orders:  ", orders_temp)
        console.log("deliveryToModifyID:  ", deliveryToModifyID)

        if (parameter == 2) {
          orders_temp[deliveryToModifyID].action =
            <div>
              <Button variant="success" className="delivery-button" onClick={(event) => this.setStatus(event, 3)} id={orders_temp[deliveryToModifyID].id}>
                Set to "Delivered"
              </Button>
            </div>
        } else if (parameter == 3) {
          orders_temp[deliveryToModifyID].action = '';
          orders_temp[deliveryToModifyID].delivery_date = "26 Jan 2021"
              
        }
        this.setState({ orders: orders_temp })

      }).catch(res => {
        console.log(res)
      })

  }


  render() {

    const columns = [

      {
        name: "Name",
        selector: "product_name",
        sortable: true,
        minWidth: "230px"
      },
      {
        name: "Amount",
        selector: "amount",
        sortable: true,
        maxWidth: "20px",
      },
      {
        name: "Recipiant",
        selector: "customer_full_name",
        sortable: true,
      },
      {
        name: "Status",
        selector: "status",
        sortable: true,
        compact: true
      }, 
      {
        name: "Action",
        selector: "action",
        sortable: true,
        minWidth: "200px",
        center: true,
        button: true,
        compact: true
      },
      {
        name: "Order Time",
        selector: "order_time",
        sortable: true,
        right: true,
        compact: true
      },
      {
        name: "Delivery Date",
        selector: "delivery_date",
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