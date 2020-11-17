import React, { Component } from "react";
import GoogleButton from 'react-google-button'

export default class SignUpComponent extends Component {
    render() {
        return (
            <div className="entry-form">
                <form >
                    <h3>Sign Up</h3>

                    <div className="form-group">
                        <label>Email address</label>
                        <input type="email" className="form-control" placeholder="Enter email" />
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="password" className="form-control" placeholder="Enter password" />
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