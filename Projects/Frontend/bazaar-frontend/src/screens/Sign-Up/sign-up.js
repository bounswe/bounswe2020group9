import React, { Component, useState } from "react";
import GoogleButton from 'react-google-button'
import axios from 'axios'
import { Redirect } from "react-router-dom";
import {serverUrl} from '../../utils/get-url'
import { Modal, Button, Alert } from "react-bootstrap";


import "./sign-up.scss";

export default class SignUp extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          password: '',
          fname: '',
          lname: '',
          isHidden: true,
          redirect: null,
          isOpen: false,
          terms_accepted: false,
          errors: {}
        }
      }
      validateEmail(email) {
            const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

      handleValidation(){
        let formIsValid = true;
        let new_errors = {password: '', username: ''};

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

        if(this.state.terms_accepted === false){
          formIsValid = false;
          new_errors["termsCheck"] = "Terms and Conditions must be accepted.";
        }

        this.setState({errors: new_errors});
        return formIsValid;
      }
    
      handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
      }

      handleTermsChange = event => {
        this.setState({terms_accepted: event.target.checked});
      }


      openModal = () => {
        this.setState({ isOpen: true })
        this.setState({isHiddenFail: false})
        this.setState({isHiddenSuccess: false})
        this.setState({isHiddenDeleteFail: false})
      };

      closeModal = () => {
        this.setState({ isOpen: false })
        this.setState({isHiddenFail: true})
        this.setState({isHiddenSuccess: true})
        this.setState({isHiddenDeleteFail: true})
      };

      handleSubmit = event => {
    
        event.preventDefault();

        if (this.handleValidation()){
          const data = new FormData();
          data.append("username", this.state.username);
          data.append("password", this.state.password);
          data.append("first_name", this.state.fname);
          data.append("last_name", this.state.lname);
          data.append("user_type", 1);

          axios.post(serverUrl+`api/user/signup/`, data)
            .then(res => {
      
              console.log(res);
              console.log(res.data);
              //this.setState({ redirect: "/signin" });
              this.setState({isHidden: false})
            }).catch((error) => {
              if (error.response) {
                // Request made and server responded
                let new_errors = this.state.errors
                new_errors["username"] = error.response.data["username"][0]
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

            <Modal show={this.state.isOpen} onHide={this.closeModal}>
              <Modal.Header closeButton>
                <Modal.Title>Terms and Conditions</Modal.Title>
              </Modal.Header>
              <Modal.Body>
                <p>
                  By signing up, you agree to be bound by these Terms.
                </p>
                <h6> Content </h6>
                <p>
                  Our service allows you to post, link, store, share and otherwise make available certain
                  information of any content. You are responsible for the content you share, and Bazaar
                  reserves to manage any kind of information, at any time. If you wish to purchase or service
                  made available through the platform, please contact us for further information.
                </p>
                <h6> Purchases </h6>
                <p>
                  Bazaar assumes no responsibility for, the content, privacy policies, or practices
                  of any kind of third-party services. You further acknowledge and agree that Bazaar
                  shall not be responsible or liable, directly or indirectly, for any damage or loss
                  caused or alleged to be caused by or in connection with use of or reliance on any
                  such content, goods or services available on or through any such web sites or services.
                </p>
                <h6> Changes </h6>
                <p>
                  We reserve the right, at our sole discretion, to modify or replace these Terms at any time.
                </p>
                <h6> Contact Us </h6>
                <p>
                  If you have any questions about these terms, please contact us.
                </p>
              </Modal.Body>
              <Modal.Footer>
                <Button variant="secondary" onClick={this.closeModal}>Close</Button>
              </Modal.Footer>
            </Modal>

            <div className="signup-form ">
              <Alert variant="success" hidden={this.state.isHidden}>
                A confirmation mail has been sent to your account, please check it.
                You can <Alert.Link href="/signin">sign in</Alert.Link> to your account after the confirmation is done.
              </Alert>
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

                    <div className="form-check">
                        <input type="checkbox" className="form-check-input" name="termsCheck"
                               value="" onChange={this.handleTermsChange}/>
                        <label className="form-check-label" htmlFor="termsCheck">
                            I agree to the <a href="#" onClick={this.openModal}>Terms and Conditions</a></label>
                    </div>
                    <div className="error">{this.state.errors["termsCheck"]}</div>

                    <p className="user-type-change">
                      Want to <a href="/signup-vendor">sign up as Vendor?</a>
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