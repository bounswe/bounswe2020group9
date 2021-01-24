import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import { Link } from 'react-router-dom'
import "./addresscard.scss";
import axios from 'axios'
import { serverUrl } from "../../../../utils/get-url";

export default class AddressCard extends Component {

  render() {
    if (this.props.address == '') {
      return (
        <span className="align-middle">
          Select an address
        </span>
      )
    } else {
      return (
        <div>
          <div hidden={!this.props.selected}>
            {this.props.address.address_name}
          </div>
          <Card className="address-card" id={this.props.address.address_name}>
            <Card.Body className="address-card-body overflow-hidden" id={this.props.address.address_name}>
              <Card.Text id={this.props.address.address_name}>
                {this.props.address.address}
              </Card.Text>
            </Card.Body>
            <Card.Footer className="address-card-footer" id={this.props.address.address_name}>
              <div className="footer-text">
                {this.props.address.city}, {this.props.address.country}
              </div>
            </Card.Footer>
          </Card>
    
        </div>
      )
    }

    //console.log("image link: "+imageLink)
 
    
  }

}
