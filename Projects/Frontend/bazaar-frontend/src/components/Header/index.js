import React from 'react';

import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap/dist/js/bootstrap.bundle"

const Header = () => {
  return (
    <nav className="navbar navbar-expand-md navbar-light " style={{ height: '100px', backgroundColor: 'rgb(246,162,37)'}}>
        <a className="navbar-brand"> 
          <img
          src="/components/bazaar-4.png"
          width="30"
          height="30"
          className="d-inline-block align-top"
          alt=""
        />BAZAAR</a>
        <button className="navbar-toggler hidden-lg-up" type="button" data-toggle="collapse" data-target="#collapsibleNavId" aria-controls="collapsibleNavId"
            aria-expanded="false" aria-label="Menü"></button>
        <div className="collapse navbar-collapse" id="collapsibleNavId">
            <ul className="navbar-nav mr-auto mt-2 mt-lg-0">
                
            </ul>
            <ul className="navbar-nav navbar-right">
                <li className="nav-item">
                    <a className="nav-link" >
                        <span className="fa fa-user-plus mr-2"></span>Register
                    </a>
                </li>
                <li className="nav-item">
                    <a className="nav-link" href="#">
                        <span className="fa fa-sign-in mr-2"></span>Login
                    </a>
                </li>
                <li className="nav-item dropdown">
                    <a className="nav-link dropdown-toggle" href="#" id="ddlProfile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <span className="fa fa-user mr-2"></span>Profile
                    </a>
                    <div className="dropdown-menu" aria-labelledby="ddlProfile">
                        <a className="dropdown-item" href="#">View Profile</a>
                        <a className="dropdown-item" href="#">My Addresses</a>
                        <a className="dropdown-item" href="#">My Orders</a>
                    </div>
                </li>
                <li className="nav-item dropdown">
                    <a className="nav-link dropdown-toggle" href="#" id="ddlCart" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <span className="fa fa-shopping-cart mr-2"></span>Cart
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
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="ddlMessages" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <span class="fa fa-envelope mr-2"></span>Massages
                        <span class="badge badge-secondary badge-pill">2</span>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="ddlMessages">
                        <a class="dropdown-item" href="#">Massage 1</a>
                        <a class="dropdown-item" href="#">Massage 2</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="#">Go to Massages</a>
                    </div>
                </li>
                <li className="nav-item">
                    <a className="nav-link" >
                        <span className="fa fa-user-plus mr-2"></span>Log Out
                    </a>
                </li>
                
            </ul>
        </div>
    </nav>
  );
}

export default Header;
