import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import { serverUrl } from '../../../utils/get-url'
import { Modal, Button, Alert } from "react-bootstrap";
import CategoryBar from "../../../components/category-bar/category-bar";
import AddressCard from "./AddressCard/addresscard";
import CreditCardCard from "./CreditCardCard/creditcardcard";
import Card from 'react-bootstrap/Card'
import { CountryDropdown, RegionDropdown, CountryRegionData } from 'react-country-region-selector';


import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Container from "react-bootstrap/Container";
import "react-credit-cards/lib/styles.scss";

import "./checkout.scss";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus } from "@fortawesome/free-solid-svg-icons";

export default class Checkout extends Component {

  constructor() {
    super();
    this.state = {
      addresses: [],
      creditCards: [],
      errors: {},
      selectedAddress: '',
      selectedCard: '',
      editedItem: {},
      addressModalIsOpen: false,
      cardModalIsOpen: false,
      adding: false,
      isHiddenStates: [true, true, true, true]
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });
    console.log("this: "+event.target.name)
    console.log(event.target)
    let editedItem_ = this.state.editedItem
    editedItem_[event.target.name] = event.target.value
    this.setState({editedItem: editedItem_})

  }

  selectCountry(value) {
    let editedItem_ = this.state.editedItem
    editedItem_["country"] = value
    this.setState({editedItem: editedItem_})
  }

  selectCity(value) {
    let editedItem_ = this.state.editedItem
    editedItem_["city"] = value
    this.setState({editedItem: editedItem_})
  }

  handleInputFocus = event => {
    this.setState({ focus: event.target.name });
  }

  setHiddenStates(showNumber) {
    let tempStates = this.state.isHiddenStates;
    for (let i = 0; i < tempStates.length; i++) {
      tempStates[i] = !(i == showNumber);
    }
    this.setState({ isHiddenStates: tempStates });
  }

  handleSubmit = event => {



  }

  componentDidMount() {
    let myCookie = read_cookie('user')

    let myAddresses = [
      {
        "name": "home address",
        "full_address": "my full home addressmy full home addressmy full home addressmy full home addressmy full home address",
        "country": "Turkey",
        "city": "Kocaeli"
      },
      {
        "name": "work address",
        "full_address": "my full work address",
        "country": "Turkey",
        "city": "Istanbul"
      }
    ]

    let myCreditCards = [
      {
        "name": "my first card",
        "owner_name": "firat",
        "card_id": 1234567812345678,
        "date_month": "11",
        "date_year": "21",
        "expiry": "11/21",
        "cvc": "123"
      },
      {
        "name": "my second card",
        "owner_name": "firat2",
        "card_id": 8765432187654321,
        "date_month": "5",
        "date_year": "23",
        "expiry": "5/23",
        "cvc": "456"
      }
    ]

    this.setState({ addresses: myAddresses })
    this.setState({ creditCards: myCreditCards })

    axios.get(serverUrl + `api/user/${myCookie.user_id}/`)
      .then(res => {
        console.log("res data:  " + res.data.user_type)
        this.setState({ fname: res.data.first_name })
        this.setState({ lname: res.data.last_name })

        if (res.data.user_type === 1) {

          this.setState({ user_type: 1 });
        } else {
          this.setState({ user_type: 2 });
          this.setState({ company: res.data.company })
          this.setState({ isCustomer: false })

        }

      }).catch(err => {
        console.log("error:  " + err)
      })


  }

  addCreditCard = event => {
    alert("add credit card")
  }

  addAddress = event => {
    alert("add address")

  }

  handleCardClick = event => {

    if (event.target.id != "") {

      let id = event.target.id
      let indexOfDash = id.split("-", 2).join("-").length;
      let name_ = id.substring(indexOfDash + 1);
      var cardSelect = this.state.creditCards.filter(function (creditCard) {
        return creditCard.name == name_;
      });
      this.setState({ selectedCard: cardSelect[0] })
    }

  }

  handleAddressClick = event => {

    if (event.target.id != "") {

      let id = event.target.id
      let index = id.split("-", 2).join("-").length;
      let name_ = id.substring(index + 1);
      var addressToSelect = this.state.addresses.filter(function (address) {
        return address.name == name_;
      });
      this.setState({ selectedAddress: addressToSelect[0] })
    }

  }

  editAddress = event => {
    let name_ = event.target.nextSibling?.id
    var addressToEdit = this.state.addresses.filter(function (address) {
      return address.name == name_;
    });
    let editedItem_ = this.state.editedItem
    if (addressToEdit[0] == undefined) {
      this.setState({adding: true})
    } 
    editedItem_["name"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["name"] : ""
    editedItem_["full_address"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["full_address"] : ""
    editedItem_["country"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["country"] : ""
    editedItem_["city"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["city"] : ""
    this.setState({editedItem: editedItem_})
    this.openAddressModal();
  }

  editCard = event => {
    let name_ = event.target.nextSibling?.id
    var cardToEdit = this.state.creditCards.filter(function (card) {
      return card.name == name_;
    });
    let editedItem_ = this.state.editedItem
    if (cardToEdit[0] == undefined) {
      this.setState({adding: true})
    } 
    editedItem_["name"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["name"] : ""
    editedItem_["owner_name"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["owner_name"] : ""
    editedItem_["card_id"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["card_id"] : ""
    editedItem_["date_month"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["date_month"] : ""
    editedItem_["date_year"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["date_year"] : ""
    editedItem_["expiry"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["expiry"] : ""
    editedItem_["cvc"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["cvc"] : ""
    this.setState({editedItem: editedItem_})
    console.log(this.state.editedItem)
    this.openCardModal();
  }

  openCardModal = () => {
    this.setState({cardModalIsOpen: true });
    this.setState({isHiddenDeleteSuccess: true})
    console.log("open modal= "+ this.state.cardModalIsOpen)
  }

  closeModal = () => {
    if (this.state.cardModalIsOpen) {
      this.setState({cardModalIsOpen: false })
    } else {
      this.setState({addressModalIsOpen: false })
    }
    this.setState({adding: false})
    this.setState({isHiddenFail: true})
    this.setState({isHiddenSuccess: true})
    this.setState({isHiddenDeleteFail: true})
  };

  openAddressModal = () => {
    this.setState({addressModalIsOpen: true });
    this.setState({isHiddenDeleteSuccess: true})
    console.log("open modal= "+ this.state.addressModalIsOpen)
  }

  render() {
    let count = 0;

    let addressCards = this.state.addresses.map((address) => {
      console.log(count);
      count += 1;
      return (
        <div className="address-card-wrapper float-left">
          <div onClick={this.handleAddressClick} className="form-check form-check-inline">
            <input className="form-check-input" type="radio" name="address-checkbox"
              id={"address-checkbox-" + address.name} value="option1" />
            <label className="form-check-label" for={"address-checkbox-" + address.name}>
              {address.name} 
            </label>
          </div>
          <a onClick={this.editAddress}>
                edit
              </a>
          <div id={address.name}>
            <AddressCard address={address} selected={false} ></AddressCard>
          </div>
        </div>
      );
    });

    addressCards.push(
      <div className="address-card-wrapper float-left" onClick={this.editAddress}>
        <div>
          Add new address
        </div>
        <Card className="add-new-address">
          <FontAwesomeIcon icon={faPlus} className="fa-5x plus-sign" />
        </Card>

      </div>

    )

    let creditCards = this.state.creditCards.map((creditCard) => {
      return (
        <div className="credit-card-wrapper float-left">
          <div onClick={this.handleCardClick} className="form-check form-check-inline">
            <input className="form-check-input" type="radio" name="creditcard-checkbox"
              id={"creditcard-checkbox-" + creditCard.name} value="option1" />
            <label className="form-check-label" for={"creditcard-checkbox-" + creditCard.name}>
              {creditCard.name}
            </label>
          </div>
          <a onClick={this.editCard}>
            edit
          </a>
          <div id={creditCard.name}>
            <CreditCardCard creditCard={creditCard} selected={false}></CreditCardCard>
          </div>
        </div>
      );
    });

    creditCards.push(
      <div className="credit-card-wrapper float-left" onClick={this.editCard}>
        <div>
          Add new credit card
        </div>
        <Card className="add-new-credit-card">
          <FontAwesomeIcon icon={faPlus} className="fa-5x plus-sign" />

        </Card>

      </div>

    )


    return (
      <div className='background'>
        <CategoryBar></CategoryBar>
        
        <Modal show={this.state.addressModalIsOpen || this.state.cardModalIsOpen} onHide={this.closeModal}>
          <Modal.Header closeButton>
            <Modal.Title>{this.state.editedItem?.name}</Modal.Title>
          </Modal.Header>
          <form className='needs-validation' onSubmit={this.handleSubmit} noValidate>

            <Modal.Body>
              <Alert variant="success" hidden={this.state.isHiddenStates[0]}>
                Address details updated.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenStates[2]}>
                Something went wrong.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenStates[3]}>
                Something went wrong.
              </Alert>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Name:</label>
                  <div className="col-6">
                    <input type="text" name="name" className="form-control col" value={this.state.editedItem?.name}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["name"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Full Address:</label>
                  <div className="col-6">
                    <textarea type="textarea" rows="3" name="full_address" className="form-control col" value={this.state.editedItem?.full_address}
                    onChange={this.handleChange} required id="full-address-field"/>
                    <div className="error">{this.state.errors["full_address"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Country:</label>
                  <div className="col-6">
                    <CountryDropdown className="country-dropdown"
                      value={this.state.editedItem?.country}
                      onChange={(val) => this.selectCountry(val)} />
                    <div className="error">{this.state.errors["country"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">City:</label>
                  <div className="col-6">
                    <RegionDropdown className="city-dropdown"
                      country={this.state.editedItem?.country}
                      value={this.state.editedItem?.city}
                      onChange={(val) => this.selectCity(val)} />
                    <div className="error">{this.state.errors["city"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.addressModalIsOpen}>
                  <label className="col-4 align-middle">Owner:</label>
                  <div className="col-6">
                    <input type="text" name="owner_name" className="form-control col" value={this.state.editedItem.owner_name}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["owner_name"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.addressModalIsOpen}>
                  <label className="col-4 align-middle">Card ID:</label>
                  <div className="col-6">
                    <input type="text" name="card_id" className="form-control col" value={this.state.editedItem?.card_id}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["card_id"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.addressModalIsOpen}>
                  <label className="col-4 align-middle">Expiry:</label>
                  <div className="col-6 form-control-inline">
                    <input type="text" name="date_month" className="form-control col date-field" value={this.state.editedItem?.date_month}
                    onChange={this.handleChange} required/>
                    <span className="date-slash">
                      /
                    </span>
                    <input type="text" name="date_year" className="form-control col date-field" value={this.state.editedItem?.date_year}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["expiry"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.addressModalIsOpen}>
                  <label className="col-4 align-middle">CVC:</label>
                  <div className="col-6">
                    <input type="text" name="cvc" className="form-control col" value={this.state.editedItem?.cvc}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["cvc"]}</div>
                  </div>
              </div>

            </Modal.Body>

            <Modal.Footer>
              <Button variant="primary" className="add-or-save" type="submit" 
                hidden={this.state.cardModalIsOpen || !this.state.adding}>Add</Button>
              <Button variant="primary" className="add-or-save" type="submit" 
                hidden={this.state.addressModalIsOpen || !this.state.adding}>Add</Button>
              <Button variant="primary" className="add-or-save" type="submit"
                hidden={this.state.adding || this.state.cardModalIsOpen}>Save Changes</Button>
              <Button variant="primary" className="add-or-save" type="submit" 
                hidden={this.state.adding || this.state.addressModalIsOpen}>Save Changes</Button>
              <Button variant="danger" id="delete-address" type="submit" onClick={this.deleteAddress} 
                hidden={this.state.adding || this.state.cardModalIsOpen}>Delete</Button>
              <Button variant="danger" id="delete-card" type="submit" onClick={this.deleteCard} 
                hidden={this.state.adding || this.state.addressModalIsOpen}>Delete</Button>
              <Button variant="secondary" onClick={this.closeModal}>Close</Button>
            </Modal.Footer>
          </form>

        </Modal>
        <div className="row">
          <div className="checkout-container col-lg-8 col-md-8 col-sm-8 no-padding-left border-right ">
            <div className="justify-content-center" id="header3">
              <h2 className="text-center">Checkout</h2>
            </div>
            <div className="order-selection row border-bottom">

              <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left border-right row row-margin-correction">
                <div className="text-center col-lg-6 col-md-6 col-sm-6">
                  Address info:
                </div>
                <AddressCard address={this.state.selectedAddress} selected={true}></AddressCard>
              </div>
              <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left row row-margin-correction">
                <div className="text-center col-lg-6 col-md-6 col-sm-6">
                  Address info:
                </div>
                <CreditCardCard creditCard={this.state.selectedCard} selected={true}></CreditCardCard>
              </div>
            </div>
            <div className="order-form row">

              <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left border-right border-left">
                <Container fluid className="address-cards-block">
                  {addressCards}
                </Container>

              </div>
              <div className="col-lg-6 col-md-6 col-sm-6 no-padding-left ">
                <Container fluid className="credit-cards-block">
                  {creditCards}
                </Container>
              </div>
            </div>

          </div>


          <div classname="order-summary col-lg-4 col-md-4 col-sm-4 border-right ">
            <Container fluid className="summary-block">
              <h3 className="text-center header2">Order Summary</h3>
              <div className="summary-card">
                <div className="payment-info border-bottom">
                  <div>
                    Products Cost:
                  </div>
                  <div>
                    Shipment Cost:
                  </div>
                  <div>
                    Discount:
                  </div>
                </div>
                <div className="payment-total">
                  Total Cost:
                </div>
              </div>
            </Container>
          </div>

        </div>
      </div>


    );
  }
}