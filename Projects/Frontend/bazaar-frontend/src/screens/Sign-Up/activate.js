import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import Alert from 'react-bootstrap/Alert'


import "./sign-up.scss";

export default class SignUp extends Component {

    constructor(props) {
        super(props);

      }

    componentDidMount() {
      //to do
      //domain/api/user/activate/<uidb64>/
    }

    render() {

        return (
          <div className="empty-space">
            <Alert variant="success">
              Your account has been activated.
              You {this.props.match.params["id"]} can <Alert.Link href="/signin">sign in</Alert.Link> to your account.
            </Alert>
          </div>

        );
    }
}