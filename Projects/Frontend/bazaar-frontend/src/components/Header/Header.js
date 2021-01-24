import React, { Component } from "react";
import { Link } from "react-router-dom";
import ReactDOM from "react-dom";
import axios from "axios";
import {Button, Modal} from "react-bootstrap";
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
import {faBell} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

class Header extends Component {
  constructor(props) {
    super(props);

    this.state = {
      isSignedIn: false,
      token: "",
      new_messages: 0,
      showNotification: false,
      new_notifications: 0,
      notifications: [],
      keywords: "",
      user_type: 0,
      cart: [],
      cartProducts: [],
      redirect: null,
    };
  }

  handleSignout() {
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

  openNotificationModal = (event)=>{
    if (event !== undefined) event.preventDefault();
    this.setState({showNotification: true});
  }

  closeNotificationModal = (event)=>{
    this.setState({showNotification: false});
  }

  readAllNotifications = (event)=>{
    axios.post(serverUrl + "api/message/notifications/", "",{
        headers: {
          Authorization: `Token ${this.state.token}`,
        }
    }).then((res)=>{
      console.warn(this.state.token,res);
    });
    this.state.notifications.forEach(notification=>{
      notification.is_visited = true;
    });
    this.setState({
      new_notifications:0,
      notifications:this.state.notifications
    });
  }


  componentDidMount() {
    let myCookie = read_cookie("user");

    if (Object.keys(myCookie).length === 0) {
      this.setState({
        isSignedIn: false
      });
    } else {
      this.setState({
        isSignedIn: true,
        user_type: myCookie.user_type,
        token : myCookie.token
      });
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

    if(myCookie.token !== undefined){
      const headers = {
        Authorization: `Token ${myCookie.token}`
      }

      axios
        .get(serverUrl + "api/message/notifications/", {headers: headers})
        .then((res)=>{
          res.data.notifications.forEach((notification)=>{
            const date = new Date(notification.timestamp);
            notification.customTime = `${date.getDate()}.${date.getMonth()+1}.${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}`;
          });
        //console.log("Notifications",res.data);
        this.setState({
          new_notifications : res.data.new_notifications,
          notifications : res.data.notifications
        });
      }).catch((err)=>{
        //console.log("notifications not loaded, please refresh", myCookie.token);
      })

      axios.get(serverUrl + "api/message/conversations/", {headers:headers})
      .then((res)=>{
        this.setState({new_messages:res.data.new_messages});
      }).catch((err)=>{
        console.warn(err);
      })
    }
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

    let Notifications = this.state.notifications.map((notification)=>{
      return (
          <a
            className="list-group-item list-group-item-action"
            style={{
              "fontWeight": (notification.is_visited ? "normal" : "bold"),
              "fontSize": "0.8rem",
            }}
            href="#"
            onClick={(event)=>{
              event.preventDefault();
              notification.is_visited = true;
              this.setState({notifications:this.state.notifications});
            }}>
              <div className="row">
                <div className="col-3 no-padding-left">{notification.customTime}</div>
                <div className="col-3 no-padding-left">{notification.type}</div>
                <div className="col-6 no-padding-left">{notification.body}</div>
              </div>
            </a>
      )
    });

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
                <span className="mr-1"/>Profile
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlProfile">
                <a className="dropdown-item" href="/profile-page">
                  View Profile
                </a>
                <a className="dropdown-item" href="/my-list">
                  My Lists
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
                <span className="mr-1"/>Cart
                <span className="badge badge-secondary badge-pill">
                  {this.state.cart?.length}
                </span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlCart">
                {cartItems}
                <div className="dropdown-divider"/>
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
                <span className="mr-1"/>Messages
                <span hidden={!this.state.new_messages} className="badge badge-secondary badge-pill">
                  {this.state.new_messages}
                </span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlMessages">
                <a className="dropdown-item" href="/messages">
                  Go to Messages
                </a>
              </div>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/" onClick={this.openNotificationModal}>
                <FontAwesomeIcon icon={faBell} />
                <span className="mr-1"/>Notifications
                <span hidden={!this.state.new_notifications} className="badge badge-secondary badge-pill">
                  {this.state.new_notifications}
                </span>
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link"  href="/" onClick={this.handleSignout}>
                <FontAwesomeIcon icon={faSignOutAlt} />
                <span className="mr-1"/>Sign Out
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
                <span className="mr-1"/>Inventory
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
                <span className="mr-1"/>Profile
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
                <span className="mr-1"/>Messages
                <span hidden={!this.state.new_messages} className="badge badge-secondary badge-pill">
                  {this.state.new_messages}
                </span>
              </a>
              <div className="dropdown-menu" aria-labelledby="ddlMessages">
                <a className="dropdown-item" href="/messages">
                  Go to Messages
                </a>
              </div>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/" onClick={this.openNotificationModal}>
                <FontAwesomeIcon icon={faBell} />
                <span className="mr-1"/>Notifications
                <span hidden={!this.state.new_notifications} className="badge badge-secondary badge-pill">
                  {this.state.new_notifications}
                </span>
              </a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/" onClick={this.handleSignout}>
                <FontAwesomeIcon icon={faSignOutAlt} />
                <span className="mr-1"/>Sign Out
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
              <span className="mr-1"/>Sign Up
            </a>
          </li>
          <li className="nav-item">
            <a className="nav-link" href="/signIn">
              <FontAwesomeIcon icon={faSignInAlt} />
              <span className="mr-1"/>Sign In
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

        <Modal show={this.state.showNotification} onHide={this.closeNotificationModal}>
          <Modal.Header closeButton>
            <Modal.Title>{
              (this.state.new_notifications ? this.state.new_notifications: "No")
              + " new Notification"
              + (this.state.new_notifications===1 ? "": "s")}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <ul className="list-group">
              {Notifications}
            </ul>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={this.readAllNotifications}>Unmark All</Button>
            <Button variant="secondary" onClick={this.closeNotificationModal}>Close</Button>
          </Modal.Footer>
        </Modal>

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
