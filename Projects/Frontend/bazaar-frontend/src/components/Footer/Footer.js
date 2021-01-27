import React from 'react';
import {Container, Col, Row} from 'react-bootstrap';
import './footer.css'

function Footer() {
  return (
    <Container fluid id="footer">
        <Row>
          <Col>
            <h4>Electronics</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Tablets"><DoubleAngle/>Tablets</a></li>
              <li><a href="/category/Computers"><DoubleAngle/>Computers</a></li>
              <li><a href="/category/Photography"><DoubleAngle/>Photography</a></li>
              <li><a href="/category/Home Appliances"><DoubleAngle/>Home Appliances</a></li>
              <li><a href="/category/TV"><DoubleAngle/>TV</a></li>
              <li><a href="/category/Gaming"><DoubleAngle/>Gaming</a></li>
              <li><a href="/category/Electronics/Other"><DoubleAngle/>Other</a></li>
              <li><a href="/category/Mobile Devices"><DoubleAngle/>Mobile Devices</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Home</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/"><DoubleAngle/>Home Textile</a></li>
              <li><a href="/category/Kitchen"><DoubleAngle/>Kitchen</a></li>
              <li><a href="/category/Bedroom"><DoubleAngle/>Bedroom</a></li>
              <li><a href="/category/Bathroom"><DoubleAngle/>Bathroom</a></li>
              <li><a href="/category/Furniture"><DoubleAngle/>Furniture</a></li>
              <li><a href="/category/Lighting"><DoubleAngle/>Lighting</a></li>
              <li><a href="/category/Home/Other"><DoubleAngle/>Other</a></li>
              <li><a href="/category/Petshop"><DoubleAngle/>Petshop</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Clothing</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Top"><DoubleAngle/>Top</a></li>
              <li><a href="/category/Bottom"><DoubleAngle/>Bottom</a></li>
              <li><a href="/category/Outerwear"><DoubleAngle/>Outerwear</a></li>
              <li><a href="/category/Shoes"><DoubleAngle/>Shoes</a></li>
              <li><a href="/category/Bags"><DoubleAngle/>Bags</a></li>
              <li><a href="/category/Accessories"><DoubleAngle/>Accessories</a></li>
              <li><a href="/category/Activewear"><DoubleAngle/>Activewear</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Books</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Books"><DoubleAngle/>Books</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Living</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Art Supplies"><DoubleAngle/>Art Supplies</a></li>
              <li><a href="/category/Musical Devices"><DoubleAngle/>Musical Devices</a></li>
              <li><a href="/category/Sports"><DoubleAngle/>Sports</a></li>
              <li><a href="/category/Living/Other"><DoubleAngle/>Other</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Selfcare</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Perfumes"><DoubleAngle/>Perfumes</a></li>
              <li><a href="/category/Makeup"><DoubleAngle/>Makeup</a></li>
              <li><a href="/category/Skincare"><DoubleAngle/>Skincare</a></li>
              <li><a href="/category/Hair"><DoubleAngle/>Hair</a></li>
              <li><a href="/category/Body Care"><DoubleAngle/>Body Care</a></li>
              <li><a href="/category/Selfcare/Other"><DoubleAngle/>Other</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Health</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Health"><DoubleAngle/>Health</a></li>
            </ul>
          </Col>
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
  );
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