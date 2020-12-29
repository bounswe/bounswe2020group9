import React, { Component } from 'react'
import './cart.scss'

//components
import Col from 'react-bootstrap/Col'
import ProductCard from "../../components/ProductCard/productCard"
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'
import { serverUrl } from '../../utils/get-url'
import axios from 'axios'
import Card from 'react-bootstrap/Card'
import Button from 'react-bootstrap/Button'

export default class Cart extends Component {

  constructor(props) {
    super(props)

    this.state = {
      products: [],
    }

  }

  componentDidMount() {
    axios.get(serverUrl + `api/product/`)
      .then(res => {
        this.setState({ products: res.data })
      })

  }


  render() {

    const { cart } = this.props.location.state;

    let productIds = cart.map(product => product.product)
    let filteredProducts = this.state.products?.filter(product => productIds.includes(product.id))

    let totalAmount = 0;

    let productCards = filteredProducts.map(product => {
      totalAmount += product.price
      return (
        <Col sm="3">
          <ProductCard product={product}></ProductCard>
        </Col>
      )
    })



    return (
      <div>
        <div className='homeWrapper'>
          <Container >
            <Row>
              {productCards}
            </Row>

            <Card style={{ width: '18rem' }}>
              <Card.Body>
                <Card.Title>Total: ₺{totalAmount}</Card.Title>
                <Button variant="success" style={{marginRight: "20px"}}>Buy</Button>
                <Button variant="danger">Empty Cart</Button>
              </Card.Body>
            </Card>

          </Container>
        </div>
      </div>
    )
  }
}
