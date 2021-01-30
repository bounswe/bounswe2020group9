import React, { Component } from "react";
import axios from 'axios'
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import { Button, Alert} from "react-bootstrap";

import "./sign-in.scss";

export default class ResetPassword extends Component {

  constructor() {
    super();
    this.state = {
      password: '',
      errors: {},
      isHiddenSuccess: true,
      isHiddenFail: true,
      redirect: null,
    }
  }

  handleValidation(){
    let formIsValid = true;
    let new_errors = {};

    if(this.state.password.length < 8){
      formIsValid = false;
      new_errors["password"] = "Please must be at least 8 characters.";
    }
    this.setState({errors: new_errors});
    console.log(this.state.errors)
    return formIsValid;
  }

  handleChange = event => {

    this.setState({ [event.target.name]: event.target.value });

  }

  handleSubmit = event => {

    event.preventDefault();

    // const data = { "username": "omerBenzer61@bazaar.com", "password": "mypw" }

    if (this.handleValidation()) {//id ekle
      axios.post(serverUrl+`api/user/resetpw/`+this.props.match.params["id"]+"/", { "new_password": this.state.password })
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
          Your password has been reset.
          You can <Alert.Link href="/signin">sign in</Alert.Link> to your account.
        </Alert>
        <Alert variant="danger" hidden={this.state.isHiddenFail}>
          Something went wrong. Please try again later.
        </Alert>
        <form onSubmit={this.handleSubmit}>
          <h3>Reset password</h3>

          <div className="form-group">
            <label>New Password</label>
            <input type="password" name="password" className="form-control" placeholder="Enter password"
              onChange={this.handleChange} />
            <div className="error">{this.state.errors["password"]}</div>
          </div>

          <div id="sign-in-div">
            <Button variant="primary" id="sign-in" type="submit">Reset password</Button>
          </div>
        </form>

      </div>

    );
  }
}