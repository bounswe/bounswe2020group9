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
        <div>
          please select a card
        </div>
      )
    } else {
      return (
        <div>
          <div hidden={!this.props.selected}>
            {this.props.address.name}
          </div>
          <Card className="address-card">
            <Card.Body className="address-card-body overflow-hidden">
              <Card.Text>
                {this.props.address.full_address}
              </Card.Text>
            </Card.Body>
            <Card.Footer className="address-card-footer">
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
