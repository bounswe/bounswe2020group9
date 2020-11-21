import React, { Component } from "react";

export default class LoginComponent extends Component {

    render() {
        return (
            <div className="entry-form">
                <form>
                    <h3>Sign In</h3>

                    <div className="form-group">
                        <label>Email address</label>
                        <input type="email" className="form-control" placeholder="Enter email" />
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input type="password" className="form-control" placeholder="Enter password" />
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
            </div>

        );
    }
}