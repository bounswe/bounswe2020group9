import React, { Component } from "react";
import axios from 'axios'
import { bake_cookie, read_cookie, delete_cookie } from 'sfcookies';
import Cookies from 'js-cookie';
import { serverUrl } from '../../utils/get-url'
import { Button, Alert } from "react-bootstrap";
import CategoryBar from "../../components/category-bar/category-bar";
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Form from 'react-bootstrap/Form'

import ListGroup from 'react-bootstrap/ListGroup'


export default class MyAddresses extends Component {

  constructor(props) {
    super(props);
    this.state = {
      id: '',
      address_name: '',
      address: '',
      country: '',
      city: '',
      postal_code: '',
      user_type: '',
      selectedAddress: {},
      adresses: [],
      adding: false,

    };
  }



  handleSubmit = event => {
    event.preventDefault();
    const body = new FormData();
    console.log("user_type: " + this.state.user_type)

    let myCookie = read_cookie('user');
    const header = {
      headers: {
        Authorization: "Token " + myCookie.token
      }
    };

    body.append("address", this.state.selectedAddress.address);
    body.append("address_name", this.state.selectedAddress.address_name);
    body.append("city", this.state.selectedAddress.city);
    body.append("country", this.state.selectedAddress.country);
    body.append("postal_code", this.state.selectedAddress.postal_code);
    body.append("user", myCookie.user_id);

    if (this.state.adding) {
      axios.post(serverUrl + 'api/location/byuser/', body, header)
        .then(res => {

          console.log(res);
          console.log(res.data);

          axios.get(serverUrl + `api/location/byuser/`, header)
            .then(res => {
              console.log(res);
              console.log(res.data);

              this.setState({ addresses: res.data });


            }).catch(err => {
              console.log("error:  " + err)
            })


        }).catch(err => {
          console.log("error:  " + err)
        })
    }
    else {
      axios.put(serverUrl + 'api/location/byuser/' + this.state.selectedAddress.id + '/', body, header)
        .then(res => {

          console.log(res);
          console.log(res.data);


        }).catch(err => {
          console.log("error:  " + err)
        })


    }
  }

  deleteAddress = event => {
    
    event.preventDefault();


    let myCookie = read_cookie('user');
    const header = {
      headers: {
        Authorization: "Token " + myCookie.token
      }
    };

    let id = this.state.selectedAddress.id ;

    let emptyAddress = {
      address_name: '',
      address: '',
      country: '',
      city: '',
      postal_code: '',
      user: '',
    }
    this.setState({selectedAddress: emptyAddress});


    axios.delete(serverUrl + 'api/location/byuser/'+ id +'/', header)
      .then(res => {

        console.log(res);
        console.log(res.data);

        

        axios.get(serverUrl + `api/location/byuser/`, header)
          .then(res => {
            console.log(res);
            console.log(res.data);

            this.setState({ addresses: res.data });


          }).catch(err => {
            console.log("error:  " + err)
          })


      }).catch(err => {
        console.log("error:  " + err)
      })


  }

  componentDidMount() {
    let myCookie = read_cookie('user');
    const header = {
      headers: {
        Authorization: "Token " + myCookie.token
      }
    };
    axios.get(serverUrl + `api/location/byuser/`, header)
      .then(res => {
        console.log(res);
        console.log(res.data);

        this.setState({ addresses: res.data });


      }).catch(err => {
        console.log("error:  " + err)
      })


  }

  handleChange = event => {

    event.preventDefault();
    let selectedAddress = this.state.selectedAddress;
    selectedAddress[event.target.name] = event.target.value;

    this.setState({ selectedAddress: selectedAddress });

  }












  render() {


    let addressNames = this.state.addresses?.map(address => {
      return (
        <button className={"listButton"} onClick={() => this.setState({ selectedAddress: address, adding: false })}><ListGroup.Item>{address.address_name}</ListGroup.Item></button>
      )


    })

    let emptyAddress = {
      address_name: '',
      address: '',
      country: '',
      city: '',
      postal_code: '',
      user: '',
    }

    addressNames?.push(

      <button className={"listButton"} onClick={() => this.setState({ selectedAddress: emptyAddress, adding: true })}><ListGroup.Item>Add New Address</ListGroup.Item></button>

    )





    return (
      <div className='background'>
        <CategoryBar></CategoryBar>
        <Row className={"listWrapper"}>
          <Col xs={4} className={'lists'}>
            <h2>My Addresses</h2>
            <ListGroup variant="flush">
              {addressNames}
            </ListGroup>
          </Col>
          <Col xs={6} className={'addAddress'}>
            <Form onSubmit={this.handleSubmit}>


              <Form.Group controlId="formGridAddress1">
                <Form.Label>Address Name</Form.Label>
                <Form.Control type="text" name="address_name" placeholder="Ev / İs / Okul"
                  onChange={this.handleChange}
                  value={this.state.selectedAddress.address_name} />
              </Form.Group>

              <Form.Group controlId="formGridAddress2">
                <Form.Label>Address </Form.Label>
                <Form.Control type="text" name="address" placeholder=""
                  onChange={this.handleChange}
                  value={this.state.selectedAddress.address} />
              </Form.Group>

              <Form.Row>
                <Form.Group as={Col} controlId="formGridCity">
                  <Form.Label>City</Form.Label>
                  <Form.Control type="text" name="city"
                    onChange={this.handleChange}
                    value={this.state.selectedAddress.city} />
                </Form.Group>

                <Form.Group as={Col} controlId="formGridState">
                  <Form.Label>Country</Form.Label>
                  <Form.Control type="text" name="country"
                    onChange={this.handleChange}
                    value={this.state.selectedAddress.country}>

                  </Form.Control>
                </Form.Group>

                <Form.Group as={Col} controlId="formGridZip">
                  <Form.Label>Zip</Form.Label>
                  <Form.Control type="text" name="postal_code"
                    onChange={this.handleChange}
                    value={this.state.selectedAddress.postal_code} />
                </Form.Group>
              </Form.Row>

              <Button variant="primary" type="submit">
                Submit
              </Button>

              <Button variant="danger" onClick={this.deleteAddress} hidden={this.state.adding}>
                Delete
              </Button>


            </Form>
          </Col>

        </Row>
      </div>
    )
  }


}
