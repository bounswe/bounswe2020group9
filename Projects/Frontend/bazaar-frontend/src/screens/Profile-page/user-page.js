import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import {serverUrl} from '../../utils/get-url'
import {Button, Alert, Modal} from "react-bootstrap";
import "./userpage.scss";


import "./profilepage.scss";
import {Link} from "react-router-dom";

export default class ProfilePage extends Component {

  constructor(props) {
    super(props);
    this.state = {
      user_id: props.match.params.user_id,
      user: {
        id: 1,
        email: "Loading",
        first_name: "",
        last_name: "",
        date_joined: "",
        last_login: "",
        user_type: 2,
        bazaar_point: 0
      },
      token: "",
      user_not_found:false,
      errors: {},
      // Modal states
      //Customer states
      show_comments_modal:false,
      show_lists_modal:false, // TODO this should redirect instead of opening a modal, fix it later
      comments:[[]], // TODO handle
      lists:[],
      //Vendor states
      show_locations_modal:false,
      locations:[],
      show_products_modal:false,
      products:[]
    }
  }

  componentDidMount() {
    let myCookie = read_cookie("user");
    this.state.token = myCookie.token;

    const headers = {
      Authorization: `Token ${this.state.token}`
    }

    axios.get(serverUrl + "api/user/" + this.state.user_id + "/")
      .then((res) => {
        this.setState({
          user: res.data,
        });

        if (this.state.user.user_type === 1) {
          // if user is Customer,

          // get lists of Customer
          axios.get(serverUrl + "api/user/" + this.state.user_id + "/lists/", {
            headers: headers
          }).then((res) => {
            this.setState({
              lists: res.data,
            });
          });

          // get comments of Customer
          /* axios.get()
            .then((res)=>{
              this.setState({
                comments:res.data,
              });
          */
        } else if (this.state.user.user_type === 2) {
          // if user is Vendor

          // get products of Vendor

          axios.get(serverUrl + "api/product/vendor/" + this.state.user_id + "/", {
            headers: headers
          }).then((res) => {
            this.setState({
              products: res.data,
            });
          })


          // get locations of Vendor

          axios.get(serverUrl + "api/location/vendor/" + this.state.user_id + "/", {
            headers: headers
          }).then((res) => {
            this.setState({
              locations: res.data,
            });
          })
        }
      })
  }

  handleInfo = (user)=>{
    let returned = "";
    if (user.first_name!=="" || user.last_name!=="") returned += user.first_name + " " + user.last_name + ", ";
    returned += user.user_type===2 ? "Vendor" : "Customer";
    return returned;
  }

  handleTimestamp = (timestamp)=>{
    const date = new Date(timestamp);
    let returned = date.getDate()<10 ? "0"+date.getDate() : date.getDate();
    returned += "." + (date.getMonth()+1) + "." + date.getFullYear() + " ";
    returned += date.getHours()<10 ? "0"+date.getHours() : date.getHours();
    returned += ":";
    returned += date.getMinutes()<10 ? "0"+date.getMinutes() : date.getMinutes();
    return returned;
  }

  openCommentsModal = ()=> this.setState({show_comments_modal:true});
  closeCommentsModal = ()=> this.setState({show_comments_modal:false});

  openListsModal = () => this.setState({show_lists_modal:true})
  closeListsModal = () => this.setState({show_lists_modal:false});

  openProductsModal = () => this.setState({show_products_modal:true});
  closeProductsModal = () => this.setState({show_products_modal:false});

  openLocationsModal = () => this.setState({show_locations_modal:true});
  closeLocationsModal = () => this.setState({show_locations_modal:false});

