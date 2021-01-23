import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import {serverUrl} from '../../utils/get-url'
import {Button, Alert, Modal} from "react-bootstrap";
import "./userpage.scss";


import "./profilepage.scss";

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
      comments:[[]], // TODO handle comments
      lists:[],
      user_not_found:false,
      show_comments_modal:false,
      show_lists_modal:false,
      errors: {}
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
        // get comments of user
        /* axios.get()
          .then((res)=>{
            this.setState({
              comments:res.data,
            });
        */
        // get lists of user
        if (this.state.user.user_type === 1) {
          axios.get(serverUrl + "api/user/" + this.state.user_id + "/lists/", {
            headers: headers
          }).then((res) => {
            this.setState({
              lists: res.data,
            });
          });
        }
      }).catch(() => {
          this.setState({user_not_found: true});
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

  openCommentsModal = ()=>{
    this.setState({show_comments_modal:true});
  }
  closeCommentsModal = ()=>{
    this.setState({show_comments_modal:false});
  }

  openListsModal = ()=>{
    this.setState({show_lists_modal:true});
  }
  closeListsModal = ()=>{
    this.setState({show_lists_modal:false});
  }

  render() {
    const user = this.state.user;

    let Lists = this.state.lists.map((list)=>{
      return(
        <div className="row">
          <div className="col-3">{list.is_private ? "Private" : "Public"}</div>
          <div className="col-4">{list.name}</div>
          <div className="col-5">
            <button variant="secondary">View Products</button>
          </div>
        </div>
        )
    })

    let Comments = this.state.comments.map((comment)=>{
      return (
        <div className="row">
          <div className="col-3">Comment First</div>
          <div className="col-6">Comment Second</div>
          <div className="col-3">Comment Third</div>
        </div>
      )
    })

    return (
      <div className='background'>

        <Modal show={this.state.show_comments_modal} onHide={this.closeCommentsModal}>
          <Modal.Header closeButton>
            <Modal.Title>Comments Modal</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <ul className="list-group">
              <li className="list-group-item row">
                {Comments}
              </li>
            </ul>
          </Modal.Body>
          <Modal.Footer>
            <button variant="secondary" onClick={this.closeCommentsModal}>Close</button>
          </Modal.Footer>
        </Modal>

        <Modal show={this.state.show_lists_modal} onHide={this.closeListsModal}>
          <Modal.Header closeButton>
            <Modal.Title>Lists Modal</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <ul className="list-group">
              <li className="list-group-item row">
                {Lists}
              </li>
            </ul>
          </Modal.Body>
          <Modal.Footer>
            <button variant="secondary" onClick={this.closeListsModal}>Close</button>
          </Modal.Footer>
        </Modal>

        <Alert variant="danger" hidden={!this.state.user_not_found} style={{textAlign:"center", margin:0}}>
          User Not Found.
        </Alert>
        <div hidden={this.state.user_not_found}>
          <h2 className="text-center">{user.email}</h2>
          <ul className="list-group">
            <li className="list-group-item row textCenter">{this.handleInfo(user)}</li>
            <li className="list-group-item row textCenter">{"Date Joined: " + this.handleTimestamp(user.date_joined)}</li>
            <li className="list-group-item row textCenter">{"Last Login: " + this.handleTimestamp(user.last_login)}</li>
          </ul>
          <ul className="list-group">
            <li className="list-group-item textCenter">
              <button variant="secondary" onClick={this.openCommentsModal}>View Comments</button>
              <button variant="secondary" onClick={this.openListsModal}>View Lists</button>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}