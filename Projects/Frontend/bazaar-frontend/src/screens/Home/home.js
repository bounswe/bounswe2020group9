import React, { Component } from "react";
import Pagination from "react-bootstrap/Pagination";
import Jumbotron from "react-bootstrap/Jumbotron";
import Button from "react-bootstrap/Button";
import Image from "react-bootstrap/Image";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import CardDeck from "react-bootstrap/CardDeck";
import axios from "axios";
import Card from "../../components/ProductCard/productCard";
import CategoryBar from "../../components/category-bar/category-bar";
import { serverUrl } from "../../utils/get-url";
import { Link } from "react-router-dom";

import "./home.scss";

class Home extends Component {
  constructor() {
    super();
    this.state = {
      isLogged: "yes",
      redirect: null,
      categoryList: [],
      categoryHidden: true,
      categoryDict: {},
      categoryStructure: { "": [] },
      products: [],
    };
  }

  componentDidMount() {
    axios.get(serverUrl + `api/product/`).then((res) => {
      this.setState({ products: res.data });
    });
  }

  render() {

    
    let productCards = this.state.products.map((product) => {
      return (
        <Col sm="3">
          <Card product={product}></Card>
        </Col>
      );
    });

    return (
      <div>
        <div className="background">
          <Container>
           <CategoryBar></CategoryBar>
            <div className="row homeJumbotron">
              <Jumbotron style={{ background: "transparent" }}>
                <h1>Welcome to Bazaar!</h1>
                <p>
                  Bazaar is a compatile, fast and user-friendly e-commerce
                  website. It's been developed by group of people who concern
                  about good user experience and better design because we care
                  people's eyes!
                </p>
                <p>
                  <Button variant="outline-info">Learn more</Button>
                </p>
              </Jumbotron>
            </div>
            <Container fluid>
              <Row>{productCards}</Row>
            </Container>
          </Container>
        </div>
      </div>
    );
  }
}

export default Home;