  render() {
    const user = this.state.user;


    if (user.user_type===2){
      // if vendor

      let Products = this.state.products.map((product)=>{
        return (
          <div className="row">
            <Link
              className="btn btn-info col-12"
              to={{ pathname: `/product/${product.id}`, state: { product } }}
            >
              {product.name}</Link>
          </div>
        )
      })

      let Locations = this.state.locations.map((location)=>{
        return (
          <div className="row">
            <div className="col-7">{location.address_name}</div>
            <p
              className="btn btn-info col-5"
              onClick={()=>window.open(`//www.google.com/maps/@${location.latitude},${location.longitude},15z`)}>
              View on Google Maps</p>
          </div>
        )
       });

      console.warn(this.state.locations);

      return (
        <div className='background'>
          <Modal show={this.state.show_products_modal} onHide={this.closeProductsModal}>
            <Modal.Header closeButton>
              <Modal.Title>{"Products of "+user.email}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              <ul className="list-group">
                <li className="list-group-item row">
                  {Products}
                </li>
              </ul>
            </Modal.Body>
            <button className="btn btn-info modalCloseButton" onClick={this.closeProductsModal}>Close</button>
          </Modal>

          <Modal show={this.state.show_locations_modal} onHide={this.closeLocationsModal}>
            <Modal.Header closeButton>
              <Modal.Title>{"Locations of "+user.email}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              <ul className="list-group">
                <li className="list-group-item row">
                  {Locations}
                </li>
              </ul>
            </Modal.Body>
            <button className="btn btn-info modalCloseButton" onClick={this.closeLocationsModal}>Close</button>
          </Modal>

          <Alert variant="danger" hidden={!this.state.user_not_found} style={{textAlign:"center", margin:0}}>
            User Not Found.
          </Alert>
          <div className="container" hidden={this.state.user_not_found}>
            <h2 className="textCenter">{user.email}</h2>
            <ul className="list-group col-8 setCenter">
              <li className="list-group-item row textCenter">{this.handleInfo(user)}</li>
              <li className="list-group-item row textCenter">{"Date Joined: " + this.handleTimestamp(user.date_joined)}</li>
              <li className="list-group-item row textCenter">{"Last Login: " + this.handleTimestamp(user.last_login)}</li>
              <li className="list-group-item row textCenter">
                <button className="btn btn-info" onClick={this.openProductsModal}>View Products</button>
                <button className="btn btn-info" onClick={this.openLocationsModal}>View Locations</button>
              </li>
            </ul>
          </div>
        </div>
      );
    }

    // else, if customer

    let Lists = this.state.lists.map((list)=>{
      return(
        <div className={"rowClicked" + list.is_private ? " font-italic" : ""}>
          <div className="btn col-12">{list.name}</div>
        </div>
      )
    })

    let Comments = this.state.comments.map((comment)=>{
      return (
        <div className="row">
          <div className="col-8">Comment Dummy</div>
          <div className="col-4">
            <button className="btn btn-info">View Product</button>
          </div>
        </div>
      )
    })

    return (
      <div className='background'>

        <Modal show={this.state.show_comments_modal} onHide={this.closeCommentsModal}>
          <Modal.Header closeButton>
            <Modal.Title>{"Comments of "+user.email}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <ul className="list-group">
              <li className="list-group-item row">
                {Comments}
              </li>
            </ul>
          </Modal.Body>
          <button className="btn btn-info modalCloseButton" onClick={this.closeCommentsModal}>Close</button>
        </Modal>

        <Modal show={this.state.show_lists_modal} onHide={this.closeListsModal}>
          <Modal.Header closeButton>
            <Modal.Title>{"Lists of "+user.email}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <div className="row myTitle">
              <Link
                className="btn btn-info col-12"
                to={{ pathname: `#`,}}
              >View All</Link>
            </div>
            <ul className="list-group">
              <li className="list-group-item row">
                {Lists}
              </li>
            </ul>
          </Modal.Body>
          <button className="btn btn-info modalCloseButton" onClick={this.closeListsModal}>Close</button>
        </Modal>

        <Alert variant="danger" hidden={!this.state.user_not_found} style={{textAlign:"center", margin:0}}>
          User Not Found.
        </Alert>
        <div className="container" hidden={this.state.user_not_found}>
          <h2 className="text-center">{user.email}</h2>
          <ul className="list-group col-8 setCenter">
            <li className="list-group-item row textCenter">{this.handleInfo(user)}</li>
            <li className="list-group-item row textCenter">{"Date Joined: " + this.handleTimestamp(user.date_joined)}</li>
            <li className="list-group-item row textCenter">{"Last Login: " + this.handleTimestamp(user.last_login)}</li>
            <li className="list-group-item row textCenter">
              <button className="btn btn-info" onClick={this.openCommentsModal}>View Comments</button>
              <button className="btn btn-info" onClick={this.openListsModal}>View Lists</button>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}