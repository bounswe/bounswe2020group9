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
      comments: [
        {
          name: "Hasan Demirkiran",
          rate: 4.5,
          date: "20.01.2020",
          content:
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure",
        },
        {
          name: "Hasan Demirkiran",
          rate: 3.0,
          date: "20.01.2020",
          content:
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure",
        },
        {
          name: "Hasan Demirkiran",
          rate: 5.0,
          date: "20.01.2020",
          content:
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure",
        },
      ],
    };
  }

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
      <div className='background'>
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
              <h2>Comments</h2>
              {CommentCards}
            </Col>
          </Row>
        </Container>
      </div>
    );
  }
}
