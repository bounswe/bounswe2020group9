import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';


import "./profilepage.css";

export default class ProfilePageComponent extends Component {

    constructor() {
        super();
        this.state = {
          username: '',
          oldpw: '',
          newpw: '',
          confpw: '',
          fname: '',
          lname: '',
          redirect: null
        }
      }
    
      handleChange = event => {
    
        this.setState({ [event.target.name]: event.target.value });
    
      }

    
      handleSubmit = event => {
    
        event.preventDefault();
        const data = new FormData();
        data.append("first_name", this.state.fname);
        data.append("last_name", this.state.lname);

        if (this.state.newpw == this.state.confpw) {
            
            // cookieden passworde bak, this.state.oldpw'yle eşitse put request at. 
            // Eşit değilse password yanlış error'ü ver.

        } else {
            // newpw ile confpw eşit değil errorü ver.
        }
    
        axios.put(`http://13.59.236.175:8000/api/user/`, data)
          .then(res => {
    
            console.log(res);
            console.log(res.data);

          })
        
      }

    render() {
        return (
            <div className="profile-form">
                <div className="profile-container justify-content-center" id="header3">
                    <h3 className="text-center">Profile Page</h3>
                </div>
                <div className="profile-container">

                    <div className="col-lg-12 col-md-12 col-sm-12 no-padding-left ">
                        <div className="account-update">
                            <form onSubmit={this.handleSubmit}>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">First Name</label>
                                <input type="text" name="fname"className="form-control col" placeholder="{name}" 
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Last Name</label>
                                <input type="text" name="lname"className="form-control col" placeholder="{surname}" 
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Gender</label>
                                <div class="form-check form-check-inline">
                                <input class="form-check-input align-middle" type="radio" name="isMale" id="maleBox" value="option1"/>
                                <label class="form-check-label" for="isMale">Male</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input align-middle" type="radio" name="isFemaile" id="femaleBox" value="option2"/>
                                <label class="form-check-label" for="isFemale">Female</label>
                                </div>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Account</label>
                                <div class="form-check form-check-inline">
                                <input class="form-check-input align-middle" type="radio" name="isVendor" id="vendorBox" value="option1"/>
                                <label class="form-check-label" for="isVendor">Vendor</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input align-middle" type="radio" name="isCustomer" id="customerBox" value="option2"/>
                                <label class="form-check-label" for="isCustomer">Customer</label>
                                </div>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Password</label>
                                <input type="text" name="oldpw" className="form-control col" placeholder="Password" 
                                onChange={this.handleChange}/>
                            </div>                    
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">New Password</label>
                                <input type="text" name="newpw" className="form-control col" placeholder="New password" 
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">New Password(again)</label>
                                <input type="text" name="confpw" className="form-control col" placeholder="New password(again)" 
                                onChange={this.handleChange}/>
                            </div>
                            <button id="save-changes" type="submit" className="btn btn-block">Confirm changes</button>

                            </form>
                        </div>
                    </div>

                </div>
  
            </div>

        );
    }
}