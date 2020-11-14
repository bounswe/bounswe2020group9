import React, { Component } from 'react';
import Pagination from 'react-bootstrap/Pagination'
import Jumbotron from 'react-bootstrap/Jumbotron'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

import myImage from '../../assets/productFiller.svg'

import './home.css'

class Home extends React.Component {

  // constructor(props) {
  //   super(props);
  //   this.state = {date: new active(2)};
  //   let items = [];
  // }



  componentDidMount() {


  }

  render() {
    let active = 2;
    let category = ['Electronics', 'House', 'Kitchen', 'Sport', 'Food', 'Laundry',
      'Garden', 'Books', 'Fitness', 'Cosmetics', 'Fashion', 'New', 'Sale']
    let items = [];
    for (let number = 0; number <= 12; number++) {
      items.push(
        <Pagination.Item key={number} active={number === active}>
          {category[number]}
        </Pagination.Item>,
      );
    }

    return (
      <div>
        <div className='row'>
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
        <div className='row'>
        <Container>
          <Row className="justify-content-md-center myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
          <Row className="justify-content-md-center  myRow">
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
            <Col>
              <Image src={myImage} rounded />
            </Col>
          </Row>
        </Container>
        </div>
      </div>
    );
  }
}

export default Home;
