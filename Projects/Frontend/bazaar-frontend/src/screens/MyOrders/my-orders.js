import React, { Component } from 'react'
import axios from 'axios'

//components
import Accordion from 'react-bootstrap/Accordion'
import Card from 'react-bootstrap/Card'
import ProductCard from "../../components/ProductCard/productCard"
import Button from 'react-bootstrap/Button'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import ListGroup from 'react-bootstrap/ListGroup'
import CategoryBar from "../../components/category-bar/category-bar";
import { Link } from 'react-router-dom'
import { faBan } from "@fortawesome/free-solid-svg-icons";
import { faCheckCircle } from "@fortawesome/free-solid-svg-icons";
import { faTruck } from "@fortawesome/free-solid-svg-icons";
import { faBoxOpen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";


//helpers
import {serverUrl} from '../../utils/get-url'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';

import "./my-orders.scss";

export default class MyOrders extends Component {


  constructor(props) {
    super(props);
    this.state = {
      orders: [],
      products: [],
      vendors: [],
      recipiant: {}
    };
  }


  componentDidMount() {

    let myCookie = read_cookie('user');
    const header = {headers: {Authorization: "Token "+myCookie.token}};

    console.log(header)
    axios.get(serverUrl+`api/product/order/`, header)
    .then(res => {
      //this.setState({orders: res})
      this.setState({orders: res.data})

      let products = [];
      let productIdList= [];
      let vendors = [];
      let vendorIdList= [];

      const { orders } = this.state;
      for (let i = 0; i < orders.length; i ++) {
        for (let j = 0; j < orders[i].deliveries.length; j++) {

          if (!productIdList.includes(orders[i].deliveries[j].product_id)) {
            axios.get(serverUrl+'api/product/'+orders[i].deliveries[j].product_id+'/', header)
            .then(res => {
              //this.setState({orders: res})
              products.push(res.data)
              
              this.setState({products: products})
        
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
            })

          }

          if (!vendorIdList.includes(orders[i].deliveries[j].vendor)) {

            axios.get(serverUrl+'api/user/'+orders[i].deliveries[j].vendor+'/', header)
            .then(res => {
              //this.setState({orders: res})
              vendors.push(res.data)
    
              this.setState({vendors: vendors})
        
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
            })

          }


        }

      }

      this.setState({vendors: vendors})
      this.setState({products: products})
      


    }).catch(error => {
      console.log("error: "+JSON.stringify(error))
    })

    axios.get(serverUrl+'api/user/'+myCookie.user_id+'/')
    .then(res => {
      this.setState({recipiant: res.data})
    })

  }

  cancelDelivery = event => {
    console.log("cancel button pressed")
    console.log(event.target.id)

    let myCookie = read_cookie('user');
    const header = {
      headers: {
        Authorization: "Token " + myCookie.token
      }
    };

    const data = {
      delivery_id: event.target.id,
      status: 4
    }

    axios.put(serverUrl + 'api/product/order/', data, header)
    .then(res => {
      //this.setState({orders: res})
      console.log(res.data)

      axios.get(serverUrl+`api/product/order/`, header)
      .then(res => {
        //this.setState({orders: res})
        this.setState({orders: res.data})

      })

    }).catch(res => {
      console.log(res)
    })

  }


  render() {

    const { products } = this.state;
    const { vendors } = this.state;
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

    let orders = this.state.orders.map((order) => {
      let totalCost = 0;
      let splitTime = order.timestamp.split("T")
      let vendorIdList = [];
      let productIdList = [];

      let deliveries = order.deliveries.map((delivery => {   

        let filteredProducts = products.filter(function (product) {
          return product.id == delivery.product_id;
        });
        let product = filteredProducts[0];
        if (!productIdList.includes(product?.id)) {
          productIdList.push(product?.id)
        }
        totalCost += product?.price * delivery.amount

        let filteredVendors = vendors.filter(function (vendor) {
          return vendor.id == delivery.vendor;
        });
        let vendor = filteredVendors[0];
        if (!vendorIdList.includes(vendor?.id)) {
          vendorIdList.push(vendor?.id)
        }

        return (
          <div className="delivery-block">
            <div className="row">
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                {statusTypes[delivery.current_status]}
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                <a className="orders-page-link" href={"/user/"+vendor?.id}>
                  {vendor?.first_name} {vendor?.last_name}  
                </a>
              </div>
              <div className="col-lg-3 col-md-3 col-sm-3 order-column">
                <Link className="orders-page-link" to={{pathname: `/product/${product?.id}`, state: {product: product} }} >
                  {product?.name}
                </Link>
                <a className="orders-page-link"  href={"/products/"+product?.id}  product={product}>
                </a>
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                {product?.price} TL
              </div>
              <div className="col-lg-1 col-md-1 col-sm-1 order-column amount-column">
                {delivery.id}
              </div>
              <div className="col-lg-1 col-md-1 col-sm-1 delivery-button-div" hidden={!(delivery.current_status == 1)}>
                <Button variant="danger" className="delivery-button" onClick={this.cancelDelivery} id={delivery.id}>
                  Cancel
                </Button>              
              </div>
              <div className="col-lg-1 col-md-1 col-sm-1 delivery-button-div" hidden={!(delivery.current_status == 3)}>
                <Button variant="warning" className="delivery-button" >
                  Rate
                </Button>              
              </div>
            </div>
          </div>
        );
      }));

      return (
        <div className="order-block">
          <div className="order-header">
            <div className="row">
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                <div className="order-question">
                  Order Date:
                </div>
                <div className="order-value">
                  {splitTime[0].substring(8, 10)} {months[splitTime[0].substring(5, 7)]} {splitTime[0].substring(0, 4)} {splitTime[1].substring(0,5)}
                </div>
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                <div className="order-question">
                  Summary:
                </div>
                <div className="order-value">
                  {vendorIdList.length} Vendors, {productIdList.length} Products
                </div>
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                <div className="order-question">
                  Recipiant:
                </div>
                <div className="order-value">
                  {this.state.recipiant.first_name} {this.state.recipiant.last_name} 
                </div>
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column">
                <div className="order-question">
                  Total Price:
                </div>
                <div className="order-value">
                  {totalCost} TL
                </div>
              </div>
              <div className="col-lg-2 col-md-2 col-sm-2 order-column detail-button-div">
                <Button className="detail-button">
                  Order Details
                </Button>
              </div>
            </div>
          </div>
          {deliveries}
        </div>
      );
    });

    return (
      <div className='background'>
        <h2 className="orders-page-header text-center">
          My Orders
        </h2>
        <div className="orders-container">
          {orders}
        </div>
      </div>
    )
  }
}
