import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import { Redirect } from "react-router-dom";import Datatable from 'react-bs-datatable';


export default class Inventory extends Component {
  



  componentDidMount() {

    let myCookie = read_cookie('user')


  }


  render(){
    return ;
  }
}