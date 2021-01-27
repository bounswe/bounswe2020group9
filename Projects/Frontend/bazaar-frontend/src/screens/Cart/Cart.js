import React, { Component } from "react";
import "./cart.scss";
import axios from "axios";
import { Redirect } from "react-router-dom";

//components
import Col from "react-bootstrap/Col";
import ProductCard from "../../components/ProductCard/productCard";
import Row from "react-bootstrap/Row";
import Container from "react-bootstrap/Container";
import Card from "react-bootstrap/Card";
import Button from "react-bootstrap/Button";
import CategoryBar from "../../components/category-bar/category-bar";


//helpers
import { serverUrl } from "../../utils/get-url";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";

export default class Cart extends Component {
  constructor(props) {
    super(props);

    this.state = {
      products: [],
      cartItemDeleted: false,
      cart: [],
    };
  }

  componentDidMount() {
    axios.get(serverUrl + `api/product/`).then((res) => {
      this.setState({ products: res.data });
    });

    const { cart } = this.props.location.state;

    this.setState({ cart });
  }

  deleteFromCart(id) {
    console.log("I am HERE");
    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    const data = {
      product_id: id,
    };
    axios
      .delete(serverUrl + `api/user/cart/`, {
        headers: headers,
        data: data,
      })
      .then((res) => {
        this.setState({ cart: res.data });
      });
  }

  render() {
    const { cart } = this.state;

    let productIds = cart.map((product) => product.product);
    let filteredProducts = this.state.products?.filter((product) =>
      productIds.includes(product.id)
    );

    let totalAmount = 0;

    let productCards = filteredProducts.map((product) => {
      totalAmount += product.price;
      return (
        <Col sm="3">
          <ProductCard product={product}></ProductCard>
          <Button
            variant="danger"
            onClick={() => this.deleteFromCart(product.id)}
            style={{ marginBottom: "2rem" }}
          >
            Delete From Cart
          </Button>
        </Col>
      );
    });

    return (
      <div>
        <CategoryBar></CategoryBar>

        <div className="cartWrapper">
          <Container>
            <Row>{productCards}</Row>

            <Card style={{ width: "18rem" }}>
              <Card.Body>
                <Card.Title>Total: ₺{totalAmount}</Card.Title>
                <a href="/checkout" hidden={this.state.cart.length == 0}>
                  <Button variant="success" style={{ marginRight: "20px" }} >
                    Buy
                  </Button>
                </a>
                <Button variant="danger" hidden={this.state.cart.length == 0}>Empty Cart</Button>
              </Card.Body>
            </Card>
          </Container>
        </div>
      </div>
    );
  }
}
