import React, {Component} from "react";
import CategoryBar from "../../components/category-bar/category-bar";
import {Alert, Button} from "react-bootstrap";
import axios from "axios";
import {serverUrl} from "../../utils/get-url";
import {read_cookie} from "sfcookies";
import "./messages.scss";



export default class Messages extends Component {
  constructor() {
    super();
    this.state = {
      isHiddenMessageSent: true,
      isHiddenUnknown: true,
      currentPill: "",
      message_username: "",
      message_body: "",
      conversation_history: [],
      messages: [],
      errors: {}
    }
  }

  componentDidMount() {
    let myCookie = read_cookie("user");
    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };
    this.setState({conversation_history: []})
    axios.get(serverUrl + `api/message/conversations/`, {
      headers: headers
    })
      .then((response) => {
        this.setState({conversation_history:response.data.conversations});
        this.state.conversation_history.forEach((conversation)=>{
          axios.get(serverUrl + `api/message/${conversation.id}/`, {
            headers: headers
          }).then((response)=>{
            //console.log(("message"+conversation.id),response.data);
            this.setState({messages:(this.state.messages.concat([[conversation.email,response.data]]))})
          });
        });
        //console.log("this.state.conversations",this.state.conversations);
      });
  }

  handleSendMessage = (event) => {
    event.preventDefault();

    const body = new FormData();
    body.append("receiver_username", this.state.currentPill);
    body.append("body", this.state.message_body);

    let myCookie = read_cookie('user');
    const header = {headers: {Authorization: "Token "+myCookie.token}};

    axios.post( serverUrl + "api/message/", body, header)
      .then(()=>{
        this.setState({isHiddenMessageSent:false});
      }).catch(error => {
        this.setState({isHiddenUnknown:false});
      });

    console.log("Message Sent", this.state.currentPill, this.state.message_body);
    window.location.reload();
  };

  handleNewConversation = (event)=>{
    event.preventDefault();

    const body = new FormData();
    body.append("receiver_username", this.state.message_username);
    body.append("body", this.state.message_body);

    let myCookie = read_cookie('user');
    const header = {headers: {Authorization: "Token "+myCookie.token}};

    axios.post( serverUrl + "api/message/", body, header)
      .then(()=>{
        this.setState({isHiddenMessageSent:false});
      }).catch(error => {
        this.setState({isHiddenUnknown:false});
      });

    console.log("New Conversation Created", this.state.message_username, this.state.message_body);
    window.location.reload();
  }

  handleTextChange = (event)=>{
    this.state[event.target.name] = event.target.value;
    console.log(event.target.name, event.target.value);
  };

  render() {
    const {conversation_history, messages} = this.state;

    //console.warn("messages",messages);
    //console.log("this.state.conversation_history",conversation_history);

    let Conversation = (conversation) => {
      if (conversation[0] === undefined) return;
      if (conversation.size > 1) console.warn("CONVERSATION SIZE > 1", conversation);
      conversation = conversation[0][1];
      console.log("CONVERSATION",conversation);
      return conversation.map((message)=>{
        return (
          <div className={"row justify-content-"+ (message.is_user1 ? "end" : "start")}>
            <div className={"col-8 chatText " + (message.is_user1 ? "user1" : "user2")}>
              {message.body}
            </div>
          </div>
        )});
    }

    let Conversations = this.state.conversation_history.map((conversation) => {
      return (
        <div className="tab-pane fade" id={"v-pills-"+conversation.user_id} role="tabpanel" aria-labelledby={"v-pills-"+conversation.user_id+"-tab"}>
          <h4 className="text-center">{conversation.email}</h4>
          <div className="container chatBox">
            {
              //This is magnificent coding in act, selects the related conversation of the user
              Conversation(messages.filter(message => message[0] === conversation.email))
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
                onChange={this.handleTextChange}/>
            </div>
            <button type="submit" className="btn btn-primary">Send</button>
          </form>
        </div>
      )});


    let LeftCol = conversation_history.map((user) => {
      return (
        <a className="nav-link" id={"v-pills-"+user.user_id+"-tab"} data-toggle="pill" href={"#v-pills-"+user.user_id} role="tab"
           aria-controls={"v-pills-"+user.user_id} aria-selected="false" onClick={()=>{this.state.currentPill=user.email}}>{user.email}</a>
      );
    });


    return (
      <div className='background'>
        <CategoryBar/>
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
              <div className="nav flex-column nav-pills col-4 no-padding-left" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                <h4>Conversation History</h4>
                <a className="nav-link active" id="v-pills-new_conversation-tab" data-toggle="pill" href="#v-pills-new_conversation" role="tab"
                   aria-controls="v-pills-new_conversation" aria-selected="true" onClick={()=>{this.state.currentPill="";}}>New Conversation</a>
                {LeftCol}
              </div>
              <div className="tab-content col-8 no-padding-left" id="v-pills-tabContent">
                <div className="tab-pane fade show active" id="v-pills-new_conversation" role="tabpanel"
                     aria-labelledby="v-pills-new_conversation-tab">
                  <h4 className="text-center">New Conversation</h4>
                  <form onSubmit={this.handleNewConversation}>
                    <div className="form-group">
                      <input
                        type="text"
                        name="message_username"
                        className="form-control"
                        id="form-username"
                        placeholder="Enter Username"
                        onChange={this.handleTextChange}/>
                    </div>
                    <div className="form-group">
                      <textarea
                        name="message_body"
                        className="form-control"
                        id="form_body"
                        rows="2"
                        placeholder="Enter Message"
                        onChange={this.handleTextChange}/>
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