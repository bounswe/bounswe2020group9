import React, {Component} from "react";
import CategoryBar from "../../components/category-bar/category-bar";
import {Alert, Button} from "react-bootstrap";
import axios from "axios";
import {serverUrl} from "../../utils/get-url";
import Col from "react-bootstrap/Col";
import Row from "react-bootstrap/Row";
import TabContainer from "react-bootstrap/TabContainer";
import Nav from "react-bootstrap/Nav";
import NavItem from "react-bootstrap/NavItem";
import NavLink from "react-bootstrap/NavLink";
import {read_cookie} from "sfcookies";



export default class Messages extends Component {
  constructor() {
    super();
    this.state = {
      username: '',
      fullAddress: '',
      utype: '',
      token: '',
      isCustomer: true,
      redirect: null,
      hasError: false,
      isHiddenMessageSent: true,
      isHiddenUnknown: true,
      newMessageMenu: true,
      userHistory: [
        {
          name: "kenan",
          messages: [
            {
              body: "Hello world kenan!",
              user1:true
            },
            {
              body: "Hello world2 kenan!",
              user1:false
            },
            {
              body: "Hello world3 kenan!",
              user1:true
            }
          ]
        },
        {
          name: "sinan",
          messages: [
            {
              body: "Hello world sinan!",
              user1:true
            },
            {
              body: "Hello world2 sinan!",
              user1:false
            },
            {
              body: "Hello world3 sinan!",
              user1:true
            }
          ]
        },
        {
          name: "bilal",
          messages: [
            {
              body: "Hello world bilal!",
              user1:true
            },
            {
              body: "Hello world2 bilal!",
              user1:false
            },
            {
              body: "Hello world3 bilal!",
              user1:true
            }
          ]
        },
        {
          name: "bora",
          messages: [
            {
              body: "Hello world bora!",
              user1:true
            },
            {
              body: "Hello world2 bora!",
              user1:false
            },
            {
              body: "Hello world3 bora!",
              user1:true
            }
          ]
        },
      ],
      errors: {}
      //   user_id: Cookies.get("user_id")
    }
  }

  componentDidMount() {
    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    axios.get(serverUrl + `api/message/conversations/`,{
      headers:headers
    }).then((res) => {
      res.data.conversations.forEach((conversation)=>{
        console.log(conversation);
        axios.get(serverUrl + `api/message/${conversation.id}/`,{
          headers:headers
        }).then((res)=>{
          console.log(res);
        });
      });
    });
  }

  render() {

    let Conversation = (messages) => {
      return messages.map((message)=>{
        return (
          <div className={"row justify-content-"+ (message.user1 ? "start" : "end")}>
            <div className="col-4">
              {message.body}
            </div>
          </div>
        )});
    }

    let Conversations = this.state.userHistory.map((user) => {
      return (
        <div className="tab-pane fade" id={"v-pills-"+user.name} role="tabpanel" aria-labelledby={"v-pills-"+user.name+"-tab"}>
          <h4 className="text-center">{user.name}</h4>
          <div className="container">{Conversation(user.messages)}</div>
          <form>
            <div className="form-group">
              <textarea className="form-control" id="form_body" rows="2" placeholder="Enter Message"/>
            </div>
            <button type="submit" className="btn btn-primary">Send</button>
          </form>
        </div>
      )});

    let LeftCol = this.state.userHistory.map((user) => {
      return (
        <a className="nav-link" id={"v-pills-"+user.name+"-tab"} data-toggle="pill" href={"#v-pills-"+user.name} role="tab"
           aria-controls={"v-pills-"+user.name} aria-selected="false">{user.name}</a>
      );
    });

    return (
      <div className='background'>
        <CategoryBar/>
        <div className="message-container">
          <Alert variant="success" hidden={this.state.isHiddenMessageSent}>
            Profile details updated.
          </Alert>
          <Alert variant="danger" hidden={this.state.isHiddenUnknown}>
            Something went wrong.
          </Alert>
          <h2 className="text-center">Messages</h2>
          <div className="container">
            <div className="row">
              <div className="nav flex-column nav-pills col-4 no-padding-left" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                <h4>Conversation History</h4>
                <a className="nav-link active" id="v-pills-new_conversation-tab" data-toggle="pill" href="#v-pills-new_conversation" role="tab"
                   aria-controls="v-pills-new_conversation" aria-selected="true">New Conversation</a>
                {LeftCol}
              </div>
              <div className="tab-content col-8 no-padding-left" id="v-pills-tabContent">
                <div className="tab-pane fade show active" id="v-pills-new_conversation" role="tabpanel"
                     aria-labelledby="v-pills-new_conversation-tab">
                  <h4 className="text-center">New Conversation</h4>
                  <form>
                    <div className="form-group">
                      <input type="email" className="form-control" id="form-username" placeholder="Enter Username"/>
                    </div>
                    <div className="form-group">
                      <textarea className="form-control" id="form_body" rows="2" placeholder="Enter Message"/>
                    </div>
                    <button type="submit" className="btn btn-primary">Send</button>
                  </form>
                </div>
                {Conversations}
              </div>
            </div>
          </div>
        </div>
      </div>


    );
  }
}