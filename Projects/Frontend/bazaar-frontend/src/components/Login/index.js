import React, { Component } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'

import "./login.css";

export default class LoginComponent extends Component {

    constructor (){
        super();
        this.state = {
            username: '',
            password: '',
        }
    }


    login (event){
        const data = new FormData();

        data.append("username", this.state.username);
        data.append("password", this.state.password);
        console.log(" data: "+data)

        axios.post('http://13.59.236.175:8000/api/user/login/', data)
        .then(response => {
            console.log(response.status)
            response.JSON()
            .then(res => {
                console.log(res);
                console.log(res.status);

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
        event.preventDefault();
    })
}

      onChange = (e) => {

        this.setState({ [e.target.name]: e.target.value });
      }





    render() {
        return (
            <div className="entry-form">
                <form onSubmit={this.login}>
                    <h3>Sign In</h3>

                    <div className="form-group">
                        <label>Email address</label>
                        <input type="text" name="username" className="form-control" placeholder="Enter email" 
                        onChange={this.onchange}/>
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="text" name="password" className="form-control" placeholder="Enter password" 
                        onChange={this.onchange}/>
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