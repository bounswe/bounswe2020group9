import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import { Modal, Button } from "react-bootstrap";
import {serverUrl} from '../../utils/get-url'


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
          category: '',
          subcategory: '',
          labels: [],
          utype: '',
          token: '',
          redirect: null,
          hasError: false,
          errors: {},
          categoryStructure: {"":[]},
          categoryList: {},
          subHidden: true
        //   user_id: Cookies.get("user_id")
        }
      }
    
      handleChange = event => {
    
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });    
        if (event.target.name == "category"){
          this.setState({subHidden: false})
        }   
      }

      handleImageChange = event => {

        event.preventDefault();
        this.setState({ image: event.target.files[0] })

      }

      handleValidation(){
        let formIsValid = true;
        let new_errors = {};
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
        if (this.state.category === ''){
          formIsValid = false;
          new_errors["category"] = "Category can not be empty.";
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
        body.append("picture", this.state.image);
        if (this.state.subcategory !== ""){
          body.append("category", "44")
        } else {
          body.append("category", "44")
        }
        console.log(body)

        let myCookie = read_cookie('user');
        const header = {Authorization: "Token "+myCookie.token};
        console.log(header)

        console.log(header["Authorization"])
        if (this.handleValidation()) {
            axios.post(serverUrl+`api/product/`, body, header)
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
        axios.get(serverUrl+'api/product/categories/')
        .then(res => {
          let resp = res.data;
          let categoryStructureTemp = {};
          let categoryListTemp = {}
          let keys = [];
          for (let i=0;i<resp.length;i++) {
            if (resp[i]["parent"] == "Categories") {
              keys.push(resp[i]["name"])
            }
            categoryListTemp[resp[i]["name"]] = resp[i]["id"]
          }
          for (let i=0;i<keys.length;i++) {
            let sublist = []
            for (let j=0;j<resp.length;j++) {
              if (resp[j]["parent"] == keys[i]) {
                sublist.push(resp[j]["name"]);
              }
            }
            categoryStructureTemp[keys[i]] = sublist;
          }
          categoryStructureTemp[''] = []
          this.setState({categoryList: categoryListTemp})
          this.setState({categoryStructure: categoryStructureTemp})
        })

      }


    render() {
      let categoryStructure = this.state.categoryStructure

      let categories = Object.keys(categoryStructure).map(category => {
        if (category !== ""){
          return (
            <option value={category}>{category}</option>
          )
        }
      })

      let subcategories = categoryStructure[this.state.category].map(subcategory => {
        return (
          <option value={subcategory}>{subcategory}</option>
        )
      })

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
                                  <label className="col-4 align-middle">Name:</label>
                                  <div className="col-6">
                                    <input type="text" name="name"className="form-control col" placeholder="e.g. 'Samsung Galaxy S, White'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["name"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Detail:</label>
                                  <div className="col-6">
                                    <input type="text" name="detail" className="form-control col" placeholder="e.g. 'best phone, much cheap.'"
                                    onChange={this.handleChange}/>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Brand:</label>
                                  <div className="col-4">
                                    <input type="text" name="brand" className="form-control col" placeholder="e.g. 'Samsung'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["brand"]}</div>

                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Category:</label>
                                  <div className="col-4">
                                    <select className="form-control col" name="category" id="category1"
                                    onChange={this.handleChange} required>
                                      <option selected disabled>Please Select</option>
                                      {categories}
                                    </select>
                                    <div className="error">{this.state.errors["category"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row" hidden={this.state.subHidden}>
                                  <label className="col-4 align-middle">Subcategory:</label>
                                  <div className="col-4">
                                    <select className="form-control col" name="subcategory" id="category2"
                                    onChange={this.handleChange}>
                                      <option selected disabled>Please Select</option>
                                      {subcategories}
                                    </select>
                                    <div className="error">{this.state.errors["subcategory"]}</div>
                                  </div>
                              </div>
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Price:</label>
                                  <div className="col-3">
                                    <input type="text" name="price" className="form-control col" placeholder="e.g. '1000 {₺}'"
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["price"]}</div>
                                  </div>
                              </div>                    
                              <div className="form-group row">
                                  <label className="col-4 align-middle">Stock:</label>
                                  <div className="col-3">
                                    <input type="text" name="stock" className="form-control col" placeholder="e.g. '200'" 
                                    onChange={this.handleChange} required/>
                                    <div className="error">{this.state.errors["stock"]}</div>
                                  </div>
                              </div>

                              <div className="form-group row">
                                  <label className="col-4 align-middle">Image:</label>
                                  <div className="col">
                                    <input type="file" name="image" className="" accept="image/jpeg image/png" 
                                    onChange={this.handleImageChange}/>
                                    <div className="error">{this.state.errors["image"]}</div>

                                  </div>
                              </div>
                              <div id="add-product-div">
                                <Button variant="primary" id="add-product" type="submit">Add product</Button>
                              </div>

                            </form>
                        </div>
                    </div>

                </div>
                  
            </div>
            

        );
    }
}