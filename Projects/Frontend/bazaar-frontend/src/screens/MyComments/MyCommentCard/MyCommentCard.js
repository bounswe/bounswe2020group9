import React, { Component } from "react";
import "./mycommentcard.scss";
import axios from "axios";

//components
import StarRatings from "../../../../node_modules/react-star-ratings";
import Col from "react-bootstrap/Col";
import Row from "react-bootstrap/Row";
import MyCommentProduct from "../MyCommentProduct/MyCommentProduct";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";
import { serverUrl } from "../../../utils/get-url";

export default class MyCommentCard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      product: {},
    };
  }

  componentDidMount() {
    let myCookie = read_cookie("user");

    axios
      .get(serverUrl + `api/product/${this.props.comment.product}/`, {
        headers: {
          Authorization: `Token ${myCookie.token}`,
        },
      })
      .then((res) => {
        this.setState({ product: res.data });
      });
  }

  render() {
    return (
      <div className={"commentWrapper"}>
        <Col>
          <Row className={"commentRate"}>
            <StarRatings
              rating={this.props.comment.rating}
              starDimension="40px"
              starSpacing="10px"
              starRatedColor="#FFA41B"
              starDimension="20px"
              starSpacing="1px"
            />
          </Row>

          <Row className={"commentDate"}>
            {this.props.comment.timestamp.substring(0, 10)}
          </Row>

          <Row className={"commentContent"}>{this.props.comment.body}</Row>
        </Col>
        <Col>
          <Row>
            {this.state.product && (
              <MyCommentProduct product={this.state.product}></MyCommentProduct>
            )}
          </Row>
        </Col>
      </div>
    );
  }
}
