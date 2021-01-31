import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import "./creditcardcard.scss";
import CreditCard from 'react-credit-cards';

export default class CreditCardCard extends Component {


  render() {
    //console.log("category name: "+this.props.product?.category["name"])


    //console.log("image link: "+imageLink)
      if (this.props.creditCard === '') {
        return (
          <span className="align-middle">
            Select a card
          </span>
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
                    cvv={this.props.creditCard.cvv}
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
