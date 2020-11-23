import React, { Component } from 'react';
import Pagination from 'react-bootstrap/Pagination'
import Jumbotron from 'react-bootstrap/Jumbotron'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Card from 'react-bootstrap/Card'
import CardDeck from 'react-bootstrap/CardDeck'

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
        <Container>
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
        <CardDeck>
        <Card>
          <Card.Img variant="top" src={myImage} />
          <Card.Body>
            <Card.Title>Card title</Card.Title>
            <Card.Text>
              This is a wider card with supporting text below as a natural lead-in to
              additional content. This content is a little bit longer.
            </Card.Text>
          </Card.Body>
          <Card.Footer>
            <small className="text-muted">Last updated 3 mins ago</small>
          </Card.Footer>
        </Card>
        <Card>
          <Card.Img variant="top" src={myImage} />
          <Card.Body>
            <Card.Title>Card title</Card.Title>
            <Card.Text>
              This card has supporting text below as a natural lead-in to additional
              content.{' '}
            </Card.Text>
          </Card.Body>
          <Card.Footer>
            <small className="text-muted">Last updated 3 mins ago</small>
          </Card.Footer>
        </Card>
        <Card>
          <Card.Img variant="top" src={myImage} />
          <Card.Body>
            <Card.Title>Card title</Card.Title>
            <Card.Text>
              This is a wider card with supporting text below as a natural lead-in to
              additional content. This card has even longer content than the first to
              show that equal height action.
            </Card.Text>
          </Card.Body>
          <Card.Footer>
            <small className="text-muted">Last updated 3 mins ago</small>
          </Card.Footer>
        </Card>
      </CardDeck>
        </Container>
        </div>
      </div>
    );

  }
}
  
  
export default Home;
