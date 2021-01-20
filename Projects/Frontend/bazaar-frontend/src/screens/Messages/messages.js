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
          conversation.id -= 5; // temporary fix until deploy
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
            <div className={"col-8 chatText user" + (message.is_user1 ? 1 : 2)}>
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
          <form>
            <div className="form-group">
              <textarea className="form-control" id="form_body" rows="2" placeholder="Enter Message"/>
            </div>
            <button type="submit" className="btn btn-primary">Send</button>
          </form>
        </div>
      )});


    let LeftCol = conversation_history.map((user) => {
      return (
        <a className="nav-link" id={"v-pills-"+user.user_id+"-tab"} data-toggle="pill" href={"#v-pills-"+user.user_id} role="tab"
           aria-controls={"v-pills-"+user.user_id} aria-selected="false">{user.email}</a>
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