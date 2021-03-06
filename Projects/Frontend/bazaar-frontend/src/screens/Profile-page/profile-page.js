import React, { Component } from "react";
import axios from 'axios'
import { read_cookie } from 'sfcookies';
import {serverUrl} from '../../utils/get-url'
import { Button , Alert} from "react-bootstrap";
import CategoryBar from "../../components/category-bar/category-bar";


import "./profilepage.scss";

export default class ProfilePage extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          currpw: '',
          newpw: '',
          confpw: '',
          first_name: '',
          last_name: '',
          fullAddress: '',
          addressName: '',
          postalCode: '',
          user_type: 0,
          token: '',
          isCustomer: true,
          redirect: null,
          hasError: false,
          isHiddenStates: [true, true, true, true],
          errors: {}
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });
        
      }

      setHiddenStates(showNumber) {
        let tempStates = this.state.isHiddenStates;
        for (let i=0;i<tempStates.length;i++) {
          tempStates[i] = !(i === showNumber);
        }
        this.setState({isHiddenStates: tempStates});
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
        this.setState({user_type: myCookie.user_type})
        const header = {headers: {Authorization: "Token "+myCookie.token}};
        
        if (this.handlePasswordValidation()) {
            axios.post(serverUrl+'api/user/resetpwprofile/', body, header)
            .then(res => {
  
              console.log(res);
              console.log(res.data);
              //this.setState({ redirect: "/signin" });
              this.setHiddenStates(1);
            }).catch((error) => {
              if (error.response) {
                // Request made and server responded
                this.setHiddenStates(2);
    
              } else {
                // Something happened in setting up the request that triggered an Error
                this.setHiddenStates(3);

              }
    
    
          })

        } else {
            this.setState({ [this.state.hasError]: true });
        }
      }

      handleVendorValidation(){
        let formIsValid = true;
        let new_errors = {};

        if(this.state.first_name.length === 0){
          formIsValid = false;
          new_errors["first_name"] = "Please provide your name.";
        }
  
        if(this.state.last_name.length === 0){
          formIsValid = false;
          new_errors["last_name"] = "Please provide your last name";      
        }
   
        if(this.state.company.length === 0){
          formIsValid = false;
          new_errors["company"] = "Please provide your company";      
        }

        this.setState({errors: new_errors});
        return formIsValid;
      }
    
      handleSubmit = event => {  
        event.preventDefault();

        let myCookie = read_cookie('user');
        const header = {
          headers: {
            Authorization: "Token "+myCookie.token
          }
        };
        if (this.state.user_type === 2 && this.handleVendorValidation()){
          const data = {
            first_name: this.state.first_name,
            last_name: this.state.last_name,
            company: this.state.company,
          }

          axios.put(serverUrl+'api/user/profile/', data, header)
          .then(res => {
            this.setHiddenStates(0);

          }).catch((error) => {
            if (error.response) {
              // Request made and server responded
              this.setHiddenStates(2);
              console.log(error.response)
            } else if (error.request) {
              this.setHiddenStates(3);
              // The request was made but no response was received
              console.log(error.request);
            } else {
              // Something happened in setting up the request that triggered an Error
              console.log('Error', error.message);
            }
            this.setHiddenStates(3);

  
  
        })
        } else if (this.state.user_type === 1){
          const data = {
            first_name: this.state.first_name,
            last_name: this.state.last_name,
          }
          axios.put(serverUrl+'api/user/profile/', data, header)
          .then(res => {
            this.setHiddenStates(0);
          }).catch((error) => {
            if (error.response) {
              // Request made and server responded
              this.setHiddenStates(2);
              console.log(error.response)
            } else if (error.request) {
              // The request was made but no response was received
              this.setHiddenStates(3);
              console.log(error.request);
            } else {
              // Something happened in setting up the request that triggered an Error
              this.setHiddenStates(3);
              console.log('Error', error.message);
            }
            this.setHiddenStates(3);

  
  
        })
        }



      }

      componentDidMount() {
        let myCookie = read_cookie('user')
        axios.get(serverUrl+`api/user/${myCookie.user_id}/`)
          .then(res => {
              console.log("res data:  "+res.data.user_type)
              this.setState({first_name : res.data.first_name})
              this.setState({last_name : res.data.last_name})
              
              if (res.data.user_type === 1){

                this.setState({user_type: 1});
              } else {
                this.setState({user_type: 2});
                this.setState({company : res.data.company})
                this.setState({isCustomer : false})

              }

          }).catch(err => {
            console.log("error:  "+err)
          })
        

      }


    render() {
      return (
        <div className='background'>
          <CategoryBar></CategoryBar>
          <div className="profile-container">
            <Alert variant="success" hidden={this.state.isHiddenStates[0]}>
              Profile details updated.
            </Alert>
            <Alert variant="success" hidden={this.state.isHiddenStates[1]}>
              Password updated.
            </Alert>
            <Alert variant="danger" hidden={this.state.isHiddenStates[2]}>
              Wrong password.
            </Alert>
            <Alert variant="danger" hidden={this.state.isHiddenStates[3]}>
              Something went wrong.
            </Alert>
              <div className="justify-content-center" id="header3">
                  <h2 className="text-center">Profile Page</h2>
              </div>
              <div className="profile-form row">

                  <div className=" col-lg-6 col-md-6 col-sm-6 no-padding-left border-right border-left">
                      <h3 className="text-center heading-2">Change Details</h3>
                      <div className="account-update">
                          <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>
                            <div className="form-group row">
                                <label className="col-4 align-middle">First Name</label>
                                <div className="col">
                                  <input type="text" name="first_name"className="form-control col" value = {this.state.first_name}
                                  onChange={this.handleChange} required/>
                                  <div className="error">{this.state.errors["first_name"]}</div>                                
                                </div>
                            </div>
                            <div className="form-group row">
                                <label className="col-4 align-middle">Last Name</label>
                                <div className="col">
                                  <input type="text" name="last_name"className="form-control col" value = {this.state.last_name}
                                  onChange={this.handleChange} required/>
                                  <div className="error">{this.state.errors["last_name"]}</div>
                                </div>
                            </div>
                            <div className="form-group row" hidden={this.state.isCustomer}>
                                <label className="col-4 align-middle">Company</label>
                                <div className="col">
                                  <input type="text" name="company" className="form-control col" value = {this.state.company}
                                  onChange={this.handleChange}/>
                                  <div className="error">{this.state.errors["company"]}</div>
                                </div>
                            </div>
                            <div className="form-group row">
                                <label className="col-4 align-middle">User Type</label>
                                <div className="col">
                                  <input type="text" name="last_name"className="form-control col" value = {this.state.user_type}
                                  onChange={this.handleChange} disabled/>
                                </div>
                            </div>

                            <div id="save-changes-div">
                              <Button variant="primary" id="save-changes" type="submit">Save changes</Button>
                            </div>

                          </form>
                      </div>
                  </div>
                  <div className=" col-lg-6 col-md-6 col-sm-6 no-padding-left border-right">
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
        </div>
          

      );
    }
}