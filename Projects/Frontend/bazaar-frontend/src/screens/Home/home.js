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
import Card from "../../components/ProductCard/productCard"
import {serverUrl} from '../../utils/get-url'
import { Link } from 'react-router-dom'



import './home.scss'

class Home extends Component {

  constructor() {
    super();
    this.state = {
      isLogged: 'yes',
      redirect: null,
      categoryList: [],
      products: []
    }
  }


  componentDidMount() {
    axios.get(serverUrl+`api/product/`)
      .then(res => {
        this.setState({ products: res.data })
      })
    axios.get(serverUrl+'api/product/categories/')
    .then(res => {
      let resp = res.data;
      let keys = [];
      for (let i=0;i<resp.length;i++) {
        if (resp[i]["parent"] == "Categories") {
          keys.push(resp[i]["name"])
        }
      }
      this.setState({categoryList: keys})
    })
  }

  render() {
    let active = 2;
    let category = this.state.categoryList
    let items = [];
    for (let number = 0; number < category.length; number++) {
      items.push(
        <Pagination.Item key={number} className={"myPaginationItem"} href={"/category/"+category[number]}>
          {category[number]}
        </Pagination.Item>
      );
    }



    let productCards = this.state.products.map(product => {
        return (
          <Col sm="3">
            <Card product={product}></Card>
          </Col>
        )
    })

    return (

      <div>
        <div className='homeWrapper'>
          <Container>
            <div className='myPagination'>
              <Pagination size="lg">{items}</Pagination>
            </div>
            <div className='row homeJumbotron'>
              <Jumbotron style={{background:"transparent"}}>
                <h1>Welcome to Bazaar!</h1>
                <p>
                  "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and
                  demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee
                  the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty
                  through weakness of will, which is the same as saying through shrinking from toil and pain. These cases
                  are perfectly simple and easy to distinguish
              </p>
                <p>
                  <Button variant="outline-info">Learn more</Button>
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
