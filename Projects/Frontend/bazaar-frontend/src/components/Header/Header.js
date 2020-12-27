import React, { Component } from 'react';
import ReactDOM from 'react-dom'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';


import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap/dist/js/bootstrap.bundle"

import "./header.scss";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import { faUserPlus } from '@fortawesome/free-solid-svg-icons'
import { faSignInAlt } from '@fortawesome/free-solid-svg-icons'
import { faSignOutAlt } from '@fortawesome/free-solid-svg-icons'
import { faUser } from '@fortawesome/free-solid-svg-icons'
import { faShoppingCart } from '@fortawesome/free-solid-svg-icons'
import { faEnvelope } from '@fortawesome/free-solid-svg-icons'
import { faWarehouse } from '@fortawesome/free-solid-svg-icons'

import bazaarIMG from '../../assets/bazaar-4.png'


class Header extends Component {
  constructor(props) {
    super(props)

    this.state = {
      isSignedIn: false,
      keywords: '',
      user_type: 0
    }

  }

  handleClick() {
    delete_cookie("user")
  }

  handleSearchSubmit = event => {
    event.preventDefault();

  
  }

  handleSearchChange = event => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });    
  }


  componentDidMount() {
    let myCookie = read_cookie('user')

    if (Object.keys(myCookie).length === 0) {
      this.setState({ isSignedIn: false })
    }
    else {
      this.setState({ isSignedIn: true })
      this.setState({ user_type: myCookie.user_type})
    }
  }

  render() {

    let SignPart

    if (Object.keys(read_cookie('user')).length !== 0) {
      SignPart = <ul className="navbar-nav navbar-right">
        <li className="nav-item dropdown">
          <a className="nav-link dropdown-toggle" href="#" id="ddlInventory" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <FontAwesomeIcon icon={faWarehouse} />
            <span className="mr-1"></span>Inventory
          </a>
          <div className="dropdown-menu" aria-labelledby="ddlProfile">
            <a className="dropdown-item" href="/inventory">My Products</a>
            <a className="dropdown-item" href="/add-product">Add Product</a>
          </div>
        </li>
        <li className="nav-item dropdown">
          <a className="nav-link dropdown-toggle" href="#" id="ddlProfile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <FontAwesomeIcon icon={faUser} />
            <span className="mr-1"></span>Profile
          </a>
          <div className="dropdown-menu" aria-labelledby="ddlProfile">
            <a className="dropdown-item" href="/profile-page">View Profile</a>
            <a className="dropdown-item" href="/my-list">My List</a>
            <a className="dropdown-item" href="#">My Orders</a>
          </div>
        </li>
        <li className="nav-item dropdown">
          <a className="nav-link dropdown-toggle" href="#" id="ddlCart" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <FontAwesomeIcon icon={faShoppingCart} />
            <span className="mr-1"></span>Cart
            <span className="badge badge-secondary badge-pill">3</span>
          </a>
          <div className="dropdown-menu" aria-labelledby="ddlCart">
            <a className="dropdown-item" href="#">Product 1</a>
            <a className="dropdown-item" href="#">Product 2</a>
            <a className="dropdown-item" href="#">Prodoct 3</a>
            <div className="dropdown-divider"></div>
            <a className="dropdown-item" href="#">Go to Cart</a>
          </div>
        </li>
        <li className="nav-item dropdown">
          <a className="nav-link dropdown-toggle" href="#" id="ddlMessages" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <FontAwesomeIcon icon={faEnvelope} />
            <span className="mr-1"></span>Massages
            <span className="badge badge-secondary badge-pill">2</span>
          </a>
          <div className="dropdown-menu" aria-labelledby="ddlMessages">
            <a className="dropdown-item" href="#">Massage 1</a>
            <a className="dropdown-item" href="#">Massage 2</a>
            <div className="dropdown-divider"></div>
            <a className="dropdown-item" href="#">Go to Massages</a>
          </div>
        </li>
        <li className="nav-item">
          <a className="nav-link" href="/" onClick={this.handleClick}>
            <FontAwesomeIcon icon={faSignOutAlt} />
            <span className="mr-1"></span>Sign Out
          </a>

        </li>

      </ul>

    }
    else {
      SignPart = <ul className="navbar-nav navbar-right">
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

    }


    return (
      <nav className="navbar navbar-expand-md navbar-light myNavbar">
        <a className="navbar-brand" href="/" >
          <img
            src={bazaarIMG}
            width="100"
            height="100"
          /></a>

        <div className="collapse navbar-collapse" id="collapsibleNavId">
          <ul className="navbar-nav mr-auto mt-2 mt-lg-0">
            <form className="search-form" onSubmit={this.handleSearchSubmit}>
              <input type="text" className="form-control" name="search" id="search-bar" 
              placeholder="Search product, brand, category or vendor"
              onChange={this.handleSearchChange}/>
            </form>
          </ul>
          {SignPart}
        </div>
      </nav>
    );
  }
}

export default Header;
