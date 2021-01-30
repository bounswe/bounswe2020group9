import React, { Component } from "react";
import Card from "react-bootstrap/Card";
import { Link } from "react-router-dom";
import "./productCard.scss";
import { serverUrl } from "../../utils/get-url";

export default class CardComponent extends Component {
  render() {
    //console.log("category name: "+this.props.product?.category["name"])
    let imageLink;
    let incomingLink = this.props.product.picture;
    if (incomingLink) {
      //console.log("picture link: "+this.props.product.picture.substring(0,4))

      if (incomingLink.substring(0, 4) === "http") {
        imageLink = incomingLink;
      } else {
        imageLink = serverUrl + "media/" + incomingLink;
      }
    } else {
      imageLink = "";
    }
    this.props.product.picture = imageLink;
    let categoryName = "";
    if (this.props.product.category) {
      categoryName = this.props.product.category["name"];
    }

    //console.log("image link: "+imageLink)

    return (
      <div>
        <Link
          to={{
            pathname: `/product/${this.props.product.id}`,
            state: { product: this.props.product },
          }}
        >
          <Card className={"productCard"}>
            <div className={"productImgWrapper"}>
              <Card.Img
                className={"productCardImage"}
                variant="top"
                src={this.props.product.picture}
              />
            </div>
            <Card.Body className={"productCardBody"}>
              <Card.Title>{this.props.product.name}</Card.Title>
              <Card.Text>{this.categoryName}</Card.Text>
            </Card.Body>
            <Card.Footer className={"productCardFooter"}>
              <small className="text-muted">{this.props.product.brand}, </small>
              <small className="text-muted productCardPrice">
                ₺{this.props.product.price}
              </small>
            </Card.Footer>
          </Card>
        </Link>
      </div>
    );
  }
}
