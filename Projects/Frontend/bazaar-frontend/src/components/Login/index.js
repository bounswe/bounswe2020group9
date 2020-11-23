import React, { Component } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';

import "./login.css";

export default class LoginComponent extends Component {

  constructor() {
    super();
    this.state = {
      username: '',
      password: '',
    }
  }


  handleChange = event => {

    this.setState({ [event.target.name]: event.target.value });

  }

  handleSubmit = event => {

    const cookies = new Cookies();
    event.preventDefault();

    // const data = { "username": "omerBenzer61@bazaar.com", "password": "mypw" }


    axios.post(`http://13.59.236.175:8000/api/user/login/`, { "username": this.state.username, "password": this.state.password })
      .then(res => {

        const cookie_key = 'user';
        bake_cookie(cookie_key, res);

        console.log(res);
        console.log(res.data);
      })



  }


  render() {
    return (
      <div className="entry-form">
        <form onSubmit={this.handleSubmit}>
          <h3>Sign In</h3>

          <div className="form-group">
            <label>Email address</label>
            <input type="text" name="username" className="form-control" placeholder="Enter email"
              onChange={this.handleChange} />
          </div>

          <div className="form-group">
            <label>Password</label>
            <input type="text" name="password" className="form-control" placeholder="Enter password"
              onChange={this.handleChange} />
          </div>

          <div className="form-group">
            <div className="custom-control custom-checkbox">
              <input type="checkbox" className="custom-control-input" id="customCheck1" />
              <label className="custom-control-label" htmlFor="customCheck1">Remember me</label>
            </div>
          </div>

          <button id="submit" type="submit" className="btn btn-block">Sign in</button>
          <p className="forgot-password">
            Forgot <a href="#">password?</a>
          </p>
        </form>
        <GoogleButton className="btn-google"
          onClick={() => { console.log('Google button clicked') }}
        />
      </div>

    );
  }
}