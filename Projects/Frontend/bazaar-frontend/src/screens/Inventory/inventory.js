import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import DataTable from 'react-data-table-component';
import { Modal, Button } from "react-bootstrap";

import "./inventory.scss";

export default class Inventory extends Component {

  constructor() {
    super();
    this.state = {
      products: [],
      name: '',
      brand: '',
      price: '',
      stock: '',
      detail: '',
      category: '',
      subcategory: '',
      errors: [],
      isOpen: false
    }
    this.handleImageChange = this.handleImageChange.bind(this)

  }

  componentDidMount() {
    let myCookie = read_cookie('user')
    axios.get(`http://13.59.236.175:8000/api/product/`)
      .then(res => {
        let myProducts = res.data.filter(product => product.vendor === myCookie.user_id)
        this.setState({ products: myProducts })
      })


  }
  handleChange = (event) => {
    // You can use setState or dispatch with something like Redux so we can use the retrieved data
    this.setState({ [event.target.name]: event.target.value });
    console.log(this.state.category)
  };

  handleImageChange = event => {

    event.preventDefault();
    this.setState({ image:   URL.createObjectURL(event.target.files[0])
    })

  }

  rowClicked = (event) => {
    console.log(event)
    this.setState({name: event.name})
    this.setState({brand: event.brand})
    this.setState({price: event.price})
    this.setState({stock: event.stock})
    this.setState({detail: event.detail})
    this.setState({category: event.category["parent"]})
    this.setState({subcategory: event.category["name"]})
    this.setState({image: event.picture})
    this.openModal()
    console.log("category: "+event.category["parent"])
    console.log("subcategory: "+event.category["name"])
  }

  openModal = () => this.setState({ isOpen: true });
  closeModal = () => this.setState({ isOpen: false });

  upload = () => {
    document.getElementById("select-image").click();
  }

  render() {

    const columns = [
      {
        name: "Name",
        selector: "name",
        sortable: true
      },
      {
        name: "Brand",
        selector: "brand",
        sortable: true
      },
      {
        name: "Price",
        selector: "price",
        sortable: true,
        right: true
      },
      {
        name: "Stock",
        selector: "stock",
        sortable: true,
        right: true
      }
    ];

    let categoryList = {"Home": ["Home Textile", "Bedroom", "Bathroom", "Kitchen", "Lighting", "Furniture", "Home/Other"],
                        "Electronics": ["Tablets", "Smartphones", "Computers", "TV", "Gaming", "Home Appliances", "Electronics/Other"], 
                        "Clothing": ["Top", "Bottom", "Outerwear", "Shoes", "Bags", "Accessories", "Activewear", "Clothing/Other"], 
                        "Living": ["Art Supplies", "Musical Devices", "Sports", "Living/Other", "Living/Other"], 
                        "Selfcare": ["Perfumes", "Makeup", "Skincare", "Hair", "Body Care", "Selfcare/Other"],
                        "Books": ["Books/Other"],
                        "Categories": ["Home", "Electronics", "Clothing", "Living", "Selfcare", "Books"],
                        '': []
    }

    let categories = Object.keys(categoryList).map(category => {
      if (category !== ""){
        return (
          <option value={category}>{category}</option>
        )
      }
    })

    let subcategories = categoryList[this.state.category].map(subcategory => {
      return (
        <option value={subcategory}>{subcategory}</option>
      )
    })

    return (
      <div className="profile-form">

        <Modal show={this.state.isOpen} onHide={this.closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>Product Details</Modal.Title>
          </Modal.Header>
          <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>

            <Modal.Body>
              

              <div className="col">
                <div id="image-container">
                  <img id="product-image" src={this.state.image} onClick={this.upload}/>
                  <input id="select-image" type="file" name="image" className="" accept="image/jpeg image/png"
                  onChange={this.handleImageChange}hidden/>
                </div>
                <div className="error">{this.state.errors["image"]}</div>

              </div>

              <div className="form-group row">
                  <label className="col-4 align-middle">Name:</label>
                  <div className="col-6">
                    <input type="text" name="name"className="form-control col" value={this.state.name}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["name"]}</div>
                  </div>
              </div>
              <div className="form-group row">
                  <label className="col-4 align-middle">Detail:</label>
                  <div className="col-6">
                    <input type="text" name="detail" className="form-control col" value={this.state.detail}
                    onChange={this.handleChange}/>
                  </div>
              </div>
              <div className="form-group row">
                  <label className="col-4 align-middle">Brand:</label>
                  <div className="col-4">
                    <input type="text" name="brand" className="form-control col" value={this.state.brand}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["brand"]}</div>

                  </div>
              </div>
              <div className="form-group row">
                  <label className="col-4 align-middle">Category:</label>
                  <div className="col-4">
                    <select className="form-control col" name="category" id="category1" defaultValue={this.state.category}
                    onChange={this.handleChange} required>
                      <option disabled>Please Select</option>
                      {categories}
                    </select>
                    <div className="error">{this.state.errors["category"]}</div>
                  </div>
              </div>
              <div className="form-group row">
                  <label className="col-4 align-middle">Subcategory:</label>
                  <div className="col-4">
                    <select className="form-control col" name="subcategory" id="category2" defaultValue={this.state.subcategory}
                    onChange={this.handleChange}>
                      <option disabled>Please Select</option>
                      {subcategories}
                    </select>
                    <div className="error">{this.state.errors["subcategory"]}</div>
                  </div>
              </div>
              <div className="form-group row">
                  <label className="col-4 align-middle">Price:</label>
                  <div className="col-3">
                    <input type="text" name="price" className="form-control col" value={this.state.price}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["price"]}</div>
                  </div>
              </div>                    
              <div className="form-group row">
                  <label className="col-4 align-middle">Stock:</label>
                  <div className="col-3">
                    <input type="text" name="stock" className="form-control col" value={this.state.stock} 
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["stock"]}</div>
                  </div>
              </div>


            </Modal.Body>

            <Modal.Footer>
                <Button variant="primary" id="save-changes-product" type="submit">Save Changes</Button>
                <Button variant="secondary" onClick={this.closeModal}>Close</Button>
            </Modal.Footer>
          </form>

        </Modal>

        {this.state.isModalActive &&
          (
            <div >
              <Button variant="primary" onClick={this.openModal}>
                Launch demo modal
               </Button>
            </div>
          )
        }



        <DataTable
          title="My Inventory"
          columns={columns}
          data={this.state.products}
          defaultSortField="title"
          pagination
          selectableRows
          onRowClicked={this.rowClicked}
          highlightOnHover
          pointerOnHover
        />
      </div>

    );
  }
}