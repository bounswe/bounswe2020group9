import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import {serverUrl} from '../../../utils/get-url'
import { Button , Alert} from "react-bootstrap";
import CategoryBar from "../../../components/category-bar/category-bar";
import AddressCard from "./AddressCard/addresscard";

import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Container from "react-bootstrap/Container";

import "./checkout.scss";
import { faGlassWhiskey } from "@fortawesome/free-solid-svg-icons";

export default class Checkout extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          currpw: '',
          addresses: [],
          creditCards: [],
          errors: {}
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });
        
      }

      setHiddenStates(showNumber) {
        let tempStates = this.state.isHiddenStates;
        for (let i=0;i<tempStates.length;i++) {
          tempStates[i] = !(i == showNumber);
        }
        this.setState({isHiddenStates: tempStates});
      }
      
      handleSubmit = event => {



      }

      componentDidMount() {
        let myCookie = read_cookie('user')

        let myAddresses = [
          {
            "name": "home address",
            "full_address": "my full home address",
            "country": "turkey",
            "city": "kocaeli"
          },
          {
            "name": "work address",
            "full_address": "my full work address",
            "country": "turkey",
            "city": "istanbul"            
          }
        ]

        let myCreditCards = [
          {
            "card_name": "my first card",
            "type": "mastercard",
            "bank": "x bank",
            "card_id": 1234567812345678,
            "date_month": "11",
            "date_year": "21",
            "cvv": "123"
          },
          {
            "card_name": "my second card",
            "type": "visa",
            "bank": "y bank",
            "card_id": 8765432187654321,
            "date_month": "5",
            "date_year": "23",
            "cvv": "456"        
          }
        ]

        this.setState({addresses: myAddresses})
        this.setState({creditCards: myCreditCards})

        axios.get(serverUrl+`api/user/${myCookie.user_id}/`)
          .then(res => {
              console.log("res data:  "+res.data.user_type)
              this.setState({fname : res.data.first_name})
              this.setState({lname : res.data.last_name})
              
              if (res.data.user_type === 1){

                this.setState({user_type: 1});
              } else {
                this.setState({user_type: 2});
                this.setState({company : res.data.company})
                this.setState({isCustomer : false})

              }

          }).catch(err => {
            console.log("error:  "+err)
          })
        

      }

      handleClick = event => {
        alert("clicked");
      }

    render() {

      let addressCards = this.state.addresses.map((address) => {
        return (
          <Col sm="3">
            <div onClick={this.handleClick} className="address-card-wrapper">
              <AddressCard address={address}></AddressCard>
            </div>
          </Col>
        );
      });


      return (
        <div className='background'>
          <CategoryBar></CategoryBar>
            <div className="checkout-container">
              <div className="justify-content-center" id="header3">
                  <h2 className="text-center">Checkout</h2>
              </div>
              <div className="order-form row">

                  <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left border-right">
                      <h3 className="text-center heading-2">Address</h3>
                      <Container fluid>
                        <Row>{addressCards}</Row>
                      </Container>                  
                  </div>
                  <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left">
                    <h3 className="text-center heading-2">Payment</h3>
               
                  </div>
              </div>
                
          </div>
        </div>
          

      );
    }
}