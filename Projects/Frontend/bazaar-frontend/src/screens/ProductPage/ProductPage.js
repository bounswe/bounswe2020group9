import React, { Component } from "react";
import "./productpage.scss";
import { Redirect } from "react-router-dom";
import axios from "axios";

//components
import StarRatings from "../../../node_modules/react-star-ratings";
import Carousel from "react-bootstrap/Carousel";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";
import CommentCard from "./CommentCard/CommentCard";
import CategoryBar from "../../components/category-bar/category-bar";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";

//icons
import AddToCartIcon from "../../assets/icons/add-to-cart.svg";
import RemoveFromCartIcon from "../../assets/icons/remove-from-cart.svg";
import AddToListIcon from "../../assets/icons/add-to-list-hand-drawn-interface-symbol.svg";

//helpers
import { serverUrl } from "../../utils/get-url";

export default class Productpage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isGuest: false,
      comments: [],
      newComment: {
        body: "",
        rating: "",
        is_anonymous: false,
      },
      user: [],
    };
  }

  componentDidMount = () => {
    let myCookie = read_cookie("user");
    this.setState({ user: myCookie });
    // get request to get all comments
    axios
      .get(
        serverUrl +
          `api/product/comment/${this.props.location.state.product.id}/`
      )
      .then((res) => {
        console.log(res.data);
        this.setState({ comments: res.data });
      });
  };

  onCartButtonClick = () => {
    const { product } = this.props.location.state;

    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    const data = {
      product_id: product.id,
      amount: 1,
    };

    if (myCookie.length === 0) {
      this.setState({ isGuest: true });
    } else {
      axios
        .post(serverUrl + `api/user/cart/`, data, {
          headers: headers,
        })
        .then((res) => {
          this.setState({ redirect: "/" });
        });
    }
  };

  onListButtonClick = () => {
    let myCookie = read_cookie("user");
    if (myCookie.length === 0) {
      this.setState({ isGuest: true });
    } else {
    }
  };

  onAddCommentButton = () => {
    const { product } = this.props.location.state;

    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    const data = {
      product_id: product.id,
      amount: 1,
    };

    if (myCookie.length === 0) {
      this.setState({ isGuest: true });
    } else {
      axios
        .post(serverUrl + `api/product/comment/`, data, {
          headers: headers,
        })
        .then((res) => {
          this.setState({
            redirect: `/product/${this.props.location.state.id}`,
          });
        });
    }
  };

  render() {
    const { product } = this.props.location.state;

    if (this.state.isGuest) {
      return <Redirect to="/signIn" />;
    }

    let CommentCards = this.state.comments.map((comment) => {
      return (
        <Row style={{ marginLeft: 0 }}>
          <CommentCard comment={comment}></CommentCard>
        </Row>
      );
    });

    let categoryName = "";
    let categoryParent = "";

    if (product.category) {
      categoryName = product.category.name;
      categoryParent = product.category.parent;
    }

    return (
      <div className="background">
        <Container>
          <CategoryBar></CategoryBar>
          <Row className={"productPart"}>
            <Col>
              <Carousel className={"productCarousel"}>
                <Carousel.Item interval={1000}>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="First slide"
                  />
                </Carousel.Item>
                <Carousel.Item interval={500}>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="Third slide"
                  />
                </Carousel.Item>
                <Carousel.Item>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="Third slide"
                  />
                </Carousel.Item>
              </Carousel>
            </Col>

            <Col className={"productInfo"}>
              <Container
                style={{
                  display: "flex",
                  flexDirection: "column",
                  height: "100%",
                }}
              >
                <div style={{ flex: "1" }}>
                  <Row>
                    <Col style={{ width: "max-content" }}>
                      <h2 className={"productHeader"}>{product.name}</h2>
                    </Col>
                    <Col>
                      <h5 className={"productCategory"}>
                        <span className={"productCategoryName"}>
                          {categoryName}
                        </span>{" "}
                        <span className={"productCategoryParent"}>
                          {categoryParent}
                        </span>
                      </h5>
                    </Col>
                  </Row>
                  <h5 className={"productBrand"}>{product.brand}</h5>
                  <StarRatings
                    rating={product.rating}
                    starDimension="40px"
                    starSpacing="15px"
                    starRatedColor="#FFA41B"
                    starDimension="20px"
                    starSpacing="2px"
                  />
                  <h5 className={"productPrice"}>
                    <span className={"productPriceName"}>Price: </span>
                    <span className={"productPriceAmount"}>
                      {" "}
                      ₺{product.price}
                    </span>
                  </h5>
                </div>

                <div>
                  <Row>
                    <Col>
                      <button
                        className={"productButton"}
                        onClick={this.onCartButtonClick}
                      >
                        <span>Add to Cart</span>
                        <img src={AddToCartIcon} />
                      </button>
                    </Col>
                    <Col>
                      <button
                        className={"productButton"}
                        onClick={this.onListButtonClick}
                      >
                        <span>Add to List</span>
                        <img src={AddToListIcon} />
                      </button>
                    </Col>
                  </Row>
                </div>
              </Container>
            </Col>
          </Row>
          <Row className={"commentPart"}>
            <Col>
              <Row>
                <h2>Comments</h2>
              </Row>
              {CommentCards}
              {this.state.user.length === 0 ? (
                <div></div>
              ) : (
                <div>
                  <Form className="formWrapper">
                    <Form.Row className="align-items-center formRow">
                      <Col xs="auto" className="my-1">
                        <Form.Label
                          className="mr-sm-2"
                          htmlFor="inlineFormCustomSelect"
                          srOnly
                        >
                          Preference
                        </Form.Label>
                        <Form.Control
                          as="select"
                          className="mr-sm-2"
                          id="inlineFormCustomSelect"
                          custom
                        >
                          <option value="0">Rating...</option>
                          <option value="1">1</option>
                          <option value="2">2</option>
                          <option value="3">3</option>
                          <option value="2">4</option>
                          <option value="3">5</option>
                        </Form.Control>
                      </Col>
                      <Col xs="auto" className="my-1">
                        <Form.Check
                          type="switch"
                          id="custom-switch"
                          label="Check this switch"
                        />
                      </Col>
                      <Col xs="auto" className="my-1">
                        <Button type="submit">Submit</Button>
                      </Col>
                    </Form.Row>

                    <Form.Row className="formRow">
                      <Col>
                        <Form.File
                          id="custom-file-translate-scss"
                          label="Please upload an image"
                          lang="en"
                          custom
                        />
                      </Col>
                    </Form.Row>

                    <Form.Row controlId="exampleForm.ControlTextarea1 formRow">
                      <Col>
                        <Form.Label>Comment</Form.Label>
                        <Form.Control as="textarea" rows={4} />
                      </Col>
                    </Form.Row>
                  </Form>
                </div>
              )}
            </Col>
          </Row>
        </Container>
      </div>
    );
  }
}
