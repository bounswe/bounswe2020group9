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
              <li><a href="/category/Tablets"><i class="fa fa-angle-double-right"></i>Tablets</a></li>
              <li><a href="/category/Computers"><i class="fa fa-angle-double-right"></i>Computers</a></li>
              <li><a href="/category/Photography"><i class="fa fa-angle-double-right"></i>Photography</a></li>
              <li><a href="/category/Home Appliances"><i class="fa fa-angle-double-right"></i>Home Appliances</a></li>
              <li><a href="/category/TV"><i class="fa fa-angle-double-right"></i>TV</a></li>
              <li><a href="/category/Gaming"><i class="fa fa-angle-double-right"></i>Gaming</a></li>
              <li><a href="/category/Electronics/Other"><i class="fa fa-angle-double-right"></i>Other</a></li>
              <li><a href="/category/Mobile Devices"><i class="fa fa-angle-double-right"></i>Mobile Devices</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Home</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/"><i class="fa fa-angle-double-right"></i>Home Textile</a></li>
              <li><a href="/category/Kitchen"><i class="fa fa-angle-double-right"></i>Kitchen</a></li>
              <li><a href="/category/Bedroom"><i class="fa fa-angle-double-right"></i>Bedroom</a></li>
              <li><a href="/category/Bathroom"><i class="fa fa-angle-double-right"></i>Bathroom</a></li>
              <li><a href="/category/Furniture"><i class="fa fa-angle-double-right"></i>Furniture</a></li>
              <li><a href="/category/Lighting"><i class="fa fa-angle-double-right"></i>Lighting</a></li>
              <li><a href="/category/Home/Other"><i class="fa fa-angle-double-right"></i>Other</a></li>
              <li><a href="/category/Petshop"><i class="fa fa-angle-double-right"></i>Petshop</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Clothing</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Top"><i class="fa fa-angle-double-right"></i>Top</a></li>
              <li><a href="/category/Bottom"><i class="fa fa-angle-double-right"></i>Bottom</a></li>
              <li><a href="/category/Outerwear"><i class="fa fa-angle-double-right"></i>Outerwear</a></li>
              <li><a href="/category/Shoes"><i class="fa fa-angle-double-right"></i>Shoes</a></li>
              <li><a href="/category/Bags"><i class="fa fa-angle-double-right"></i>Bags</a></li>
              <li><a href="/category/Accessories"><i class="fa fa-angle-double-right"></i>Accessories</a></li>
              <li><a href="/category/Activewear"><i class="fa fa-angle-double-right"></i>Activewear</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Books</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Books"><i class="fa fa-angle-double-right"></i>Books</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Living</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Art Supplies"><i class="fa fa-angle-double-right"></i>Art Supplies</a></li>
              <li><a href="/category/Musical Devices"><i class="fa fa-angle-double-right"></i>Musical Devices</a></li>
              <li><a href="/category/Sports"><i class="fa fa-angle-double-right"></i>Sports</a></li>
              <li><a href="/category/Living/Other"><i class="fa fa-angle-double-right"></i>Other</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Selfcare</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Perfumes"><i class="fa fa-angle-double-right"></i>Perfumes</a></li>
              <li><a href="/category/Makeup"><i class="fa fa-angle-double-right"></i>Makeup</a></li>
              <li><a href="/category/Skincare"><i class="fa fa-angle-double-right"></i>Skincare</a></li>
              <li><a href="/category/Hair"><i class="fa fa-angle-double-right"></i>Hair</a></li>
              <li><a href="/category/Body Care"><i class="fa fa-angle-double-right"></i>Body Care</a></li>
              <li><a href="/category/Selfcare/Other"><i class="fa fa-angle-double-right"></i>Other</a></li>
            </ul>
          </Col>

          <Col>
            <h4>Health</h4>
            <ul class="list-unstyled quick-links">
              <li><a href="/category/Health"><i class="fa fa-angle-double-right"></i>Health</a></li>
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
              <Decoration/>
            </Col>
            <Col sm="auto">
            <a href="/aboutUs">About Us</a>
            </Col>
            <Col>
              <Decoration/>
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

function Decoration() {
  return (
    <i class="fa fa-minus"></i>
  );
}

export default Footer;