import React, { Component } from "react";
import CategoryBar from "../../components/category-bar/category-bar";
import { Alert, Button } from "react-bootstrap";
import axios from "axios";
import { serverUrl } from "../../utils/get-url";
import { read_cookie } from "sfcookies";
import "./messages.scss";

export default class Messages extends Component {
  constructor() {
    super();
    this.state = {
      isHiddenMessageSent: true,
      isHiddenUnknown: true,
      hide_enter_username: true,
      hide_enter_message: true,
      currentPill: "",
      message_username: "",
      message_body: "",
      conversations: [],
      errors: {},
    };
  }

  componentDidMount() {
    let myCookie = read_cookie("user");
    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    axios
      .get(serverUrl + `api/message/all/`, {
        headers: headers,
      })
      .then((response) => {
        let conversations = response.data.conversations;
        conversations.forEach((conversation)=>{
          console.warn(conversation.am_I_user1===true);
          conversation.messages.forEach((message)=>{
            message.is_me = conversation.am_I_user1 === message.is_user1;
          });
        });
        this.setState({
          token: myCookie.token,
          conversations: conversations,
        });
        console.log("API returns:", this.state.conversations);
      });
  }

  handleSendMessage = (event) => {
    event.preventDefault();

    if (this.state.message_body === "") {
      this.setState({ hide_enter_message: false });
      return;
    }

    const body = new FormData();
    body.append("receiver_username", this.state.currentPill);
    body.append("body", this.state.message_body);

    const header = { headers: { Authorization: "Token " + this.state.token } };

    axios
      .post(serverUrl + "api/message/", body, header)
      .then(() => {
        this.setState({
          token: this.state.token,
          isHiddenMessageSent: false,
        });
      })
      .catch((error) => {
        this.setState({
          isHiddenUnknown: false,
          hide_enter_username: true,
          hide_enter_message: true,
        });
      });
    //console.log("Message Sent", this.state.currentPill, this.state.message_body);
    //window.location.reload();
  };

  handleNewConversation = (event) => {
    event.preventDefault();

    if (this.state.message_username === "" || this.state.message_body === "") {
      this.setState({
        hide_enter_username: !(this.state.message_username === ""),
        hide_enter_message: !(this.state.message_body === ""),
      });
      return;
    }
    console.log("reached");

    const body = new FormData();
    body.append("receiver_username", this.state.message_username);
    body.append("body", this.state.message_body);

    const header = { headers: { Authorization: "Token " + this.state.token } };

    axios
      .post(serverUrl + "api/message/", body, header)
      .then(() => {
        this.setState({
          isHiddenMessageSent: false,
          hide_enter_username: true,
          hide_enter_message: true,
        });
      })
      .catch((error) => {
        this.setState({ isHiddenUnknown: false });
      });
    //console.log("New Conversation Created", this.state.message_username, this.state.message_body);
    //window.location.reload();
  };

  handleTextChange = (event) => {
    this.state[event.target.name] = event.target.value;
  };

