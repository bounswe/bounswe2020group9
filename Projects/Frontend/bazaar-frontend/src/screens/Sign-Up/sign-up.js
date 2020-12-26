import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'


import "./sign-up.css";

export default class SignUp extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          password: '',
          fname: '',
          lname: '',
          utype: 'Customer',
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
            console.log(this.validateEmail(this.state.username));
          formIsValid = false;
          new_errors["username"] = "Please give a valid email.";      
        }

        if(this.state.utype === ''){
          formIsValid = false;
          new_errors["utype"] = "Please select user type.";      
        }

        this.setState({errors: new_errors});
        return formIsValid;
      }
    
      handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
        console.log(this.state.utype)
      }

      handleSubmit = event => {
    
        event.preventDefault();
        const data = new FormData();
        data.append("username", this.state.username);
        data.append("password", this.state.password);
        data.append("first_name", this.state.fname);
        data.append("last_name", this.state.lname);
        if (this.state.utype === 'Customer') {
            data.append("user_type", 1);
        } else {
            data.append("user_type", 2);
        }
        if (this.handleValidation()){
            console.log(this.state.username);
            axios.post(serverUrl+`api/user/signup/`, data)
              .then(res => {
        
                console.log(res);
                console.log(res.data);
                this.setState({ redirect: "/signin" });
              })

        } 
    
    
    
      }

    render() {
        if (this.state.redirect) {
            return <Redirect to={this.state.redirect} />
          }
        return (
            <div className="entry-form">
                <form onSubmit={this.handleSubmit} >
                    <h3>Sign Up</h3>
                    <div className="row">
                        <div className="form-group col">
                            <label>First Name (Optional)</label>
                            <input type="text" name="fname" className="form-control" placeholder="Enter first name"  
                            onChange={this.handleChange}/>
                        </div>
                        <div className="form-group col">
                            <label>Last name (Optional)</label>
                            <input type="text" name="lname" className="form-control" placeholder="Enter last name"  
                            onChange={this.handleChange}/>
                        </div>
                    </div>
                    <div className="form-group">
                        <label>Email address</label>
                        <input type="text" name="username" className="form-control" placeholder="Enter email"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["username"]}</div>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="password" name="password" className="form-control" placeholder="Enter password"  
                        onChange={this.handleChange}/>
                        <div className="error">{this.state.errors["password"]}</div>
                    </div>
                    
                    <div className="form-group row">
                        <label className="col-6 align-middle">User type</label>
                        <div className="form-check form-check-inline">
                            <input className="form-check-input align-middle" type="radio" name="utype" id="gridRadios1" value="Customer" 
                            onClick={this.handleChange} defaultChecked></input>
                            <label className="form-check-label" for="gridRadios1">
                                Customer
                            </label>
                        </div>
                        <div className="form-check form-check-inline">
                            <input className="form-check-input align-middle" type="radio" name="utype" id="gridRadios2" value="Vendor"
                            onClick={this.handleChange}></input>
                            <label className="form-check-label" for="gridRadios2">
                                Vendor
                            </label>
                        </div>
                        <div className="error">{this.state.errors["utype"]}</div>
                        
                        
                    </div>

                    <button id="submit" type="submit" className="btn btn-block">Sign Up</button>

                    <p className="forgot-password">
                        Already registered <a href="/signin">sign in?</a>
                    </p>
                </form>
                <GoogleButton className="btn-google"
                    onClick={() => { console.log('Google button clicked') }}
                /> 
               
            </div>

        );
    }
}