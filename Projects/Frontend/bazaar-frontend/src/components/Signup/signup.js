import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { Redirect } from "react-router-dom";


import "./signup.css";

export default class SignUpComponent extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          password: '',
          fname: '',
          lname: '',
          redirect: null
        }
      }
    
      handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
      }

    
      handleSubmit = event => {
    
        event.preventDefault();
        const data = new FormData();
        data.append("username", this.state.username);
        data.append("password", this.state.password);
        data.append("first_name", this.state.fname);
        data.append("last_name", this.state.lname);
    
    
        axios.post(`http://13.59.236.175:8000/api/user/signup/`, data)
          .then(res => {
    
            console.log(res);
            console.log(res.data);
            this.setState({ redirect: "/signin" });
          })
    
    
    
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
                            <label>First Name</label>
                            <input type="text" name="fname" className="form-control" placeholder="Enter first name"  
                            onChange={this.handleChange}/>
                        </div>
                        <div className="form-group col">
                            <label>Last name</label>
                            <input type="text" name="lname" className="form-control" placeholder="Enter last name"  
                            onChange={this.handleChange}/>
                        </div>
                    </div>
                    <div className="form-group">
                        <label>Email address</label>
                        <input type="text" name="username" className="form-control" placeholder="Enter email"  
                        onChange={this.handleChange}/>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="text" name="password" className="form-control" placeholder="Enter password"  
                        onChange={this.handleChange}/>
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