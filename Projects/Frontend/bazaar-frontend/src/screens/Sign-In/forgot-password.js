import React, { Component } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import { Button, Alert} from "react-bootstrap";

import "./sign-in.scss";

export default class ForgotPassword extends Component {

  constructor() {
    super();
    this.state = {
      username: '',
      errors: {},
      isHiddenSuccess: true,
      isHiddenFail: true,
      redirect: null,
    }
  }

  handleValidation(){
    let formIsValid = true;
    let new_errors = {};

    if(this.state.username.length === 0 || !this.validateEmail()){
      formIsValid = false;
      new_errors["username"] = "Please give a valid email.";
    }
    this.setState({errors: new_errors});
    console.log(this.state.errors)
    return formIsValid;
  }

  validateEmail() {
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(this.state.username).toLowerCase());
  }

  handleChange = event => {

    this.setState({ [event.target.name]: event.target.value });

  }

  handleSubmit = event => {

    event.preventDefault();

    // const data = { "username": "omerBenzer61@bazaar.com", "password": "mypw" }

    if (this.handleValidation()) {
      axios.post(serverUrl+`api/user/resetpwmail/`, { "username": this.state.username })
      .then(res => {
        console.log(res.data)
        this.setState({isHiddenSuccess: false})
      }).catch((error) => {
        if (error.response) {
          // Request made and server responded

        } else if (error.request) {
          // The request was made but no response was received
          console.log(error.request);
        } else {
          // Something happened in setting up the request that triggered an Error
          console.log('Error', error.message);
        }
      this.setState({isHiddenFail: false})

    })


    } else {

    }
  }


  render() {
    if (this.state.redirect) {
      return <Redirect to={this.state.redirect} />
    }
    
    return (
      <div className="entry-form background">
        <Alert variant="success" hidden={this.state.isHiddenSuccess}>
          An email has been sent to your account. Please click on the link to reset your password.
        </Alert>
        <Alert variant="danger" hidden={this.state.isHiddenFail}>
          Something went wrong. Please try again later.
        </Alert>
        <form onSubmit={this.handleSubmit}>
          <h3>Forgot Password</h3>

          <div className="form-group">
            <label>Email address</label>
            <input type="text" name="username" className="form-control" placeholder="Enter email"
              onChange={this.handleChange} />
            <div className="error">{this.state.errors["username"]}</div>
          </div>

          <div id="sign-in-div">
            <Button variant="primary" id="sign-in" type="submit">Send email</Button>
          </div>
        </form>

      </div>

    );
  }
}