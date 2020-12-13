import React, { Component } from 'react'
import "./productpage.scss"
import myImg from "../../assets/productFiller.svg"

import Carousel from 'react-bootstrap/Carousel'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

export default class Productpage extends Component {

    render() {
        console.log(this.props);
        return (
            <div>
                <Container>
                <Row>
                    <Col>
                    <Carousel className={"productCarousel"}>
                <Carousel.Item interval={1000}>
                    <img
                    className="d-block w-100"
                    src={myImg}
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
                    src={myImg}
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
                    src={myImg}
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
                    Product Info
                    </Col>
                </Row>
                </Container>
                
            </div>
        )
    }
}
