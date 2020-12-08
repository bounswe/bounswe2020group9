import React, { Component } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import { Redirect } from "react-router-dom";

import "./sign-in.css";

export default class ForgotPassword extends Component {

  constructor() {
    super();
    this.state = {
      username: '',
      redirect: null,
    }
  }


  handleChange = event => {

    this.setState({ [event.target.name]: event.target.value });

  }

  handleSubmit = event => {

    event.preventDefault();

    // const data = { "username": "omerBenzer61@bazaar.com", "password": "mypw" }


    axios.post(`http://13.59.236.175:8000/api/user/login/`, { "username": this.state.username, "password": this.state.password })
      .then(res => {

      })

  }


  render() {
    if (this.state.redirect) {
      return <Redirect to={this.state.redirect} />
    }
    
    return (
      <div className="entry-form">
        <form>
          <h3>Forgot Password</h3>

          <div className="form-group">
            <label>Email address</label>
            <input type="text" name="username" className="form-control" placeholder="Enter email"
              onChange={this.handleChange} />
          </div>

          <button id="submit" type="submit" className="btn btn-block" onClick={this.handleSubmit}>Send email</button>

        </form>
        <GoogleButton className="btn-google"
          onClick={() => { console.log('Google button clicked') }}
        />
      </div>

    );
  }
}