import React from 'react';
import {Container, Col, Row} from 'react-bootstrap';
import './footer.css'
import axios from "axios";
import {serverUrl} from "../../utils/get-url";

function FooterColumn(props) {
  const listItems = props.subcategs.map(subcateg => {
      const link = "/category/" + subcateg;
      return <li><a href={link}><DoubleAngle/>{subcateg}</a></li>
    }
  );
  console.log(listItems);
  return (
    <Col>
      <h4>{props.categName}</h4>
      <ul class="list-unstyled quick-links">
        {listItems}
      </ul>
    </Col>
  )
}

class Footer extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      categs : {}
    }
  }

  componentDidMount() {
    let categsTemp = {}
    axios.get(serverUrl + "api/product/categories/").then( res => {
      for(let i=0; i<res.data.length; i++){
        if(res.data[i].parent === "Categories"){
          categsTemp[res.data[i].name] = [];
        }
      }
      for(let i=0; i<res.data.length; i++){
        if(res.data[i].parent !== "Categories"){
          categsTemp[res.data[i].parent].push( res.data[i].name );
        }
      }
    });
    this.setState({categs : categsTemp})
    let a = 4
    let b = 31
  }

  render() {

    return (
      <Container fluid id="footer">
        <Row>
          {
          Object.keys(this.state.categs).map( categName =>
            <FooterColumn categName={categName} subcategs={this.state.categs[categName]}
            />
          )
          }
        </Row>

        <Row>
          <Col>
            <ul class="list-unstyled list-inline social text-center">
              <li class="list-inline-item"><a href="https://www.facebook.com/bazaar-tr"><i class="fa fa-facebook"></i></a></li>
              <li class="list-inline-item"><a href="https://www.twitter.com/bazaar-tr"><i class="fa fa-twitter"></i></a></li>
              <li class="list-inline-item"><a href="https://www.instagram.com/bazaar-tr"><i class="fa fa-instagram"></i></a></li>
              <li class="list-inline-item"><a href="mailto:info@bazaar.com.tr" target="_blank"><i class="fa fa-envelope"></i></a></li>
            </ul>
          </Col>
        </Row>

        <Row className="text-center footerLower">
          <Col>
            <p>34342, Bebek, Besiktas, Istanbul/Turkey<br />
          © {new Date().getFullYear()} <a href="/">Bazaar Inc.</a> All rights reserved</p>
          </Col>
        </Row>

        <Row className="bottomLine text-center">
          <Col>
          </Col>
          <Row>
            <Col>
            <a href="/faq">FAQ</a>
            </Col>
            <Col>
              <Minus/>
            </Col>
            <Col sm="auto">
            <a href="/aboutUs">About Us</a>
            </Col>
            <Col>
              <Minus/>
            </Col>
            <Col>
            <a href="/career">Career</a>
            </Col>
          </Row>
          <Col>
          </Col>
        </Row>

      </Container>
    )
  }
}

function Minus() {
  return (
    <i class="fa fa-minus"></i>
  );
}

function DoubleAngle() {
  return (
    <i class="fa fa-angle-double-right"></i>
  );
}

export default Footer;