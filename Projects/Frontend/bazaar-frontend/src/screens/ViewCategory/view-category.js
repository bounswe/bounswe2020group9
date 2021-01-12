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
      axios.get(serverUrl+'api/product/categories/')
      .then(res => {
        let resp = res.data;
        let categoryStructureTemp = {};
        let categoryDictTemp = {}
        let keys = [];
        for (let i=0;i<resp.length;i++) {
          if (resp[i]["parent"] === "Categories") {
            keys.push(resp[i]["name"])
            categoryDictTemp[resp[i]["id"]] = resp[i]["name"]

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

  }

  render() {
    let active = 2;
    let categoryList = this.state.categoryList
    let categoryStructure = this.state.categoryStructure
    let categories = [];
    for (let number = 0; number < categoryList.length; number++) {
      let subs = [];
      let subList = categoryStructure[categoryList[number]]
      if (subList){
        for (let subnumber = 0; subnumber < subList.length; subnumber++){
          subs.push(
            <a className="dropdown-item" href={"/category/"+subList[subnumber]}>{subList[subnumber]}</a>
          )
        }
      }


      categories.push(
        <Pagination.Item key={number} className="myPaginationItem dropdown" href={"/category/"+categoryList[number]}>
          <a className="nav-link dropdown-toggle" href="#" id="ddlInventory" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span className="mr-1"></span> {categoryList[number]}
          </a>
          <div className="dropdown-menu">
            {subs}
          </div>
          
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

        <div className='background'>
          <Container>
            <div className='myPagination'>
              <Pagination size="lg">{categories}</Pagination>
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


export default ViewCategory;
