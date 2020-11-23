import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'

import "./signup.css";

export default class SignUpComponent extends Component {
    constructor(){
        super();
        this.state = {
            fname: '',
            lname: '',
            email: '',
            password: '',
        }
    }

    signUp (){
        fetch('http://13.59.236.175:8000/api/user/', {
            method:"POST",
            body:JSON.stringify(this.state)
        }).then(response => {
            response.JSON().then(result=>{
                console.warn("result", result);
                localStorage.setItem('login', JSON.stringify({
                    login:true,
                    token:result.token
                }))
            })
        })
    }


      onChange = (e) => {

        this.setState({ [e.target.name]: e.target.value });
      }

      onSubmit = (e) => {
        e.preventDefault();
        // get our form data out of state
        const data = new FormData();
        data.append("fname", this.state.fname);
        data.append("lname", this.state.lname);
        data.append("email", this.state.email);
        data.append("password", this.state.password);

        axios.post('http://13.59.236.175:8000/api/user/', data)
            .then(res => {
                console.log(res);
                console.log(res.status);
                this.setState({ redirect: "True" });
            })
            .catch(error =>{
                if (error.response){
                    if (error.response.status == 401){
                        alert ("The email or password you have entered is incorrect. Please try again.");
                    }
                    else{
                        alert ("There has been an error. Please try again.");
                    }
                }
                else{
                    alert ("There has been an error. Please try again.");
                }

            })
        e.preventDefault();
      }

    render() {
        return (
            <div className="entry-form">
                <form onSubmit={this.signUp} >
                    <h3>Sign Up</h3>
                    <div className="row">
                        <div className="form-group col">
                            <label>First Name</label>
                            <input type="text" name="fname" className="form-control" placeholder="Enter first name"  onChange={this.onChange}/>
                        </div>
                        <div className="form-group col">
                            <label>Last name</label>
                            <input type="text" name="lname" className="form-control" placeholder="Enter last name"  onChange={this.onChange}/>
                        </div>
                    </div>
                    <div className="form-group">
                        <label>Email address</label>
                        <input type="text" name="email" className="form-control" placeholder="Enter email"  onChange={this.onChange}/>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="text" name="password" className="form-control" placeholder="Enter password"  onChange={this.onChange}/>
                    </div>

                    <button id="submit" type="submit" className="btn btn-block">Sign Up</button>

                    <p className="forgot-password">
                        Already registered <a href="#">sign in?</a>
                    </p>
                </form>
                <GoogleButton className="btn-google"
                    onClick={() => { console.log('Google button clicked') }}
                /> 
               
            </div>

        );
    }
}