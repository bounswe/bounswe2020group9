import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import { Link } from 'react-router-dom'
import "./addresscard.scss";
import axios from 'axios'
import { serverUrl } from "../../../../utils/get-url";

export default class AddressCard extends Component {


  render() {
    //console.log("category name: "+this.props.product?.category["name"])


    //console.log("image link: "+imageLink)
 
    return (
      <div>
      
        <Card className="address-card">
          <Card.Body className="address-card-body">
            <Card.Title>{this.props.address.name}</Card.Title>
            <Card.Text>
              {this.props.address.full_address}
            </Card.Text>
          </Card.Body>
          <Card.Footer className={"address-card-footer"}>
            <small className="text-muted address-card-country">{this.props.address.country},  </small>
            <small className="text-muted address-card-city">₺{this.props.address.city}</small>
          </Card.Footer>
        </Card>

      </div>
    )
  }

}
