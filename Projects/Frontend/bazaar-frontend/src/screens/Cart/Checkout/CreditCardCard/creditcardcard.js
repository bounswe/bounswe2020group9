import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import { Link } from 'react-router-dom'
import "./creditcardcard.scss";
import axios from 'axios'
import { serverUrl } from "../../../../utils/get-url";
import CreditCard from 'react-credit-cards';

export default class CreditCardCard extends Component {


  render() {
    //console.log("category name: "+this.props.product?.category["name"])


    //console.log("image link: "+imageLink)
      if (this.props.creditCard == '') {
        return (
          <div>
            please select a card
          </div>
        )
      } else {
        return (
        <div>
          <div hidden={!this.props.selected}>
            {this.props.creditCard.card_name}
          </div>
          <Card className="creditcard-card">
            <Card.Body className="creditcard-card-body">
              <Card.Text>
                <div className="credit-card">
                  <CreditCard 
                    cvc={this.props.creditCard.cvc}
                    expiry={this.props.creditCard.expiry}
                    // focused={creditCard.focus}
                    name={this.props.creditCard.name_on_card}
                    number={this.props.creditCard.card_id}
                  />
                </div>
              </Card.Text>
            </Card.Body>
          </Card>
        </div>

        )
      }

  }

}
