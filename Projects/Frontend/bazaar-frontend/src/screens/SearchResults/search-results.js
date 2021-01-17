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
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';

import './search-results.scss'

class SearchResults extends Component {

  constructor(props) {
    super(props);
    this.state = {
      isLogged: 'yes',
      redirect: null,
      filter: "none",
      sort: "none",
      categoryList: [],
      categoryDict: {},
      categoryStructure: {"":[]},
      products: null
    }
  }


  componentDidMount() {
    const body = {"searched": this.props.match.params["keywords"]}
    let myCookie = read_cookie("user")
    let header;
    if (myCookie.length > 0){
      header = {headers: {Authorization: "Token "+myCookie.token}};
      //console.log("ttehere")

    } else {
      header = {headers: {Authorization: "Token 57bcb0493429453fad027bc6552cc1b28d6df955"}};
      //console.log("here")
    }
    let myProducts = []

    axios.post(serverUrl+'api/product/search2/'+this.state.filter+'/'+this.state.sort+'/', body, header)
      .then(res => {
        myProducts = res.data.product_list
        console.log("HEREEE")

        this.setState({ products: myProducts })
        console.log("products: "+JSON.stringify(res.data["product_list"]))
        //console.log("products: "+JSON.stringify(this.state.products))

      })

  }

  render() {
    
    let productCards = this.state.products?.map(product => {
      console.log(product)
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


export default SearchResults;
