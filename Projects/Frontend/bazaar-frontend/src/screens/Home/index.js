import React, { Component } from 'react';
import Pagination from 'react-bootstrap/Pagination'
import Jumbotron from 'react-bootstrap/Jumbotron'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import CardDeck from 'react-bootstrap/CardDeck'
import axios from 'axios'
import Card from "../../components/Card"

import myImage from '../../assets/productFiller.svg'


import './home.css'

import image3 from '../../assets/images/3.jfif'
import image4 from '../../assets/images/4.jfif'
import image5 from '../../assets/images/5.jpg'
import image6 from '../../assets/images/6.png'
import image7 from '../../assets/images/7.jpg'
import image8 from '../../assets/images/8.png'
import image9 from '../../assets/images/9.png'
import image10 from '../../assets/images/10.png'
import image11 from '../../assets/images/11.png'
import image12 from '../../assets/images/12.png'
import image13 from '../../assets/images/13.png'
import image14 from '../../assets/images/14.png'
import image15 from '../../assets/images/15.jpg'
import image16 from '../../assets/images/16.png'
import image17 from '../../assets/images/17.png'
import image18 from '../../assets/images/18.jpg'
import image19 from '../../assets/images/19.png'
import image20 from '../../assets/images/20.png'

class Home extends React.Component {

  constructor() {
    super();
    this.state = {
      isLogged: 'yes',
      redirect: null,
      products: []
    }
  }


  componentDidMount() {
    axios.get(`http://13.59.236.175:8000/api/product/`)
      .then(res => {
        console.log(res.data[1].brand)
        this.setState({ products: res.data })
        console.log(this.state.products[0])
      })

  }

  render() {
    let active = 2;
    let category = ['Books', 'Petshop', 'Clothing', 'Health', 'Home', 'Electronics', 'Consumables']
    let items = [];
    for (let number = 0; number <= 6; number++) {
      items.push(
        <Pagination.Item key={number}>
          {category[number]}
        </Pagination.Item>,
      );
    }



    let productCards = this.state.products.map(product => {
      if (product.id === 3) {
        return (
          <Col sm="3">
            <Card product={product} myImage={image3}></Card>
          </Col>
        )
      }
      else if (product.id === 4) {
        return (
        <Col sm="3">
          <Card product={product} myImage={image4}></Card>
        </Col>
        )
      }
      else if (product.id === 5) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image5}></Card>
        </Col>
        )
      }
      else if (product.id === 6) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image6}></Card>
        </Col>
        )
      }
      else if (product.id === 7) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image7}></Card>
        </Col>
        )
      }
      else if (product.id === 8) {
        return(
          <Col sm="3">
          <Card product={product} myImage={image8}></Card>
        </Col>
        )
      }
      else if (product.id === 9) {
        return(
      <Col sm="3">
        <Card product={product} myImage={image9}></Card>
      </Col>)
      }
      else if (product.id === 10) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image10}></Card>
        </Col>
        )
      }
      else if (product.id === 11) {
      return(
      <Col sm="3">
        <Card product={product} myImage={image11}></Card>
      </Col>
      )
      }
      else if (product.id === 12) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image12}></Card>
        </Col>
        )
      }
      else if (product.id === 13) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image13}></Card>
        </Col>
        )
      }
      else if (product.id === 14) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image14}></Card>
        </Col>
        )
      }
      else if (product.id === 15) {
        return(
        <Col sm="3">
          <Card product={product} myImage={image15}></Card>
        </Col>
        )
      }
      else if (product.id === 16) {
        return(
          <Col sm="3">
            <Card product={product} myImage={image16}></Card>
          </Col>
          )
      }
      else if (product.id === 17) {
        return(
          <Col sm="3">
            <Card product={product} myImage={image17}></Card>
          </Col>
          )
      }
      else if (product.id === 18) {
        return(
          <Col sm="3">
            <Card product={product} myImage={image18}></Card>
          </Col>
          )
      }
      else if (product.id === 19) {
        return(
          <Col sm="3">
            <Card product={product} myImage={image19}></Card>
          </Col>
          )
      }
      else if (product.id === 20) {
        return(
          <Col sm="3">
            <Card product={product} myImage={image20}></Card>
          </Col>
          )
      }
      else {
        return(
          <Col sm="3">
            <Card product={product} myImage={image20}></Card>
          </Col>
          )
      }

    })

    return (

      <div>
        <div className=''>
          <Container>
            <div className='myPagination'>
              <Pagination size="lg">{items}</Pagination>
            </div>
            <div className='row'>
              <Jumbotron>
                <h1>Welcome to Bazaar!</h1>
                <p>
                  "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and
                  demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee
                  the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty
                  through weakness of will, which is the same as saying through shrinking from toil and pain. These cases
                  are perfectly simple and easy to distinguish
              </p>
                <p>
                  <Button variant="primary">Learn more</Button>
                </p>
              </Jumbotron>
            </div>
            <Container fluid>
              <Row>
                {productCards}
              </Row>
            </Container>
          </Container>
        </div>
      </div>
    );

  }
}


export default Home;
