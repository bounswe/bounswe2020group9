import React, { Component } from 'react'
import './cart.scss'

//components
import Col from 'react-bootstrap/Col'
import Card from "../../components/ProductCard/productCard"
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'
import {serverUrl} from '../../utils/get-url'
import axios from 'axios'


export default class Cart extends Component {

  constructor(props) {
    super(props)

    this.state = {
      products: [],
    }

  }

  componentDidMount(){
    axios.get(serverUrl+`api/product/`)
    .then(res => {
      this.setState({ products: res.data })
    })
  }


  render() {

    const { cart } = this.props.location.state;
    console.log(cart)

    let productIds = cart.map(product => product.product)
    let filteredProducts = this.state.products?.filter(product => productIds.includes(product.id))

    let productCards = filteredProducts.map(product => {
      return (
        <Col sm="3">
          <Card product={product}></Card>
        </Col>
      )
  })



    return (
      <div>
        <div className='homeWrapper'>
          <Container fluid>
            <Row>
              {productCards}
            </Row>
          </Container>
        </div>
      </div>
    )
  }
}
