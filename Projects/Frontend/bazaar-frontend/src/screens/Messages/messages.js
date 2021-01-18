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
      userHistory: [
        {
          name: "kenan",
          messages:{
            title:"Greetings",
            body:"Lorem ipsum from kenan"
          }
        },
        {
          name: "sinan",
          messages:{
            title:"Greetings",
            body:"Lorem ipsum from sinan"
          }
        },
        {
          name: "bilal",
          messages:{
            title:"Greetings",
            body:"Lorem ipsum from bilal"
          }
        },
        {
          name: "bora",
          messages:{
            title:"Greetings",
            body:"Lorem ipsum from bora"
          }
        },
      ],
      errors: {}
      //   user_id: Cookies.get("user_id")
    }
  }

  componentDidMount() {
    /*
    axios.get(serverUrl + `api/message/`).then((res) => {
      this.setState({ messages: res.data });
    });
    */
  }

  render() {

    let AccountList = this.state.userHistory.map((user) => {
      return (
        <NavItem>
          <NavLink eventKey={user.name}>{user.name}</NavLink>
        </NavItem>
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
          <div>
            <h2 className="text-center">Messages</h2>
          </div>
          <Row>
            <div className=" col-sm-4 text-center">
              <h3>Message History</h3>
              <TabContainer id="message-history" defaultActiveKey="new_message">
                <Row>
                  <Col>
                    <Nav variant="pills" className="flex-column">
                      <NavItem>
                        <NavLink eventKey="new_message">New Message</NavLink>
                      </NavItem>
                      {AccountList}
                    </Nav>
                  </Col>
                </Row>
              </TabContainer>
            </div>
            <div className="col-sm">
              <h3 className="text-center">New Message</h3>
              <form>
                <div className="form-group">
                  <input type="email" className="form-control" id="form_username" placeholder="Enter Username"/>
                </div>
                <div className="form-group">
                  <input type="text" className="form-control" id="form_title" placeholder="Enter Title"/>
                </div>
                <div className="form-group">
                  <textarea className="form-control" id="form_body" rows="3"/>
                </div>
                <button type="submit" className="btn btn-primary">Send</button>
              </form>
            </div>
          </Row>
        </div>
      </div>


    );
  }
}