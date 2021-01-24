import React, { Component } from "react";
import "./mylist.scss";
import axios from "axios";

//components
import Accordion from "react-bootstrap/Accordion";
import Card from "react-bootstrap/Card";
import ProductCard from "../../components/ProductCard/productCard";
import Button from "react-bootstrap/Button";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import ListGroup from "react-bootstrap/ListGroup";
import CategoryBar from "../../components/category-bar/category-bar";
import Form from "react-bootstrap/Form";

//helpers
import { serverUrl } from "../../utils/get-url";
import { bake_cookie, read_cookie, delete_cookie } from "sfcookies";

//icons
import addListIcon from "../../assets/icons/add-list-icon.svg";
import removeListIcon from "../../assets/icons/remove.svg";

export default class MyList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      productLists: [],
      whichList: 1,
      productList: {},
      list_name: "",
      list_is_private: false,
    };
  }

  componentDidMount() {
    let myCookie = read_cookie("user");

    axios
      .get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {
        headers: {
          Authorization: `Token ${myCookie.token}`,
        },
      })
      .then((res) => {
        this.setState({ productLists: res.data });
      });

    axios
      .get(
        serverUrl +
          `api/user/${myCookie.user_id}/list/${this.state.whichList}/`,
        {
          headers: {
            Authorization: `Token ${myCookie.token}`,
          },
        }
      )
      .then((res) => {
        this.setState({ productList: res.data });
      });
  }

  componentDidUpdate(prevProps, prevState) {
    let myCookie = read_cookie("user");

    if (prevState.whichList !== this.state.whichList) {
      axios
        .get(
          serverUrl +
            `api/user/${myCookie.user_id}/list/${this.state.whichList}/`,
          {
            headers: {
              Authorization: `Token ${myCookie.token}`,
            },
          }
        )
        .then((res) => {
          this.setState({ productList: res.data });
        });
    }
  }

  renderList() {
    let productCards = this.state.productList.products?.map((product) => {
      return (
        <Col sm="3">
          <ProductCard product={product}></ProductCard>
        </Col>
      );
    });

    return <Row>{productCards}</Row>;
  }

  onAddListSubmit = () => {
    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    const data = {
      name: this.state.list_name,
      customer: myCookie.user_id,
      is_private: this.state.list_is_private,
    };

    axios
      .post(serverUrl + `api/user/${myCookie.user_id}/lists/`, data, {
        headers: headers,
      })
      .then((res) => {
        axios
          .get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {
            headers: {
              Authorization: `Token ${myCookie.token}`,
            },
          })
          .then((res) => {
            this.setState({ productLists: res.data });
          });
      });
  };

  onListNameChange = (event) => {
    this.setState({ list_name: event.target.value });
    console.log(this.state.list_name);
  };

  onListPrivateChange = (event) => {
    // this is slightly diffent from normal event.value, in this library check can be used by target.check value
    this.setState({ list_is_private: event.target.checked });
  };

  render() {
    let listNames = this.state.productLists?.map((list) => {
      return (
        <Row className="listRow">
          <button
            className={"listButton"}
            onClick={() => this.setState({ whichList: list.id })}
          >
            <ListGroup.Item>{list.name}</ListGroup.Item>
          </button>
          <button
            className="listRemoveButton"
            onClick={this.onDeleteListButton}
          >
            <img src={removeListIcon} />
          </button>
        </Row>
      );
    });

    return (
      <div className="background">
        <CategoryBar></CategoryBar>
        <Row className={"listWrapper"}>
          <Col xs={3} className={"lists"}>
            <Row>
              <h2>My Lists</h2>
            </Row>
            <ListGroup variant="flush">{listNames}</ListGroup>
            <Row className="addListRow">
              <Form.Group>
                <Form.Control
                  size="sm"
                  type="text"
                  placeholder="Write new list name"
                  onChange={this.onListNameChange}
                />

                <div className="isFormPrivate">
                  <Form.Check
                    type="switch"
                    id="custom-switch"
                    label="Private"
                    onChange={this.onListPrivateChange}
                  />
                </div>
              </Form.Group>

              <button className="addListButton" onClick={this.onAddListSubmit}>
                Add List <img src={addListIcon} />
              </button>
            </Row>
          </Col>
          <Col xs={9}>{this.renderList()}</Col>
        </Row>
      </div>
    );
  }
}
