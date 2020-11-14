import React from 'react';

import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap/dist/js/bootstrap.bundle"


import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import { faUserPlus } from '@fortawesome/free-solid-svg-icons'
import { faSignInAlt } from '@fortawesome/free-solid-svg-icons'
import { faUser } from '@fortawesome/free-solid-svg-icons'
import { faShoppingCart } from '@fortawesome/free-solid-svg-icons'
import { faEnvelope } from '@fortawesome/free-solid-svg-icons'
import { faSignOutAlt } from '@fortawesome/free-solid-svg-icons'







const Header = () => {
  return (
    <nav className="navbar navbar-expand-md navbar-light " style={{ height: '100px', backgroundColor: 'rgb(246,162,37)'}}>
        <a className="navbar-brand" > 
          <img
          src="/components/bazaar-4.png"
          width="100"
          height= "100"
          //className="d-inline-block align-top"
          alt=""
        />BAZAAR</a>
        <button className="navbar-toggler hidden-lg-up" type="button" data-toggle="collapse" data-target="#collapsibleNavId" aria-controls="collapsibleNavId"
            aria-expanded="false" aria-label="Menü">
                
            </button>
        <div className="collapse navbar-collapse" id="collapsibleNavId">
            <ul className="navbar-nav  mr-auto mt-2 mt-lg-0">
              
            </ul>
            <ul className="navbar-nav navbar-right">
                <li className="nav-item">
                    <a className="nav-link" >
                        <FontAwesomeIcon icon = {faUserPlus}/>
                        <span className="mr-1"></span>Register
                    </a>
                </li>
                <li className="nav-item">
                    <a className="nav-link" href="#">
                        <FontAwesomeIcon icon = {faSignInAlt}/>

                        <span className="mr-1"></span>Sign In
                    </a>
                </li>
                <li className="nav-item dropdown">
                    <a className="nav-link dropdown-toggle" href="#" id="ddlProfile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <FontAwesomeIcon icon = {faUser}/>
                        <span className="mr-1"></span>Profile
                    </a>
                    <div className="dropdown-menu" aria-labelledby="ddlProfile">
                        <a className="dropdown-item" href="#">View Profile</a>
                        <a className="dropdown-item" href="#">My Addresses</a>
                        <a className="dropdown-item" href="#">My Orders</a>
                    </div>
                </li>
                <li className="nav-item dropdown">
                    <a className="nav-link dropdown-toggle" href="#" id="ddlCart" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <FontAwesomeIcon icon = {faShoppingCart}/>
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
                        <FontAwesomeIcon icon = {faEnvelope}/>
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
                    <a className="nav-link" >
                        <FontAwesomeIcon icon = {faSignOutAlt}/>
                        <span className="mr-1"></span>Sign Out
                    </a>
                </li>
                
            </ul>
        </div>
    </nav>
  );
}

export default Header;
