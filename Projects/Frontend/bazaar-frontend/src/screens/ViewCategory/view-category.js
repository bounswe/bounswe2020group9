import React, { Component } from 'react';
import Pagination from 'react-bootstrap/Pagination'
import Jumbotron from 'react-bootstrap/Jumbotron'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import axios from 'axios'
import Card from "../../components/ProductCard/productCard"
import CategoryBar from "../../components/category-bar/category-bar";
import {serverUrl} from '../../utils/get-url'

import './view-category.scss'

class ViewCategory extends Component {

  constructor(props) {
    super(props);
    this.state = {
      isLogged: 'yes',
      redirect: null,
      categoryList: [],
      categoryDict: {},
      categoryStructure: {"":[]},
      products: []
    }
  }


  componentDidMount() {
    axios.get(serverUrl+`api/product/`)
      .then(res => {
        let myProducts = res.data.filter(product => product.category["name"] === this.props.match.params["id"] || 
        product.category["parent"] === this.props.match.params["id"])
        this.setState({ products: myProducts })
      })

  }

  render() {

    let productCards = this.state.products.map(product => {
        return (
          <Col sm="3">
            <Card product={product}></Card>
          </Col>
        )
    })

    return (

      <div>

        <div className='background'>
          <Container>
            <CategoryBar></CategoryBar>
            <div className="category-heading">
              <h2>
                {this.props.match.params["id"]}
              </h2>
            </div>
            <div id="product-cards">
              <Container fluid >
                <Row >
                  {productCards}
                </Row>
              </Container>
            </div>

          </Container>
        </div>
      </div>
    );

  }
}


export default ViewCategory;
