import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import "./card.css";

export default class CardComponent extends Component {

render(){

    return(
        <div>
            <Card style={{height: '26rem' }}>
            <Card.Img variant="top" src={this.props.product.picture} />
            <Card.Body>
                <Card.Title>{this.props.product.name}</Card.Title>
                <Card.Text>
                    {this.props.product.category["name"]}
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
