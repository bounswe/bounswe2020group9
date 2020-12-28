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
      categoryStructure: {"":[]},
      products: []
    }
  }


  componentDidMount() {
    const body = {"searched": this.props.match.params["keywords"]}
    let myCookie = read_cookie("user")
    let header;
    if (myCookie){
      header = {headers: {Authorization: "Token "+myCookie.token}};
    } else {
      header = {headers: {Authorization: "Token "}};
    }

    axios.post(serverUrl+'api/product/search/'+this.state.filter+'/'+this.state.sort+'/', body, header)
      .then(res => {
        let myProducts = res.data["product_list"]
        console.log("products: "+res.data["product_list"])
        console.log(res.data)

        this.setState({ products: res.data["product_list"] })
        console.log(this.state.products)

      })
      axios.get(serverUrl+'api/product/categories/')
      .then(res => {
        let resp = res.data;
        let categoryStructureTemp = {};
        let keys = [];
        for (let i=0;i<resp.length;i++) {
          if (resp[i]["parent"] === "Categories") {
            keys.push(resp[i]["name"])
          }
        }
        this.setState({categoryList: keys})
        for (let i=0;i<keys.length;i++) {
          let sublist = []
          for (let j=0;j<resp.length;j++) {
            if (resp[j]["parent"] === keys[i]) {
              sublist.push(resp[j]["name"]);
            }
          }
          categoryStructureTemp[keys[i]] = sublist;
        }
        categoryStructureTemp[''] = []
        this.setState({categoryStructure: categoryStructureTemp})
      })
      console.log(this.state.products)

  }

  render() {
    let active = 2;
    let category = this.state.categoryList
    let items = [];
    for (let number = 0; number < Object.keys(this.state.categoryList).length; number++) {
      items.push(
        <Pagination.Item key={number} className={"myPaginationItem"} href={"/category/"+category[number]}>
          {category[number]}
        </Pagination.Item>,
      );
    }

    let productCards;
    if (this.state.products !== []){
      productCards = this.state.products.map(product => {
        return (
          <Col sm="3">
            <Card product={product}></Card>
          </Col>
        )
      })
    } else  {
      productCards = null
    }


    return (

      <div>

        <div className='home-wrapper'>
          <Container>
            <div className='myPagination'>
              <Pagination size="lg">{items}</Pagination>
            </div>
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
