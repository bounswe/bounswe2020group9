import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import Alert from 'react-bootstrap/Alert'


import "./sign-up.scss";

export default class SignUp extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          password: '',
          fname: '',
          lname: '',
          company: '',
          address: '',
          address_name: '',
          postal_code: '',
          isHidden: true,
          redirect: null,
          errors: {}
        }
      }
      validateEmail(email) {
            const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

      handleValidation(){
        let formIsValid = true;
        let new_errors = {passwprd: '', username: ''};

        if(this.state.password.length < 8){
          formIsValid = false;
          new_errors["password"] = "Password must be at least 8 characters.";
        }
  
        if(this.validateEmail(this.state.username) === false){
          formIsValid = false;
          new_errors["username"] = "Please give a valid email.";      
        }

        if(this.state.company === ''){
          formIsValid = false;
          new_errors["company"] = "Please enter your company name.";      
        }

        if(this.state.fname === ''){
          formIsValid = false;
          new_errors["fname"] = "Please enter your name.";      
        }

        if(this.state.lname === ''){
          formIsValid = false;
          new_errors["lname"] = "Please enter your last name.";      
        }

        if(this.state.address === ''){
          formIsValid = false;
          new_errors["address"] = "Please enter your address.";      
        }

        if(this.state.address_name === ''){
          formIsValid = false;
          new_errors["address_name"] = "Please enter your address name.";      
        }

        if(this.state.postal_code === ''){
          formIsValid = false;
          new_errors["postal_code"] = "Please enter your postal code.";      
        } else {
          const parsed = parseInt(this.state.postal_code, 10);
          if (isNaN(parsed)) {
            formIsValid = false;
            new_errors["postal_code"] = "Postal code should be integer.";   
          }
        }
        this.setState({errors: new_errors});
        return formIsValid;
      }
    
      handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
      }

      handleSubmit = event => {
    
        event.preventDefault();

        if (this.handleValidation()){
          const data = new FormData();
          data.append("username", this.state.username);
          data.append("password", this.state.password);
          data.append("first_name", this.state.fname);
          data.append("last_name", this.state.lname);
          data.append("company", this.state.company);
          data.append("postal_code", this.state.postal_code);
          data.append("address", this.state.address);
          data.append("address_name", this.state.address_name);
          data.append("user_type", 2);
          axios.post(serverUrl+`api/user/signup/`, data)
            .then(res => {
      
              console.log(res);
              console.log(res.data);
              this.setState({isHidden: false})
            }).catch((error) => {
              if (error.response) {
                // Request made and server responded
                let new_errors = this.state.errors
                new_errors["username"] = error.response.data["username"][0]
                //console.log(error.response.data)
                this.setState({errors: new_errors})
              } else if (error.request) {
                // The request was made but no response was received
                console.log(error.request);
              } else {
                // Something happened in setting up the request that triggered an Error
                console.log('Error', error.message);
              }


          })
        }
      }

    render() {
        if (this.state.redirect) {
            return <Redirect to={this.state.redirect} />
          }
        return (
          <div className='background'>
            <div className="signup-form">
              <Alert variant="success" hidden={this.state.isHidden}>
                A confirmation mail has been sent to your account, please check it.
                You can <Alert.Link href="/signin">sign in</Alert.Link> to your account after the confirmation is done.
              </Alert>
                <form onSubmit={this.handleSubmit} >
                    <h3>Sign Up as Vendor</h3>
                    <div className="row">
                        <div className="form-group col">
                            <label>First Name</label>
                            <input type="text" name="fname" className="form-control" placeholder="Enter first name"  
                            onChange={this.handleChange}/>
                            <div className="error">{this.state.errors["fname"]}</div>

                        </div>
                        <div className="form-group col">
                            <label>Last name</label>
                            <input type="text" name="lname" className="form-control" placeholder="Enter last name"  
                            onChange={this.handleChange}/>
                            <div className="error">{this.state.errors["lname"]}</div>
                        </div>
                    </div>
                    <div className="form-group">
                        <label>Email address</label>
                        <input type="text" name="username" className="form-control" placeholder="Enter email"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["username"]}</div>
                    </div>

                    <div className="form-group">
                        <label>Company</label>
                        <input type="text" name="company" className="form-control" placeholder="Enter company"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["company"]}</div>
                    </div>

                    <div className="form-group">
                        <label>Address</label>
                        <input type="text" name="address" className="form-control" placeholder="Enter full address"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["address"]}</div>
                    </div>
                    <div className="form-group">
                        <label>Postal Code</label>
                        <input type="text" name="postal_code" className="form-control" placeholder="Enter postal code"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["postal_code"]}</div>
                    </div>
                    <div className="form-group">
                        <label>Address name</label>
                        <input type="text" name="address_name" className="form-control" placeholder="Enter address name"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["address_name"]}</div>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="password" name="password" className="form-control" placeholder="Enter password"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["password"]}</div>
                    </div>

                    <p className="user-type-change">
                        Want to <a href="/signup">sign up as Customer?</a>
                    </p>

                    <button id="submit" type="submit" className="btn btn-block">Sign Up</button>

                    <p className="sign-in-redirect">
                        Already registered <a href="/signin">sign in?</a>
                    </p>
                </form>
                <GoogleButton className="btn-google"
                    onClick={() => { console.log('Google button clicked') }}
                /> 
               
            </div>
          </div>


        );
    }
}