import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import "./card.css";

export default class CardComponent extends Component {

render(){

    let num = this.props.product.id;
    let image = "image"+num;
    console.log(image);

    let categories = this.props.product.categories.map(category => {
        return (
          <span>'{category}' </span>
        )
      })

    return(
        <div>
            <Card>
                {}
            <Card.Img variant="top" src={image} />
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
