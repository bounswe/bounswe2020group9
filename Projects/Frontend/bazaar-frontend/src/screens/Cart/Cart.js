import React, { Component } from 'react'
import './cart.scss'

//components
import Col from 'react-bootstrap/Col'
import Card from "../../components/ProductCard/productCard"
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'


export default class Cart extends Component {
  render() {

    const { cart } = this.props.location.state;
    console.log(cart)


    let cartProductCards = cart.map(cartProduct => {
      return (
        <Col sm="3">
          <Card product={cartProduct}></Card>
        </Col>
      )
    })
    return (
      <div>
        <div className='homeWrapper'>
          <Container fluid>
            <Row>
              {cartProductCards}
            </Row>
          </Container>
        </div>
      </div>
    )
  }
}
