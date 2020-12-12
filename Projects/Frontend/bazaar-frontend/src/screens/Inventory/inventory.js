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
      isOpen: false
    }
  }

  componentDidMount() {
    let myCookie = read_cookie('user')
    axios.get(`http://13.59.236.175:8000/api/product/`)
      .then(res => {
        let myProducts = res.data.filter(product => product.vendor === myCookie.user_id)
        this.setState({ products: myProducts })
      })


  }

  handleChange = (state) => {
    // You can use setState or dispatch with something like Redux so we can use the retrieved data
    console.log('Selected Rows: ', state.selectedRows);
  };

  rowClicked = () => {
    this.openModal()
  }

  openModal = () => this.setState({ isOpen: true });
  closeModal = () => this.setState({ isOpen: false });

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

    return (
      <div className="profile-form">

        <Modal show={this.state.isOpen} onHide={this.closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>Modal heading</Modal.Title>
          </Modal.Header>
          <Modal.Body>Woohoo, you're reading this text in a modal!</Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={this.closeModal}>
              Close
          </Button>
          </Modal.Footer>
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