  render() {
    console.log("API returns:", this.state.conversations);

    const { conversations } = this.state;
    let messages = conversations.map((conversation) => {
      return [conversation.email, conversation.messages];
    });
    if (messages === undefined) messages = [];

    let Conversation = (conversation) => {
      conversation = conversation[1];
      return conversation.map((message) => {
        return (
          <div
            className={
              "row justify-content-" + (message.is_me ? "end" : "start")
            }
          >
            <div
              className={
                "col-8 chatText " + (message.is_me ? "user1" : "user2")
              }
            >
              {message.body}
            </div>
          </div>
        );
      });
    };

    let Conversations = this.state.conversations.map((conversation) => {
      return (
        <div
          className="tab-pane fade"
          id={"v-pills-" + conversation.user_id}
          role="tabpanel"
          aria-labelledby={"v-pills-" + conversation.user_id + "-tab"}
        >
            <h4 className="text-center col-md-12">{conversation.email}</h4>
          <div className="textCenter">
            <a className="btn btn-info justify-content-center"
              href={"/user/"+conversation.user_id}>
              View Profile
            </a>
          </div>
          <div className="container chatBox">
            {
              //This is magnificent coding in act, selects the related conversation of the user
              Conversation(
                messages.find((message) => message[0] === conversation.email)
              )
            }
          </div>
          <form onSubmit={this.handleSendMessage}>
            <div className="form-group">
              <input
                type="text"
                name="message_body"
                className="form-control"
                id="form_body"
                placeholder="Enter Message"
                onChange={this.handleTextChange}
              />
              <small
                hidden={this.state.hide_enter_message}
                style={{ color: "darkred" }}
              >
                Please enter a message
              </small>
            </div>
            <button type="submit" className="btn btn-primary">
              Send
            </button>
          </form>
        </div>
      );
    });

    let LeftCol = conversations.map((user) => {
      return (
        <a
          className="nav-link"
          id={"v-pills-" + user.user_id + "-tab"}
          data-toggle="pill"
          href={"#v-pills-" + user.user_id}
          role="tab"
          aria-controls={"v-pills-" + user.user_id}
          aria-selected="false"
          style={{ "font-weight": user.is_visited ? "normal" : "bold" }}
          onClick={() => {
            // This can't be a separate function since we need user
            this.state.currentPill = user.email;
            let conversation = this.state.conversations.find(
              (conversation) => conversation.email === user.email
            );

            axios.get(serverUrl + `api/message/${conversation.id}/`, {
              headers: { Authorization: `Token ${this.state.token}` },
            });

            conversation.is_visited = true;
            this.setState({
              conversations: conversations,
              hide_enter_username: true,
              hide_enter_message: true,
            });
          }}
        >
          {user.email}
        </a>
      );
    });

    return (
      <div className="background">
        <CategoryBar />
        <div className="message-container">
          <Alert variant="success" hidden={this.state.isHiddenMessageSent}>
            Message Sent.
          </Alert>
          <Alert variant="danger" hidden={this.state.isHiddenUnknown}>
            Something went wrong.
          </Alert>
          <h2 className="text-center">Messages</h2>
          <div className="container">
            <div className="row">
              <div
                className="nav flex-column nav-pills col-4 no-padding-left leftColWrapper"
                id="v-pills-tab"
                role="tablist"
                aria-orientation="vertical"
              >
                <h4>Conversation History</h4>
                <a
                  className="nav-link active"
                  id="v-pills-new_conversation-tab"
                  data-toggle="pill"
                  href="#v-pills-new_conversation"
                  role="tab"
                  aria-controls="v-pills-new_conversation"
                  aria-selected="true"
                  onClick={() => {
                    this.setState({
                      hide_enter_message: true,
                      currentPill: "",
                    });
                  }}
                >
                  New Conversation
                </a>
                {LeftCol}
              </div>
              <div
                className="tab-content col-8 no-padding-left"
                id="v-pills-tabContent"
              >
                <div
                  className="tab-pane fade show active"
                  id="v-pills-new_conversation"
                  role="tabpanel"
                  aria-labelledby="v-pills-new_conversation-tab"
                >
                  <h4 className="text-center">New Conversation</h4>
                  <form onSubmit={this.handleNewConversation}>
                    <div className="form-group">
                      <input
                        type="text"
                        name="message_username"
                        className="form-control"
                        id="form-username"
                        placeholder="Enter Username"
                        onChange={this.handleTextChange}
                      />
                      <small
                        hidden={this.state.hide_enter_username}
                        style={{ color: "darkred" }}
                      >
                        Please enter a username
                      </small>
                    </div>
                    <div className="form-group">
                      <textarea
                        name="message_body"
                        className="form-control"
                        id="form_body"
                        rows="2"
                        placeholder="Enter Message"
                        onChange={this.handleTextChange}
                      />
                      <small
                        hidden={this.state.hide_enter_message}
                        style={{ color: "darkred" }}
                      >
                        Please enter a message
                      </small>
                    </div>
                    <button type="submit" className="btn btn-primary">
                      Send
                    </button>
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
