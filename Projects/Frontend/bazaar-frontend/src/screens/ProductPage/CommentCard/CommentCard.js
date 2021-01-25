import React, { Component } from "react";
import "./commentCard.scss";

//components
import Row from "react-bootstrap/Row";
import StarRatings from "../../../../node_modules/react-star-ratings";

export default class CommentCard extends Component {
  render() {
    return (
      <div className={"commentWrapper"}>
        {!this.props.comment.is_anonymous ? (
          <Row className={"commentName"}>
            {this.props.comment.first_name}{" "}
            {this.props.comment.last_name.substring(0, 1)}******{" "}
          </Row>
        ) : (
          <Row className={"commentName"}>*Anonimous*</Row>
        )}

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
      </div>
    );
  }
}
