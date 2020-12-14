import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import { Link } from 'react-router-dom'
import "./productCard.scss";

export default class CardComponent extends Component {

render(){

    return(
        <div>
            <Link to={`/product${this.props.product.id}`} params={{product: this.props.product}}>
            <Card className={"productCard"}>
            <div className={"productImgWrapper"}>
                <Card.Img className={"productCardImage"} variant="top" src={this.props.product.picture} />
            </div>
            <Card.Body className={"productCardBody"}>
                <Card.Title>{this.props.product.name}</Card.Title>
                <Card.Text>
                    {this.props.product.category["name"]}
                </Card.Text>
            </Card.Body>
            <Card.Footer className={"productCardFooter"}>
                <small className="text-muted">{this.props.product.brand},  </small>
                <small className="text-muted productCardPrice">${this.props.product.price}</small>
            </Card.Footer>
            </Card>
            </Link>

        </div>
    )
}

}
