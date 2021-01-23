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
      costs: [0,0,0],
      isHiddenStates: [true, true, true, true, true]
    }
  }

  handleChange = event => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });
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

  setHiddenStates(showNumber) {
    let tempStates = this.state.isHiddenStates;
    for (let i = 0; i < tempStates.length; i++) {
      tempStates[i] = !(i == showNumber);
    }
    this.setState({ isHiddenStates: tempStates });
  }

  handleSubmit = event => {



  }

  handleValidation() {
    let formIsValid = true;
    let editedItem_ = this.state.editedItem;
    let new_errors = [];
    if (this.state.addressModalIsOpen) {
      if (editedItem_.address_name === ''){
        formIsValid = false;
        new_errors["address_name"] = "Name can not be empty.";
      }
      if (editedItem_.address === ''){
        formIsValid = false;
        new_errors["address"] = "Address can not be empty.";
      }
      let postal_code_int = parseInt(editedItem_.postal_code)
      console.log(postal_code_int)
      if (postal_code_int.toString().length != 5) {
        formIsValid = false;
        new_errors["postal_code"] = "Postal code should be 5 integers.";
      }
      if (editedItem_.country === ''){
        formIsValid = false;
        new_errors["country"] = "Country can not be empty.";
      }
      if (editedItem_.city === ''){
        formIsValid = false;
        new_errors["city"] = "City can not be empty.";
      }
      this.setState({errors: new_errors})
      return formIsValid;
    } else {
      if (editedItem_.card_name === ''){
        formIsValid = false;
        new_errors["card_name"] = "Name can not be empty.";
      }
      if (editedItem_.name_on_card === ''){
        formIsValid = false;
        new_errors["name_on_card"] = "Owner name can not be empty.";
      }
      let card_id_int = parseInt(editedItem_.card_id)
      if (card_id_int.toString().length != 16 || editedItem_.card_id.length != 16) {
        formIsValid = false;
        new_errors["card_id"] = "Card ID should be 16 integers.";
      }
      let cvv_int = parseInt(editedItem_.cvv)
      if (cvv_int.toString().length != 3 && editedItem_.cvv.length != 3) {
        formIsValid = false;
        new_errors["cvv"] = "CVV should be 3 integers.";
      }
      let month_int = parseInt(editedItem_.date_month)
      if (month_int.toString().length != 2 && month_int.toString().length != 1) {
        formIsValid = false;
        new_errors["expiry"] = "Month should be 1 or 2 integers.";
      }
      let year_int = parseInt(editedItem_.date_year)
      if (year_int.toString().length != 2) {
        formIsValid = false;
        new_errors["expiry"] = "Year should be 2 integers.";
      }
      this.setState({errors: new_errors})
      return formIsValid;
    }
  }

  handleModalDelete = event => {
    let myCookie = read_cookie('user');
    const header = {headers: {Authorization: "Token "+myCookie.token}};
    if (this.state.addressModalIsOpen) {
      axios.delete(serverUrl+'api/location/byuser/'+this.state.editedItem.id+'/', header)
      .then(res => {

        this.setHiddenStates(0);
        axios.get(serverUrl+`api/location/byuser/`, header)
        
        .then(res => {
    
          this.setState({ addresses: res.data })
        
        }).catch(error => {
          console.log("error: "+JSON.stringify(error))
          this.setHiddenStates(2)
        })


      }).catch(error => {
        console.log("error: "+JSON.stringify(error))
        this.setHiddenStates(2)
      })

    } else {
      const body = new FormData();
      body.append("owner", myCookie.user_id);
      body.append("id", this.state.editedItem.id);

      console.log(myCookie.user_id)
      console.log(parseInt(this.state.editedItem.id))
      console.log(header)

      axios.delete(serverUrl+'api/product/payment/', body, header)
      .then(res => {

        
        this.setHiddenStates(0);
        axios.get(serverUrl+`api/product/payment/`, header)
        
        .then(res => {
    
          this.setState({ addresses: res.data })
        
        }).catch(error => {
          console.log("error: "+JSON.stringify(error))
          this.setHiddenStates(2)
        })


      }).catch(error => {
        console.log("error: "+JSON.stringify(error))
        console.log(error)
        this.setHiddenStates(2)
      })
    }
  }

  handleModalSubmit = event => {  
    console.log("im at handlemodalsubmit")
    event.preventDefault();
      
    let myCookie = read_cookie('user');
    const header = {headers: {Authorization: "Token "+myCookie.token}};
    console.log(header)

    if (this.handleValidation()) {

      if (this.state.addressModalIsOpen) {

        let editedItem_ = this.state.editedItem;
        const body = new FormData();
        body.append("address_name", editedItem_.address_name);
        body.append("address", editedItem_.address);
        body.append("postal_code", editedItem_.postal_code);
        body.append("country", editedItem_.country);
        body.append("city", editedItem_.city);
        body.append("user", myCookie.user_id);

        if (this.state.adding) {

          axios.post(serverUrl+`api/location/byuser/`, body, header)
          .then(res => {
    
            this.setHiddenStates(0);
            axios.get(serverUrl+`api/location/byuser/`, header)
            .then(res => {

              this.setState({ addresses: res.data })
        
        
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
              this.setHiddenStates(2)
            })

  
          }).catch(error => {
            console.log("error: "+JSON.stringify(error))
            this.setHiddenStates(2)
          })
            
        } else {

          axios.put(serverUrl+'api/location/byuser/'+editedItem_.id+"/", body, header)
          .then(res => {
    
            this.setHiddenStates(0);
            axios.get(serverUrl+`api/location/byuser/`, header)
            .then(res => {

              this.setState({ addresses: res.data })
        
        
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
              this.setHiddenStates(2)
            })

  
          }).catch(error => {
            console.log("error: "+JSON.stringify(error))
            this.setHiddenStates(2)
          })

        }

      } else {

        let editedItem_ = this.state.editedItem;
        const body = new FormData();
        body.append("id", editedItem_.id);
        body.append("card_name", editedItem_.card_name);
        body.append("card_id", editedItem_.card_id);
        body.append("name_on_card", editedItem_.name_on_card);
        body.append("date_month", editedItem_.date_month);
        body.append("date_year", editedItem_.date_year);
        body.append("owner", myCookie.user_id);
        body.append("cvv", editedItem_.cvv);
        console.log(body)

        if (this.state.adding) {

            axios.post(serverUrl+'api/product/payment/', body, header)
            .then(res => {
      
              this.setHiddenStates(0);
              axios.get(serverUrl+`api/product/payment/`, header)

              .then(res => {

                this.setState({ creditCards: res.data })
          
          
              }).catch(error => {
                console.log("error: "+JSON.stringify(error))
                this.setHiddenStates(2)
              })

    
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
              this.setHiddenStates(2)
            })
            
        } else {

          axios.put(serverUrl+'api/product/payment/', body, header)
          .then(res => {
    
            this.setHiddenStates(0);
            axios.get(serverUrl+`api/product/payment/`, header)

            .then(res => {

              this.setState({ creditCards: res.data })
        
        
            }).catch(error => {
              console.log("error: "+JSON.stringify(error))
              this.setHiddenStates(2)
            })

  
          }).catch(error => {
            console.log("error: "+JSON.stringify(error))
            this.setHiddenStates(2)
          })

        }
      }



    } else {
      this.setHiddenStates(4)
    }

  }

  componentDidMount() {
    let myCookie = read_cookie('user')
    const header = {headers: {Authorization: "Token "+myCookie.token}};
    console.log(header)

    axios.get(serverUrl+`api/location/byuser/`, header)
    .then(res => {

      this.setState({ addresses: res.data })


    }).catch(error => {
      console.log("error: "+JSON.stringify(error))
      this.setState({isHiddenFail: false})
    })

    axios.get(serverUrl+`api/product/payment/`, header)
    .then(res => {

      console.log(res);
      console.log(res.data);
      this.setState({ creditCards: res.data })

      console.log(this.state.creditCards)
    }).catch(error => {
      console.log("error: "+JSON.stringify(error))
      this.setState({isHiddenFail: false})
    })

    axios.get(serverUrl + `api/user/cart/`, header)
    .then(res => {
      this.setState({ cart: res.data });
      console.log(this.state.cart)
      let totalCost = 0;
      console.log(res.data.length)


      for (let i=0;i<res.data.length;i++) {
        console.log(res.data[i])
        axios.get(serverUrl + 'api/product/'+res.data[i].product+'/')
        .then(res2 => {
          totalCost += parseInt(res2.data.price)*res.data[i].amount
          console.log(totalCost)
          let costs_ = this.state.costs
          costs_[0] = totalCost;
          this.setState({costs: costs_})
        })
      }
    })

  }

  handleCardClick = event => {

    if (event.target.id != "") {

      let id = event.target.id
      let indexOfDash = id.split("-", 2).join("-").length;
      let name_ = id.substring(indexOfDash + 1);
      var cardSelect = this.state.creditCards.filter(function (creditCard) {
        return creditCard.card_name == name_;
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
        return address.address_name == name_;
      });
      this.setState({ selectedAddress: addressToSelect[0] })
    }

  }

  editAddress = event => {
    let name_ = event.target.nextSibling?.id
    var addressToEdit = this.state.addresses.filter(function (address) {
      return address.address_name == name_;
    });
    let editedItem_ = this.state.editedItem
    if (addressToEdit[0] == undefined) {
      this.setState({adding: true})
    }
    editedItem_["id"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["id"] : ""
    editedItem_["address_name"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["address_name"] : ""
    editedItem_["address"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["address"] : ""
    editedItem_["postal_code"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["postal_code"] : ""
    editedItem_["country"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["country"] : ""
    editedItem_["city"] = (addressToEdit[0] != undefined) ? addressToEdit[0]["city"] : ""
    this.setState({editedItem: editedItem_})
    this.openAddressModal();
  }

  editCard = event => {
    let name_ = event.target.nextSibling?.id
    var cardToEdit = this.state.creditCards.filter(function (card) {
      return card.card_name == name_;
    });
    let editedItem_ = this.state.editedItem
    if (cardToEdit[0] == undefined) {
      this.setState({adding: true})
    } 
    editedItem_["id"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["id"] : ""
    editedItem_["card_name"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["card_name"] : ""
    editedItem_["name_on_card"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["name_on_card"] : ""
    editedItem_["card_id"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["card_id"] : ""
    editedItem_["date_month"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["date_month"] : ""
    editedItem_["date_year"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["date_year"] : ""
    editedItem_["expiry"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["expiry"] : ""
    editedItem_["cvv"] = (cardToEdit[0] != undefined) ? cardToEdit[0]["cvv"] : ""
    this.setState({editedItem: editedItem_})
    this.openCardModal();
  }

  openCardModal = () => {
    this.setState({cardModalIsOpen: true });
    this.setState({isHiddenDeleteSuccess: true})
  }

  closeModal = () => {
    if (this.state.cardModalIsOpen) {
      this.setState({cardModalIsOpen: false })
    } else {
      this.setState({addressModalIsOpen: false })
    }
    this.setState({adding: false})
    this.setHiddenStates(10)
  };

  openAddressModal = () => {
    this.setState({addressModalIsOpen: true });
    this.setState({isHiddenDeleteSuccess: true})
  }

  render() {
    
    let addressCards = this.state.addresses.map((address) => {
      return (
        <div className="address-card-wrapper float-left">
          <div onClick={this.handleAddressClick} className="form-check form-check-inline">
            <input className="form-check-input" type="radio" name="address-checkbox"
              id={"address-checkbox-" + address.address_name} value="option1" />
            <label className="form-check-label address-label" for={"address-checkbox-" + address.address_name}>
              {address.address_name} 
            </label>
          </div>
          <a onClick={this.editAddress} classname="edit-label">
            edit
          </a>
          <div id={address.address_name}>
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
              id={"creditcard-checkbox-" + creditCard.card_name} value="option1" />
            <label className="form-check-label" for={"creditcard-checkbox-" + creditCard.card_name}>
              {creditCard.card_name}
            </label>
          </div>
          <a onClick={this.editCard}>
            edit
          </a>
          <div id={creditCard.card_name}>
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
            <Modal.Title>{this.state.addressModalIsOpen ? this.state.editedItem?.address_name : this.state.editedItem?.card_name}</Modal.Title>
          </Modal.Header>
          <form className='needs-validation' onSubmit={this.handleModalSubmit} noValidate>

            <Modal.Body>
              <Alert variant="success" hidden={this.state.isHiddenStates[0]}>
                Successfull!
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenStates[2]}>
                Something went wrong.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenStates[3]}>
                Something went wrong.
              </Alert>
              <Alert variant="danger" hidden={this.state.isHiddenStates[4]}>
                Please fill out the form correctly.
              </Alert>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Name:</label>
                  <div className="col-6">
                    <input type="text" name="address_name" className="form-control col" value={this.state.editedItem?.address_name}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["address_name"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Full Address:</label>
                  <div className="col-6">
                    <textarea type="textarea" rows="3" name="address" className="form-control col" value={this.state.editedItem?.address}
                    onChange={this.handleChange} required id="full-address-field"/>
                    <div className="error">{this.state.errors["address"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.cardModalIsOpen}>
                  <label className="col-4 align-middle">Postal Code:</label>
                  <div className="col-6">
                    <input type="text" name="postal_code" className="form-control col" value={this.state.editedItem?.postal_code}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["postal_code"]}</div>
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
                  <label className="col-4 align-middle">Name:</label>
                  <div className="col-6">
                    <input type="text" name="card_name" className="form-control col" value={this.state.editedItem?.card_name}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["card_name"]}</div>
                  </div>
              </div>
              <div className="form-group row" hidden={this.state.addressModalIsOpen}>
                  <label className="col-4 align-middle">Owner:</label>
                  <div className="col-6">
                    <input type="text" name="name_on_card" className="form-control col" value={this.state.editedItem.name_on_card}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["name_on_card"]}</div>
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
                  <label className="col-4 align-middle">CVV:</label>
                  <div className="col-6">
                    <input type="text" name="cvv" className="form-control col" value={this.state.editedItem?.cvv}
                    onChange={this.handleChange} required/>
                    <div className="error">{this.state.errors["cvv"]}</div>
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
              <Button variant="danger" id="delete-address" onClick={this.handleModalDelete} 
                hidden={this.state.adding}>Delete</Button>
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
                  Card info:
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
                    Products Cost: {this.state.costs[0]} TL
                  </div>
                  <div>
                    Shipment Cost: {this.state.costs[1]} TL
                  </div>
                  <div>
                    Discount: {this.state.costs[2]} TL
                  </div>
                </div>
                <div className="payment-total">
                  Total Cost: {this.state.costs[0] + this.state.costs[1] - this.state.costs[2]} TL
                </div>
                <form>
                  <Button variant="primary" className="add-or-save" type="submit">Finalize Order</Button>

                </form>
              </div>
            </Container>
          </div>

        </div>
      </div>


    );
  }
}