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
          oldpw: '',
          newpw: '',
          confpw: '',
          fname: '',
          lname: '',
          redirect: null,
          isVendor: false,
          hasError: false,
          isEnabled: false
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        this.setState({ [event.target.name]: event.target.value });
        console.log("value  :  "+event.target.value)

        if(this.state.newpw === this.state.confpw) {
          this.setState({isEnabled: true});
        } else {
          this.setState({isEnabled: false});
        }
        
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
        let myCookie = read_cookie('user')
        axios.get(`http://13.59.236.175:8000/api/user/${myCookie.user_id}/`)
          .then(res => {
              this.setState({fname : res.data.first_name})
              this.setState({lname : res.data.last_name})
              if (res.data.user_type === "1"){
                this.setState({isVendor: false});
              } else {
                this.setState({isVendor: true});
              }

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
                                <input type="text" name="fname"className="form-control col" value = {this.state.fname}
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Last Name</label>
                                <input type="text" name="lname"className="form-control col" value = {this.state.lname}
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">User Type</label>
                                <input type="text" name="lname"className="form-control col" value = {this.state}
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">Password</label>
                                <input type="password" name="oldpw" className="form-control col" placeholder="Password" 
                                onChange={this.handleChange}/>
                            </div>                    
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">New Password</label>
                                <input type="password" name="newpw" className="form-control col" placeholder="New password" 
                                onChange={this.handleChange}/>
                            </div>
                            <div className="form-group row">
                                <label className="col-lg-5 align-middle">New Password(again)</label>
                                <input type="password" name="confpw" className="form-control col" placeholder="New password(again)" 
                                onChange={this.handleChange}/>
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