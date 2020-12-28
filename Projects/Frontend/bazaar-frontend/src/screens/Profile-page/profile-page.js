import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import {serverUrl} from '../../utils/get-url'
import { Button , Alert} from "react-bootstrap";

import "./profilepage.scss";
import { faGlassWhiskey } from "@fortawesome/free-solid-svg-icons";

export default class ProfilePage extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          currpw: '',
          newpw: '',
          confpw: '',
          fname: '',
          lname: '',
          utype: '',
          token: '',
          redirect: null,
          hasError: false,
          isHiddenSuccessPw: true,
          isHiddenSuccess: true,
          isHiddenFail: true,
          isHiddenUnknown: true,
          errors: {}
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });
        
      }

      handlePasswordValidation(){
        let formIsValid = true;
        let new_errors = {};
        //Name
        if(this.state.newpw.length !== 0 && this.state.newpw.length < 8){
          formIsValid = false;
          new_errors["newpw"] = "New password must be at least 8 characters.";
        }
  
        if(this.state.confpw !== this.state.newpw){
          formIsValid = false;
          new_errors["confpw"] = "New passwords do not match.";      
        }
   
        //Email
        if(this.state.currpw.length === 0){
          formIsValid = false;
          new_errors["currpw"] = "Please give your current password.";
        }

        if (this.state.newpw.length === 0){
          formIsValid = false;
          new_errors["newpw"] = "Please provide new password.";
        }

        this.setState({errors: new_errors});
        return formIsValid;
      }
    
      handlePasswordSubmit = event => {  

        event.preventDefault();
        const body = new FormData();
        body.append("new_password", this.state.newpw);
        body.append("old_password", this.state.currpw);

        let myCookie = read_cookie('user');
        body.append("user_id", myCookie.user_id)
        const header = {headers: {Authorization: "Token "+myCookie.token}};
        
        if (this.handlePasswordValidation()) {
            axios.post(serverUrl+'api/user/resetpwprofile/', body, header)
            .then(res => {
  
              console.log(res);
              console.log(res.data);
              //this.setState({ redirect: "/signin" });
              this.setState({isHiddenSuccessPw: false})
            }).catch((error) => {
              if (error.response) {
                // Request made and server responded
                this.setState({isHiddenFail: false})
    
              } else {
                // Something happened in setting up the request that triggered an Error
                this.setState({isHiddenUnknown: false})

              }
    
    
          })

        } else {
            this.setState({ [this.state.hasError]: true });
        }
      }
    
      handleSubmit = event => {  
        event.preventDefault();
        const body = new FormData();
        body.append("first_name", this.state.fname);
        body.append("last_name", this.state.lname);

        let myCookie = read_cookie('user');
        const header = {
          headers: {
            Authorization: "Token "+myCookie.token
          }
        };

        axios.put(serverUrl+'api/user/profile/', body, header)
        .then(res => {
  
          this.setState({isHiddenSuccess: false})
        }).catch((error) => {
          if (error.response) {
            // Request made and server responded
            console.log(error.response)
          } else if (error.request) {
            // The request was made but no response was received
            console.log(error.request);
          } else {
            // Something happened in setting up the request that triggered an Error
            console.log('Error', error.message);
          }
          this.setState({isHiddenUnknown: false})


      })


      }

      componentDidMount() {
        let myCookie = read_cookie('user')
        axios.get(serverUrl+`api/user/${myCookie.user_id}/`)
          .then(res => {
              console.log(res.data)
              this.setState({fname : res.data.first_name})
              this.setState({lname : res.data.last_name})
              
              if (res.data.user_type === 1){
                this.setState({utype: "Customer"});
              } else {
                this.setState({utype: "Vendor"});
              }

          })

      }


    render() {
      if (this.state.hasError) {
        // You can render any custom fallback UI
        return <h1>{this.validate.message}</h1>;
      }
        return (
            <div className="profile-form">
              <Alert variant="success" hidden={this.state.isHiddenSuccess}>
                Profile details updated.
              </Alert>
              <Alert variant="success" hidden={this.state.isHiddenSuccessPw}>
                Password updated.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenFail}>
                Wrong password.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenUnknown}>
                Something went wrong.
              </Alert>
                <div className="profile-container justify-content-center" id="header3">
                    <h2 className="text-center">Profile Page</h2>
                </div>
                <div className="profile-container row">

                    <div className=" col-lg-6 col-md-6 col-sm-6 no-padding-left border-right">
                        <h3 className="text-center heading-2">Change Details</h3>
                        <div className="account-update">
                            <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">First Name</label>
                                  <div className="col">
                                    <input type="text" name="fname"className="form-control col" value = {this.state.fname}
                                    onChange={this.handleChange} required/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Last Name</label>
                                  <div className="col">
                                    <input type="text" name="lname"className="form-control col" value = {this.state.lname}
                                    onChange={this.handleChange} required/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">User Type</label>
                                  <div className="col">
                                    <input type="text" name="lname"className="form-control col" value = {this.state.utype}
                                    onChange={this.handleChange} disabled/>
                                  </div>
                              </div>

                              <div id="save-changes-div">
                                <Button variant="primary" id="save-changes" type="submit">Save changes</Button>
                              </div>

                            </form>
                        </div>
                    </div>
                    <div className=" col-lg-6 col-md-6 col-sm-6 no-padding-left">
                    <h3 className="text-center heading-2">Change Password</h3>
                        <div className="password-update">
                            <form className='needs-validation' onSubmit={this.handlePasswordSubmit} noValidate>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Password</label>
                                  <div className="col password-input">
                                    <input type="password" name="currpw" className="form-control col" placeholder="Password" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["currpw"]}</div>
                                  </div>
                              </div>                    
                              <div className="form-group row">
                                  <label className="col-4 align-middle">New Password</label>
                                  <div className="col password-input">
                                    <input type="password" name="newpw" className="form-control col" placeholder="New password" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["newpw"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">New Password(again)</label>
                                  <div className="col password-input">
                                    <input type="password" name="confpw" className="form-control col" placeholder="New password(again)" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["confpw"]}</div>

                                  </div>
                              </div>
                              <div id="save-changes-div">
                                <Button variant="primary" id="save-changes" type="submit">Save changes</Button>
                              </div>

                            </form>
                        </div>
                    </div>
                </div>
                  
            </div>
            

        );
    }
}