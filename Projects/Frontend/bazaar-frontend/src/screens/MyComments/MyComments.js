import React, { Component } from "react";
import "./mycomments.scss";
import axios from "axios";

//components
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import MyCommentCard from "./MyCommentCard/MyCommentCard";

//helpers
import { serverUrl } from "../../utils/get-url";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";

export default class MyComment extends Component {
  constructor(props) {
    super(props);
    this.state = {
      comments: [],
    };
  }

  componentDidMount() {
    let myCookie = read_cookie("user");

    axios
      .get(serverUrl + `api/product/comment/user/${myCookie.user_id}/all/`)
      .then((res) => {
        this.setState({ comments: res.data });
      });
  }

  render() {
    let CommentCards = this.state.comments.map((comment) => {
      return (
        <Row style={{ marginLeft: 0 }}>
          <MyCommentCard comment={comment}></MyCommentCard>
        </Row>
      );
    });

    return (
      <div>
        <Container>
          <Row className={"commentPart"}>
            <Col>
              <Row>
                <h2>My Comments</h2>
              </Row>
              {CommentCards}
            </Col>
          </Row>
        </Container>
      </div>
    );
  }
}
