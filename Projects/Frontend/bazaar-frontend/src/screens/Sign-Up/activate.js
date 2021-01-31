import React, { Component } from "react";
import axios from 'axios'
import {serverUrl} from '../../utils/get-url'
import Alert from 'react-bootstrap/Alert'


import "./sign-up.scss";

export default class SignUp extends Component {

    constructor(props) {
        super(props);
        this.state = {
          isHiddenFail: true,
          isHiddenSuccess: true
        }

      }

    componentDidMount() {
      //to do
      //domain/api/user/activate/<uidb64>/
      axios.get(serverUrl+'api/user/activate/'+this.props.match.params["id"]+"/")
      .then(res => {

        this.setState({ isHiddenSuccess: false });
      }).catch((error) => {

        this.setState({isHiddenFail: false})
      })

    }

    render() {

        return (
          <div className="empty-space background">
            <Alert variant="success" hidden={this.state.isHiddenSuccess}>
              Your account has been activated.
              You can <Alert.Link href="/signin">sign in</Alert.Link> to your account.
            </Alert>
            <Alert variant="danger" hidden={this.state.isHiddenFail}>
              Something went wrong.
            </Alert>
          </div>

        );
    }
}