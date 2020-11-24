import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import myImage from '../../assets/productFiller.svg'

import "./card.css";

export default class CardComponent extends Component {
    constructor(props){
        super(props);
    }
render(){

    let categories = this.props.product.categories.map(category => {
        return (
          <span>'{category}' </span>
        )
      })

    return(
        <div>
            <Card>
            <Card.Img variant="top" src={this.props.myImage} />
            <Card.Body>
                <Card.Title>{this.props.product.name}</Card.Title>
                <Card.Text>
                {categories}
                </Card.Text>
            </Card.Body>
            <Card.Footer>
                <small className="text-muted">{this.props.product.brand}, ${this.props.product.price}</small>
            </Card.Footer>
            </Card>
        </div>
    )
}

}
