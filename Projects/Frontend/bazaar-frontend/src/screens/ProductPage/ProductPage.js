import React, { Component } from 'react'
import "./productpage.scss"

//components
import StarRatings from '../../../node_modules/react-star-ratings';
import Carousel from 'react-bootstrap/Carousel'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Header from "../../components/Header/Header"

//icons
import AddToCartIcon from "../../assets/icons/add-to-cart.svg"
import RemoveFromCartIcon from "../../assets/icons/remove-from-cart.svg"
import AddToListIcon from "../../assets/icons/add-to-list-hand-drawn-interface-symbol.svg"


export default class Productpage extends Component {

  render() {
    const { product } = this.props.location.state;
    console.log(product)

    return (
      <div>
        <Header />
        <Container>
          <Row>
            <Col>
              <Carousel className={"productCarousel"}>
                <Carousel.Item interval={1000}>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="First slide"
                  />
                </Carousel.Item>
                <Carousel.Item interval={500}>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="Third slide"
                  />
                </Carousel.Item>
                <Carousel.Item>
                  <img
                    className="d-block w-100"
                    src={product.picture}
                    alt="Third slide"
                  />
                </Carousel.Item>
              </Carousel>
            </Col>

            <Col className={"productInfo"}>
              <Container style={{display:"flex", flexDirection:"column", height:'100%'}}>
                <div style={{flex: '1'}}>
                  <Row>
                    <Col>
                      <h2 className={"productHeader"}>{product.name}</h2>
                    </Col>
                    <Col>
                      <h5 className={"productCategory"}><span className={'productCategoryName'}>{product.category.name}</span> <span className={'productCategoryParent'}>{product.category.parent}</span></h5>
                    </Col>
                  </Row>
                  <h5 className={"productBrand"}>{product.brand}</h5>
                  <StarRatings
                    rating={product.rating}
                    starDimension="40px"
                    starSpacing="15px"
                    starRatedColor="#FFA41B"
                    starDimension="20px"
                    starSpacing="2px"
                  />
                  <h5 className={"productPrice"}><span className={'productPriceName'}>Price: </span><span className={'productPriceAmount'}> ₺{product.price}</span></h5>
                </div>

                <div>
                  <Row>
                    <Col>
                      <button className={"productButton"}><span>Add to Cart</span><img src={AddToCartIcon} /></button>
                    </Col>
                    <Col>
                      <button className={"productButton"}><span>Add to List</span><img src={AddToListIcon} /></button>
                    </Col>
                  </Row>
                </div>
              </Container>
            </Col>
          </Row>
        </Container>

      </div>
    )
  }
}
