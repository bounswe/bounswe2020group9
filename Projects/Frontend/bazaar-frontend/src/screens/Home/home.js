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
    axios.get(serverUrl + "api/product/categories/").then((res) => {
      let resp = res.data;
      let categoryStructureTemp = {};
      let keys = [];
      let categoryDictTemp = {};
      for (let i = 0; i < resp.length; i++) {
        if (resp[i]["parent"] == "Categories") {
          keys.push(resp[i]["name"]);
          categoryDictTemp[resp[i]["id"]] = resp[i]["name"];
        }
      }
      this.setState({ categoryList: keys });
      this.setState({ categoryDict: categoryDictTemp });
      for (let i = 0; i < keys.length; i++) {
        let sublist = [];
        for (let j = 0; j < resp.length; j++) {
          if (resp[j]["parent"] == keys[i]) {
            sublist.push(resp[j]["name"]);
          }
        }
        categoryStructureTemp[keys[i]] = sublist;
      }
      categoryStructureTemp[""] = [];
      console.log("category structure: " + categoryStructureTemp);

      this.setState({ categoryStructure: categoryStructureTemp });
    });
  }

  render() {
    let active = 2;
    let categoryList = this.state.categoryList;
    let categoryStructure = this.state.categoryStructure;
    let categories = [];
    for (let number = 0; number < categoryList.length; number++) {
      let subs = [];
      let subList = categoryStructure[categoryList[number]];
      if (subList) {
        for (let subnumber = 0; subnumber < subList.length; subnumber++) {
          subs.push(
            <a
              className="dropdown-item"
              href={"/category/" + subList[subnumber]}
            >
              {subList[subnumber]}
            </a>
          );
        }
      }

      categories.push(
        <Pagination.Item
          key={number}
          className="myPaginationItem dropdown"
          href = {"/category/" + categoryList[number]}
        >
          <a
            className="nav-link dropdown-toggle"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            <span className="mr-1"></span> {categoryList[number]}
          </a>
          <div className="dropdown-menu">{subs}</div>
        </Pagination.Item>
      );
    }

    let categoryDict = this.state.categoryDict;
    let productCards = this.state.products.map((product) => {
      console.log(JSON.stringify(product));
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
            <div className="myPagination">
              <Pagination size="lg">{categories}</Pagination>
            </div>
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
