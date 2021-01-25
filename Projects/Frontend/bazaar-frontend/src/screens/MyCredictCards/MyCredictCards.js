import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import { serverUrl } from '../../utils/get-url'
import { Button, Alert } from "react-bootstrap";
import CategoryBar from "../../components/category-bar/category-bar";
import Card from 'react-bootstrap/Card'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Form from 'react-bootstrap/Form'
import Cards from 'react-credit-cards';

import 'react-credit-cards/es/styles-compiled.css';


import ListGroup from 'react-bootstrap/ListGroup'


export default class MyCredictCards extends Component {


    constructor(props) {
        super(props);
        this.state = {
            id: '',
            owner_id: '',
            name_on_card: '',
            card_name: '',
            card_id: '',
            date_month: '',
            date_year: '',
            cvv: '',
            user_type: '',


            selectedCards: {},
            CreditCards: [],
            adding: false,

            cvc: '',
            expiry: '',
            focus: '',
            name: '',
            number: '',

        };
    }
    
    handleChange = event => {
  
      event.preventDefault();
      let selectedCards = this.state.selectedCards;
      selectedCards[event.target.name] = event.target.value;
  
      this.setState({ selectedCards: selectedCards });
  
    } 

    handleSubmit = event => {
        event.preventDefault();
        const body = new FormData();
        console.log("user_type: " + this.state.user_type)
    
        let myCookie = read_cookie('user');
        const header = {
          headers: {
            Authorization: "Token " + myCookie.token
          }
        };
        
        
        body.append("owner", myCookie.user_id);
        body.append("card_id", this.state.selectedCards.card_id);
        body.append("name_on_card", this.state.selectedCards.name_on_card);
        body.append("date_month", this.state.selectedCards.date_month);
        body.append("date_year", this.state.selectedCards.date_year);
        body.append("cvv", this.state.selectedCards.cvv);
        body.append("card_name", this.state.selectedCards.card_name);

    
        if (this.state.adding) {
          axios.post(serverUrl + 'api/product/payment/', body, header)
            .then(res => {
    
              console.log(res);
              console.log(res.data);
    
              axios.get(serverUrl + `api/product/payment/`, header)
                .then(res => {
                  console.log(res);
                  console.log(res.data);
    
                  this.setState({ CreditCards: res.data });
    
    
                }).catch(err => {
                  console.log("error:  " + err)
                })
    
    
            }).catch(err => {
              console.log("error:  " + err)
            })
        }
        else {
          axios.put(serverUrl + 'api/product/payment/' , body, header)
            .then(res => {
    
              console.log(res);
              console.log(res.data);

              
    
    
            }).catch(err => {
              console.log("error:  " + err)
            })
    
    
        }
      }

    
    componentDidMount() {
      let myCookie = read_cookie('user');
      const header = {
        headers: {
          Authorization: "Token " + myCookie.token
        }
      };
      axios.get(serverUrl + `api/product/payment/`, header)
        .then(res => {
          console.log(res);
          console.log(res.data);
  
          this.setState({ CreditCards: res.data });
  
  
        }).catch(err => {
          console.log("error:  " + err)
        })
  
  
    } 
    /*
    handleInputFocus = (e) => {
        this.setState({ focus: e.target.name });
    }

    handleInputChange = (e) => {
        const { name, value } = e.target;

        this.setState({ [name]: value });
    }*/

    render() {


        let cardNames = this.state.CreditCards?.map(card_name => {
            return (
              <button className={"listButton"} onClick={() => this.setState({ selectedCards: card_name, adding: false })}><ListGroup.Item>{card_name.card_name}</ListGroup.Item></button>
            )
      
      
          })
      
          let emptyCard = {
            name_on_card: '',
            card_name: '',
            card_id: '',
            date_month: '',
            date_year: '',
            cvv: '',
            owner:'',
          }
      
          cardNames?.push(
      
            <button className={"listButton"} onClick={() => this.setState({ selectedCards: emptyCard, adding: true })}><ListGroup.Item>Add New Credit Card</ListGroup.Item></button>
      
          )

        return (
            <div className='background'>
                <CategoryBar></CategoryBar>
                <Row className={"listWrapper"}>
                    <Col xs={4} className={'lists'}>
                        <h2>My Credict Cards</h2>
                        <ListGroup variant="flush">
                            {cardNames}
                        </ListGroup>
                    </Col>
                <Col xs={6} className={'addCredictCard'}>
                    <Form onSubmit={this.handleSubmit}> 
                    
                        <Cards
                            cvc={this.state.selectedCards.cvc}
                            month={this.state.selectedCards.date_month }
                            focused={this.state.selectedCards.card_id}
                            name={this.state.selectedCards.name_on_card}
                            number={this.state.number}
                        />

                    
                        <Form.Group controlId="formGridCname">
                            <Form.Label>Card Number</Form.Label>
                            <Form.Control type="text" name="card_name" placeholder="VISA / MASTER"
                                onChange={this.handleChange}
                                value={this.state.selectedCards.card_name} />
                        </Form.Group>
                        
                        <Form.Group controlId="formGridCid">
                            <Form.Label>Card Number</Form.Label>
                            <Form.Control type="text" name="card_id" placeholder="Card Number"
                                onChange={this.handleChange}
                                value={this.state.selectedCards.card_id} />
                        </Form.Group>

                        <Form.Group controlId="formGridCname">
                            <Form.Label>Name on Card </Form.Label>
                            <Form.Control type="text" name="name_on_card" placeholder="Name on Card"
                                onChange={this.handleChange}
                                value={this.state.selectedCards.name_on_card} />
                        </Form.Group>

                        <Form.Row>
                            <Form.Group as={Col} controlId="formGridmonth">
                                <Form.Label>Month</Form.Label>
                                <Form.Control type="text" name="date_month"
                                    onChange={this.handleChange}
                                    value={this.state.selectedCards.date_month} />
                            </Form.Group>

                            <Form.Group as={Col} controlId="formGridyear">
                                <Form.Label>Year</Form.Label>
                                <Form.Control type="text" name="date_year"
                                    onChange={this.handleChange}
                                    value={this.state.selectedCards.date_year}>

                                </Form.Control>
                            </Form.Group>

                            <Form.Group as={Col} controlId="formGrid">
                                <Form.Label>Cvc</Form.Label>
                                <Form.Control type="text" name="cvv"
                                    onChange={this.handleChange}
                                    value={this.state.selectedCards.cvv} />
                            </Form.Group>
                        </Form.Row>

                        <Button variant="primary" type="submit">
                            Submit
                          </Button>

                        <Button variant="danger" onClick={this.deleteCards} hidden={this.state.adding}>
                            Delete
                        </Button>


                    </Form>






                </Col>
                </Row>

            </div>

        )
    }


}
