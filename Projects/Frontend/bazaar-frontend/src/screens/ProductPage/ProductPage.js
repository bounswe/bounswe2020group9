import React, { Component } from 'react'
import "./productpage.scss"
import myImg from "../../assets/productFiller.svg"

import Carousel from 'react-bootstrap/Carousel'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import axios from 'axios'

import Header from "../../components/Header/Header"


export default class Productpage extends Component {

  constructor(props) {
    super(props);
    this.state = {
      productData: [],
    };
  }

  componentDidMount() {
    this.setState({ productData: this.props.location.state.product })
  }

  render() {

    console.log(this.state.productData)

    return (
      <div>
        <Header />
        <Container>
          <Row>
            <Col>
              <Carousel className={"productCarousel"}>
                <Carousel.Item interval={1000}>
                  <img
                    className="d-block w-100"
                    src={this.state.productData.picture}
                    alt="First slide"
                  />
                  <Carousel.Caption>
                    <h3>First slide label</h3>
                    <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
                  </Carousel.Caption>
                </Carousel.Item>
                <Carousel.Item interval={500}>
                  <img
                    className="d-block w-100"
                    src={this.state.productData.picture}
                    alt="Third slide"
                  />
                  <Carousel.Caption>
                    <h3>Second slide label</h3>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                  </Carousel.Caption>
                </Carousel.Item>
                <Carousel.Item>
                  <img
                    className="d-block w-100"
                    src={this.state.productData.picture}
                    alt="Third slide"
                  />
                  <Carousel.Caption>
                    <h3>Third slide label</h3>
                    <p>Praesent commodo cursus magna, vel scelerisque nisl consectetur.</p>
                  </Carousel.Caption>
                </Carousel.Item>
              </Carousel>
            </Col>

            <Col className={"productInfo"}>
              <Container>
                <h2 className={"productHeader"}>{this.state.productData.name}</h2>
                <h5 className={"productBrand"}>{this.state.productData.brand}</h5>
                <h5 className={"productPrice"}>Price: <span>{this.state.productData.price}</span></h5>

              </Container>
            </Col>
          </Row>
        </Container>

      </div>
    )
  }
}
