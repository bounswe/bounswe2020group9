import React, { Component } from "react";
import axios from 'axios'
import { read_cookie } from 'sfcookies';
import DataTable, { createTheme } from 'react-data-table-component';
import { Modal, Button } from "react-bootstrap";
import { serverUrl } from '../../utils/get-url'

import { faBan, faCheckCircle, faTruck, faBoxOpen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

import "./admin-pages.scss";

createTheme('custom-theme', {

  background: {
    default: '#e8ffff',
  },
  context: {
    background: '#cb4b16',
    text: '#FFFFFF',
  },
  divider: {
    default: '#073642',
  },
  action: {
    button: 'rgba(0,0,0,.54)',
    hover: 'rgba(0,0,0,.08)',
    disabled: 'rgba(0,0,0,.12)',
  },
});
/*
List of all comments. Can only be seen by the admin. 
*/
export default class CommentList extends Component {

  constructor() {
    super();
    this.state = {
      comments: [],
      commentToDisplay: {}
    }

  }
/*
necessary calls to backend. loads the comments and comment owner, product info.
*/
  componentDidMount() {
    let myCookie = read_cookie('user');
    const header = { headers: { Authorization: "Token " + myCookie.token } };

    axios.get(serverUrl + `api/message/admin/comment/`, header)
      .then(res => {

        let commentsTemp = res.data

        for (let i = 0; i < commentsTemp.length; i++) {
          axios.get(serverUrl + 'api/user/'+commentsTemp[i].customer+"/")
          .then(res2 => {

            commentsTemp[i].customer_id = res2.data.id
            this.setState({comments: commentsTemp})
          })
          axios.get(serverUrl + 'api/product/'+commentsTemp[i].product+"/")
          .then(res3 => {

            commentsTemp[i].product_name = res3.data.name
            this.setState({comments: commentsTemp})
          })
        }

        this.setState({comments: commentsTemp})

      })


  }

  openModal = () => {
    this.setState({ isOpen: true });
  }
  closeModal = () => {
    this.setState({ isOpen: false })
  };

  displayComment = (event) => {

    console.log("event", event)
    this.setState({commentToDisplay: event.body})
    this.setState({ratingToDisplay: event.rating})

    this.openModal()
  }

  removeComment = (event) => {

    let myCookie = read_cookie('user');
    const header = { headers: { Authorization: "Token " + myCookie.token } };
    const data = {
      "comment_id": event.target.id
    }
    console.log("data", data)
    console.log("event", event)

    axios.delete(serverUrl + 'api/message/admin/comment/', {
      headers: {
        Authorization: "Token " + myCookie.token
      },
      data: {
        comment_id: event.target.id
      }
    })
    .then(res => {
      console.log(res)
      var commentsNew = this.state.comments.filter(function (comment) {
        return comment.id != event.target.id;
      });
      this.setState({comments: commentsNew})

    }).catch(error => {
      console.log(error)
    })

    //ban user
  }


  render() {

    const {comments} = this.state;

    for (let i = 0;i <comments.length; i ++) {
      
      let comment_timestamp = comments[i].timestamp.split("T")
      comments[i].time = comment_timestamp[0].substring(8, 10) + " " + comment_timestamp[0].substring(5, 7)
        + " " + comment_timestamp[0].substring(0, 4) + " " + comment_timestamp[1].substring(0, 5)
      comments[i].visibility = comments[i].is_anonymous ? "Anonymous" : "Public" 
      comments[i].action =  <div>
                              <Button variant="danger" className="ban-button"
                                onClick={(event) => this.removeComment(event)} id={comments[i].id}>
                                Remove
                              </Button>
                            </div>
    }

    const columns = [

      {
        name: "ID",
        selector: "id",
        sortable: true,
        maxWidth: "150px"
      },
      {
        name: "Product",
        selector: "product_name",
        sortable: true,
        minWidth: "250px",
      },
      {
        name: "Customer (ID)",
        selector: "customer_id",
        sortable: true,
        minWidth: "250px",
      },
      {
        name: "Visibility",
        selector: "visibility",
        sortable: true,
      },
      {
        name: "Action",
        selector: "action",
        sortable: true,
      },
      {
        name: "Time",
        selector: "time",
        sortable: true,
        minWidth: "200px",
        center: true,
      }
    ];

    return (
      <div>
        <Modal show={this.state.isOpen} onHide={this.closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>Comment Body</Modal.Title>
          </Modal.Header>

            <Modal.Body>
              <div>
              Rating: {this.state.ratingToDisplay}
              </div>
              <div>
              {this.state.commentToDisplay}

              </div>

              
            </Modal.Body>

            <Modal.Footer>
              <Button variant="secondary" onClick={this.closeModal}>Close</Button>
            </Modal.Footer>

        </Modal>
        <div className="admin-list-display background">

          <DataTable
            title="Comments"
            columns={columns}
            data={this.state.comments}
            defaultSortField="id"
            pagination
            highlightOnHover
            pointerOnHover
            theme="custom-theme"
            onRowClicked={this.displayComment}
          />
          </div>
      </div>


    );
  }
}