import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';


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
          redirect: null,
          isVendor: false,
          hasError: false
        //   user_id: Cookies.get("user_id")
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
        data.append("password", this.state.newpw)

        if (this.state.newpw == this.state.confpw) {
            
            axios.put(`http://13.59.236.175:8000/api/user/`, data)
            .then(res => {
      
              console.log(res);
              console.log(res.data);
  
            })

        } else {
            this.setState({ [this.state.hasError]: true });
        }
    
        axios.put(`http://13.59.236.175:8000/api/user/`, data)
          .then(res => {
    
            console.log(res);
            console.log(res.data);

          })
      }

      componentDidMount() {
        // let cookie_key = "user_id" 
        // let myUserId = read_cookie(cookie_key)
        // console.log(myUserId, 'MYUSEID')
        // console.log(Cookies.get('user_id'), 'USERRRRRIDDDD')
        axios.get(`http://13.59.236.175:8000/api/user/8/`)
          .then(res => {
              console.log(res.data)
              this.setState({fname : ""})
              console.log(this.state.fname, 'FNAME')
              this.setState({lname : ""})

          })

      }


    render() {
      const isVendor = this.state.isVendor
      if (this.state.hasError) {
        // You can render any custom fallback UI
        return <h1>Something went wrong.</h1>;
      }
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
                                <input type="text" name="fname"className="form-control col" placeholder = "enter first name"
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Last Name</label>
                                <input type="text" name="lname"className="form-control col" placeholder = "enter last name"
                                onChange={this.handleChange}/>
                            </div>

                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Account</label>
                                {isVendor ? (
                            <button id="isvendor" type="button" class="btn btn-info">VENDOR</button>
                            ) : (
                              <button id="isvendor" type="button" class="btn btn-info">CUSTOMER</button>
                            )}
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
                            <div id="save-changes-div">
                                <button id="save-changes" type="submit" className="btn btn-block">Confirm changes</button>

                            </div>

                            </form>
                        </div>
                    </div>

                </div>
  
            </div>

        );
    }
}