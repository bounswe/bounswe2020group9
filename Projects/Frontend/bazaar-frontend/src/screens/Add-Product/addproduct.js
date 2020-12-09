import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';

import "./addproduct.scss";
import { faGlassWhiskey } from "@fortawesome/free-solid-svg-icons";

export default class AddProduct extends Component {

    constructor() {
        super();
        this.state = {
          name: '',
          detail: '',
          brand: '',
          price: '',
          stock: '',
          image: null,
          utype: '',
          token: '',
          redirect: null,
          hasError: false,
          errors: {}
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });        
      }

      handleImageChange = event => {

        event.preventDefault();
        this.setState({ image: event.target.files[0] })

      }

      handleValidation(){
        let formIsValid = true;
        let new_errors = {newpw: '', confpw: '', currpw: ''};
        //Name
        if (this.state.name === ''){
            formIsValid = false;
            new_errors["name"] = "Name can not be empty.";
        }
        if (this.state.brand === ''){
            formIsValid = false;
            new_errors["brand"] = "Brand can not be empty.";
        }
        if (this.state.price === ''){
            formIsValid = false;
            new_errors["price"] = "Price can not be empty.";
        }
        if (this.state.stock === ''){
            formIsValid = false;
            new_errors["stock"] = "Stock can not be empty.";
        }



        this.setState({errors: new_errors});
        return formIsValid;
      }

    
      handleSubmit = event => {  

    
        event.preventDefault();
        const body = new FormData();
        body.append("name", this.state.name);
        body.append("detail", this.state.detail);
        body.append("brand", this.state.brand);
        body.append("price", this.state.price);
        body.append("stock", this.state.stock);
        body.append("image", this.state.image);


        let myCookie = read_cookie('user');
        const header = {Authorization: "Token "+myCookie.token};
        

        if (this.handleValidation()) {
            axios.post(`http://13.59.236.175:8000/api/product/`, body, header)
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


      }


    render() {
      if (this.state.hasError) {
        // You can render any custom fallback UI
        return <h1>{this.validate.message}</h1>;
      }
        return (
            <div className="profile-form">
                <div className="profile-container justify-content-center" id="header3">
                    <h3 className="text-center">Add Product</h3>
                </div>
                <div className="profile-container">

                    <div className="col-lg-12 col-md-12 col-sm-12 no-padding-left ">
                        <div className="account-update">
                            <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Name</label>
                                  <div className="col">
                                    <input type="text" name="name"className="form-control col" placeholder="e.g. 'Samsung Galaxy S, White'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["name"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Detail</label>
                                  <div className="col">
                                    <input type="text" name="detail"className="form-control col" placeholder="e.g. 'best phone, much cheap.'"
                                    onChange={this.handleChange}/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle deneme">Brand</label>
                                  <div className="col">
                                    <input type="text" name="brand"className="form-control col" placeholder="e.g. 'Samsung'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["brand"]}</div>

                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Price</label>
                                  <div className="col">
                                    <input type="text" name="price" className="form-control col" placeholder="e.g. '1000 {₺}'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["price"]}</div>
                                  </div>
                              </div>                    
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Stock</label>
                                  <div className="col">
                                    <input type="text" name="stock" className="form-control col" placeholder="e.g. '200'" 
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["stock"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-5 align-middle">Image</label>
                                  <div className="col">
                                    <input type="file" name="image" className="form-control col" accept="image/jpeg image/png" 
                                    onChange={this.handleImageChange}/>
                                    <div className="error">{this.state.errors["confpw"]}</div>

                                  </div>
                              </div>
                              <div id="save-changes-div">
                                <button id="save-changes" type="submit" className="btn btn-block">Add Product</button>
                              </div>

                            </form>
                        </div>
                    </div>

                </div>
                  
            </div>
            

        );
    }
}