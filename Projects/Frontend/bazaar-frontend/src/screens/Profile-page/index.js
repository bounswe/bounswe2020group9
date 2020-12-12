import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';

import "./profilepage.css";
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
          isEnabled: true,
          errors: {}
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });
        console.log("value  :  "+event.target.value)
        
      }

      handleValidation(){
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
        if(this.state.currpw.length === 0 && this.state.newpw.length !== 0){
          formIsValid = false;
          new_errors["currpw"] = "Please give your current password.";
        }

        if (this.state.currpw.length !== 0 && this.state.newpw.length === 0){
          formIsValid = false;
          new_errors["newpw"] = "Please provide new password.";
        }

        this.setState({errors: new_errors});
        return formIsValid;
      }

    
      handleSubmit = event => {  

    
        event.preventDefault();
        const body = new FormData();
        body.append("first_name", this.state.fname);
        body.append("last_name", this.state.lname);
        body.append("password", this.state.newpw);

        let myCookie = read_cookie('user');
        const header = {Authorization: "Token "+myCookie.token};
        

        if (this.handleValidation()) {
            axios.post(`http://13.59.236.175:8000/api/user/`, body, header)
            .then(res => {
      
              console.log(res);
              console.log(res.data);
  
            })

        } else {
            this.setState({ [this.state.hasError]: true });
        }
      }

      componentDidMount() {
        let myCookie = read_cookie('user')
        axios.get(`http://13.59.236.175:8000/api/user/${myCookie.user_id}/`)
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
                <div className="profile-container justify-content-center" id="header3">
                    <h3 className="text-center">Profile Page</h3>
                </div>
                <div className="profile-container">

                    <div className="col-lg-12 col-md-12 col-sm-12 no-padding-left ">
                        <div className="account-update">
                            <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">First Name</label>
                                  <div className="col">
                                    <input type="text" name="fname"className="form-control col" value = {this.state.fname}
                                    onChange={this.handleChange} required/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Last Name</label>
                                  <div className="col">
                                    <input type="text" name="lname"className="form-control col" value = {this.state.lname}
                                    onChange={this.handleChange} required/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">User Type</label>
                                  <div className="col">
                                    <input type="text" name="lname"className="form-control col" value = {this.state.utype}
                                    onChange={this.handleChange} disabled/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Password</label>
                                  <div className="col">
                                    <input type="password" name="currpw" className="form-control col" placeholder="Password" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["currpw"]}</div>
                                  </div>
                              </div>                    
                              <div className="form-group row">
                                  <label className="col-5 align-middle">New Password</label>
                                  <div className="col">
                                    <input type="password" name="newpw" className="form-control col" placeholder="New password" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["newpw"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">New Password(again)</label>
                                  <div className="col">
                                    <input type="password" name="confpw" className="form-control col" placeholder="New password(again)" 
                                    onChange={this.handleChange}/>
                                    <div className="error">{this.state.errors["confpw"]}</div>

                                  </div>
                              </div>
                              <div id="save-changes-div">
                                {this.state.isEnabled
                                ? 
                                <button id="save-changes" type="submit" className="btn btn-block">Confirm changes</button>
                                :
                                <button id="save-changes" type="submit" className="btn btn-block" disabled>Confirm changes</button>
                              }
                              </div>

                            </form>
                        </div>
                    </div>

                </div>
                  
            </div>
            

        );
    }
}