import React, { Component } from "react";
import { Link } from "react-router-dom";
import ReactDOM from "react-dom";
import axios from "axios";
import { Button } from "react-bootstrap";
import { Redirect } from "react-router-dom";

import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.bundle";

import "./header.scss";

//components
import { serverUrl } from "../../utils/get-url";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";

//utils
import bazaarIMG from "../../assets/bazaar-4.png";
import { faUserPlus } from "@fortawesome/free-solid-svg-icons";
import { faSignInAlt } from "@fortawesome/free-solid-svg-icons";
import { faSignOutAlt } from "@fortawesome/free-solid-svg-icons";
import { faUser } from "@fortawesome/free-solid-svg-icons";
import { faShoppingCart } from "@fortawesome/free-solid-svg-icons";
import { faEnvelope } from "@fortawesome/free-solid-svg-icons";
import { faWarehouse } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

class Header extends Component {
  constructor(props) {
    super(props);

    this.state = {
      isSignedIn: false,
      keywords: "",
      user_type: 0,
      cart: [],
      redirect: null,
      cartProducts: [],
    };
  }

  handleClick() {
    delete_cookie("user");
  }

  handleSearchSubmit = (event) => {
    event.preventDefault();
    const keywords = this.state.keywords;
    const redirectTo = "/search=" + keywords;
    this.setState({ redirect: redirectTo });
  };

  handleSearchChange = (event) => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });
  };

  componentDidMount() {
    let myCookie = read_cookie("user");

    if (Object.keys(myCookie).length === 0) {
      this.setState({ isSignedIn: false });
    } else {
      this.setState({ isSignedIn: true });
      this.setState({ user_type: myCookie.user_type });
    }

    axios
      .get(serverUrl + "api/user/cart/", {
        headers: {
          Authorization: `Token ${myCookie.token}`,
        },
      })
      .then((res) => {
        let resp = res.data;
        this.setState({ cart: resp });
        return resp;
      })
      .then((list) => {
        let productIds = list.map((product) => product.product);
        let productNamesPromises = productIds.map((productId) =>
          axios.get(serverUrl + `api/product/${productId}/`)
        );
        return Promise.all(productNamesPromises);
      })
      .then((list) => {
        let cartProducts = list.map((res) => res.data);
        this.setState({ cartProducts });
      });
  }

  render() {
    let cartItems = this.state.cartProducts.map((product) => {
      return (
        <Link
          className="dropdown-item"
          to={{ pathname: `/product/${product.id}`, state: { product } }}
        >
          {product.name}
        </Link>
      );
    });
    let SignPart;

    if (Object.keys(read_cookie("user")).length !== 0) {
      if (read_cookie("user").user_type === 1) {
        SignPart = (
          <ul className="navbar-nav navbar-right">
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlProfile"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faUser} />
                <span className="mr-1"></span>Profile
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlProfile">
                <a className="dropdown-item" href="/profile-page">
                  View Profile
                </a>
                <a className="dropdown-item" href="/my-list">
                  My List
                </a>
              </div>
            </li>
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlCart"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faShoppingCart} />
                <span className="mr-1"></span>Cart
                <span className="badge badge-secondary badge-pill">
                  {this.state.cart?.length}
                </span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlCart">
                {cartItems}
                <div className="dropdown-divider"></div>
                <Link
                  to={{ pathname: `/cart`, state: { cart: this.state.cart } }}
                >
                  <span className="dropdown-item">Go to Cart</span>
                </Link>
              </div>
            </li>
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlMessages"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faEnvelope} />
                <span className="mr-1"></span>Messages
                <span className="badge badge-secondary badge-pill"></span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlMessages">
                <div className="dropdown-divider"></div>
                <a className="dropdown-item" href="#">
                  Go to Messages
                </a>
              </div>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/" onClick={this.handleClick}>
                <FontAwesomeIcon icon={faSignOutAlt} />
                <span className="mr-1"></span>Sign Out
              </a>
            </li>
          </ul>
        );
      } else {
        SignPart = (
          <ul className="navbar-nav navbar-right">
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlInventory"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faWarehouse} />
                <span className="mr-1"></span>Inventory
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlProfile">
                <a className="dropdown-item" href="/inventory">
                  My Products
                </a>
                <a className="dropdown-item" href="/add-product">
                  Add Product
                </a>
              </div>
            </li>
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlProfile"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faUser} />
                <span className="mr-1"></span>Profile
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlProfile">
                <a className="dropdown-item" href="/profile-page">
                  View Profile
                </a>
              </div>
            </li>
            <li className="nav-item dropdown">
              <a
                className="nav-link dropdown-toggle"
                href="#"
                id="ddlMessages"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="false"
              >
                <FontAwesomeIcon icon={faEnvelope} />
                <span className="mr-1"></span>Messages
                <span className="badge badge-secondary badge-pill"></span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlMessages">
                <div className="dropdown-divider"></div>
                <a className="dropdown-item" href="#">
                  Go to Massages
                </a>
              </div>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/" onClick={this.handleClick}>
                <FontAwesomeIcon icon={faSignOutAlt} />
                <span className="mr-1"></span>Sign Out
              </a>
            </li>
          </ul>
        );
      }
    } else {
      SignPart = (
        <ul className="navbar-nav navbar-right">
          <li className="nav-item">
            <a className="nav-link" href="/signUp">
              <FontAwesomeIcon icon={faUserPlus} />
              <span className="mr-1"></span>Sign Up
            </a>
          </li>
          <li className="nav-item">
            <a className="nav-link" href="/signIn">
              <FontAwesomeIcon icon={faSignInAlt} />
              <span className="mr-1"></span>Sign In
            </a>
          </li>
        </ul>
      );
    }

    if (this.state.redirect) {
      return <Redirect to={this.state.redirect} />;
    }
    return (
      <nav className="navbar navbar-expand-md navbar-light myNavbar">
        <a className="navbar-brand" href="/">
          <img src={bazaarIMG} width="100" height="100" />
        </a>

        <div className="collapse navbar-collapse" id="collapsibleNavId">
          <ul className="navbar-nav mr-auto mt-2 mt-lg-0 search-wrapper">
            <form
              className="search-form justify-content-center"
              onSubmit={this.handleSearchSubmit}
            >
              <div className="form-row align-items-center">
                <div className="col">
                  <input
                    type="text"
                    className="form-control"
                    name="keywords"
                    id="search-bar"
                    placeholder="Search product or brand"
                    onChange={this.handleSearchChange}
                  />
                </div>
                <div id="search-button-div" className="col">
                  <Button variant="primary" id="search-button" type="submit">
                    Search
                  </Button>
                </div>
              </div>
            </form>
          </ul>
          {SignPart}
        </div>
      </nav>
    );
  }
}

export default Header;
