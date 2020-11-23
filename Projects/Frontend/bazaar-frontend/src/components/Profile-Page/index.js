import React, { Component } from "react";

import "./profilepage.css";

export default class ProfilePageComponent extends Component {
    render() {
        return (
            <div className="profile-form">
                <div className="profile-container justify-content-center" id="header3">
                <h3 className="text-center">Profile Page</h3>

                </div>
                <div className="profile-container row">

                    <div className="col border-right">
                        <div className="col-lg-12 col-md-12 col-sm-12 no-padding-left ">
                            <div className="account-update">
                                <form>
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">First Name</label>
                                    <input type="name" className="form-control col" placeholder="{name}" />
                                </div>
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">Surname</label>
                                    <input type="surname" className="form-control col" placeholder="{surname}" />
                                </div>

                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">Cell Number</label>
                                    <input type="cellno" className="form-control col" placeholder="{cellno}" />
                                </div>
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">Gender</label>
                                    <div class="form-check form-check-inline">
                                    <input class="form-check-input align-middle" type="radio" name="genderSelection" id="Male" value="option1"/>
                                    <label class="form-check-label" for="Male">Male</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input align-middle" type="radio" name="genderSelection" id="Female" value="option2"/>
                                    <label class="form-check-label" for="Female">Female</label>
                                    </div>
                                </div>
                                <button id="save-changes" type="submit" className="btn btn-block">Confirm changes</button>

                                </form>
                            </div>
                        </div>
                    </div>
                    <div className="col">
                        <div className="col-lg-12 col-md-12 col-sm-12">
                            <div className="password-update">
                                <form>
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">Password</label>
                                    <input type="old_password" className="form-control col" placeholder="Password" />
                                </div>                    
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">New Password</label>
                                    <input type="new_password" className="form-control col" placeholder="New password" />
                                </div>
                                <div className="form-group row">
                                    <label className="col-lg-5 align-middle">New Password(again)</label>
                                    <input type="confirm_new_password" className="form-control col" placeholder="New password(again)" />
                                </div>
                                <button id="save-changes" type="submit" className="btn btn-block">Confirm changes</button>

                                </form>
                            </div>
                        </div>

                    </div>

                </div>
  
            </div>

        );
    }
}