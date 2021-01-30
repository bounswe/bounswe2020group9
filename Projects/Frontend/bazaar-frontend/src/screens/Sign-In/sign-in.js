import React, { Component } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { bake_cookie } from 'sfcookies';
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import { Button, Alert} from "react-bootstrap";

import "./sign-in.scss";

export default class SignIn extends Component {

  constructor(props) {
    super(props);
    this.state = {
      username: '',
      password: '',
      isHiddenFail: true,
      isHiddenUnknown: true,
      redirect: null
    }
    // this.insertGapiScript = this.insertGapiScript.bind(this);
  }

  insertGapiScript = event => {

      event.preventDefault();
      const script = document.createElement('script')
      script.src = 'https://apis.google.com/js/platform.js'
      script.onload = () => {
        this.initializeGoogleSignIn()
      }
      document.body.appendChild(script)
  }

  initializeGoogleSignIn() {
    window.gapi.load('auth2', () => {
      window.gapi.auth2.init({
        client_id: '668711281350-36g6p1rlp9doabsb79lktm95hpa56qcj.apps.googleusercontent.com',
        cookiepolicy: 'single_host_origin'
      })

      console.log('api init')

      window.gapi.load('signin2', ()=> {
        const params = {
          
          onsuccess: this.onSuccess.bind(this) ,
          onfailure: this.onFailure ,
          }
         
         window.gapi.signin2.render('SignInButton' , params);
      })

    })

  }
  onSuccess(googleUser) {

    

    const profile = googleUser.getBasicProfile();
    console.log("Name: " + profile.getName());
    console.log("Mail: " + profile.getEmail());
    var id_token = googleUser.getAuthResponse().id_token;

     // let comp = this ;

    

    axios.post(`http://13.59.236.175:8000/api/user/googleuser/`, { "username": profile.getEmail(), 
                                                                  "token": googleUser.getAuthResponse().id_token, 
                                                                  "first_name": profile.getGivenName(),
                                                                  "last_name": profile.getFamilyName() 
                                                                })
      .then(res => {
        
        const cookie_key = 'user';
        const cookie_data = res.data;
        bake_cookie(cookie_key, cookie_data);

        console.log(res);
        console.log(res.data);

        this.setState({ redirect: "/" });
      })

      


    
    

  }
  onFailure(googleUser){
    console.log("Failure ");
  }

  /*componentDidMount() {
    console.log('loading');
    // this.insertGapiScript() ;

  }*/


  handleChange = event => {

    this.setState({ [event.target.name]: event.target.value });

  }


  handleSubmit = event => {

    event.preventDefault();

    // const data = { "username": "omerBenzer61@bazaar.com", "password": "mypw" }


    axios.post(serverUrl+'api/user/login/', { "username": this.state.username, "password": this.state.password })
      .then(res => {
        
        const cookie_key = 'user';
        const cookie_data = res.data;
        bake_cookie(cookie_key, cookie_data);

        console.log(res);
        console.log(res.data);

        this.setState({ redirect: "/" });
      }).catch((error) => {
        if (error.response) {
          // Request made and server responded
          this.setState({isHiddenFail: false})
        } else {
          // Something happened in setting up the request that triggered an Error
          this.setState({isHiddenUnknown: false})
        }


    })

  }


  render() {
    if (this.state.redirect) {
      return <Redirect to={this.state.redirect} />
    }
    
    return (
      <div className='background'>
        <div className="signin-form">
          <Alert variant="danger" hidden={this.state.isHiddenFail}>
            Invalid username or password.
          </Alert>
          <Alert variant="danger" hidden={this.state.isHiddenUnknown}>
            Something went wrong. Please try again later.
          </Alert>
          <form onSubmit={this.handleSubmit}>
            <h3>Sign In</h3>

            <div className="form-group">
              <label>Email address</label>
              <input type="text" name="username" className="form-control" placeholder="Enter email"
                onChange={this.handleChange} />
            </div>

            <div className="form-group">
              <label>Password</label>
              <input type="password" name="password" className="form-control" placeholder="Enter password"
                onChange={this.handleChange} />
            </div>

            <div className="form-group">
              <div className="custom-control custom-checkbox">
                <input type="checkbox" className="custom-control-input" id="customCheck1" />
                <label className="custom-control-label" htmlFor="customCheck1">Remember me</label>
              </div>
            </div>

            <div id="sign-in-div">
              <Button variant="primary" id="sign-in" type="submit">Sign in</Button>
            </div>

            <p className="forgot-password">
              Forgot <a href="/forgot-password">password?</a>
            </p>

          </form>
          <GoogleButton id= "SignInButton" onClick={this.insertGapiScript}className= "btn-google"></GoogleButton> 
          
        </div>
      </div>


    );
  }
}