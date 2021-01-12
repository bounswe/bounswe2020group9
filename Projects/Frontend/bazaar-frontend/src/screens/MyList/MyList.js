import React, { Component } from 'react'
import "./mylist.scss"
import axios from 'axios'

//components
import Accordion from 'react-bootstrap/Accordion'
import Card from 'react-bootstrap/Card'
import ProductCard from "../../components/ProductCard/productCard"
import Button from 'react-bootstrap/Button'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import ListGroup from 'react-bootstrap/ListGroup'

//helpers
import {serverUrl} from '../../utils/get-url'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';


export default class MyList extends Component {


  constructor(props) {
    super(props);
    this.state = {
      productLists: [],
      whichList: 1,
      productList : {},
    };
  }


  componentDidMount() {

    let myCookie = read_cookie('user');

    axios.get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {
      headers:{
        'Authorization': `Token ${myCookie.token}`
      }
    })
      .then(res => {
        this.setState({ productLists: res.data })
      })

      axios.get(serverUrl + `api/user/${myCookie.user_id}/list/${this.state.whichList}/`, {
        headers:{
          'Authorization': `Token ${myCookie.token}`
        }
      })
        .then(res => {
          this.setState({ productList: res.data})
        })

  }

  componentDidUpdate(prevProps, prevState){
    let myCookie = read_cookie('user');

    if(prevState.whichList !== this.state.whichList){
      axios.get(serverUrl + `api/user/${myCookie.user_id}/list/${this.state.whichList}/`, {
        headers:{
          'Authorization': `Token ${myCookie.token}`
        }
      })
        .then(res => {
          this.setState({ productList: res.data})
        })
    }


  }


  renderList(){

      console.log(this.state.productList, "product list")
      let productCards = this.state.productList.products?.map(product => {
        return (
          <Col sm="3">
            <ProductCard product={product}></ProductCard>
          </Col>
        )
    })

    return(
      <Row>
        {productCards}
      </Row>
    )
  }

  render() {


    let listNames = this.state.productLists?.map(list => {
      return (
          <button className={"listButton"} onClick={() => this.setState({whichList: list.id})}><ListGroup.Item>{list.name}</ListGroup.Item></button>
      )
    })


    return (
      <div className='background'>

        <Row className={"listWrapper"}>
          <Col xs={3} className={'lists'}>
            <h2>My Lists</h2>
            <ListGroup variant="flush">
              {listNames}
            </ListGroup>
          </Col>
          <Col xs={9}>
              {this.renderList()}
          </Col>
        </Row>
      </div>
    )
  }
}
