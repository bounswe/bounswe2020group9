import React, { Component } from "react";
import "./mylist.scss";
import axios from "axios";

//components
import ProductCard from "../../components/ProductCard/productCard";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import ListGroup from "react-bootstrap/ListGroup";
import Form from "react-bootstrap/Form";

//helpers
import { serverUrl } from "../../utils/get-url";
import { read_cookie } from "sfcookies";

//icons
import addListIcon from "../../assets/icons/add-list-icon.svg";
import removeListIcon from "../../assets/icons/remove.svg";

export default class MyList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      productLists: [],
      whichList: 0,
      productList: {},
      list_name: "",
      list_is_private: false,
      isAuthorizedUser: true,
    };
  }

  componentDidMount() {
    let myCookie = read_cookie("user");

    if (myCookie.length != 0) {
      axios
        .get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {
          headers: {
            Authorization: `Token ${myCookie.token}`,
          },
        })
        .then((res) => {
          this.setState({ productLists: res.data });
        })
        .catch((error) => {
          if (error.response) {
            if (error.response.status == 401) {
              this.setState({isAuthorizedUser: false})
              axios
                .get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {})
                .then((res) => {
                  this.setState({ productLists: res.data });
                });
            }
            console.log(error.response.status);
          }
        });
    } else {
      axios
        .get(serverUrl + `api/user/${myCookie.user_id}/lists/`, {})
        .then((res) => {
          this.setState({ productLists: res.data });
        });
    }

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
      })
      .catch((error) => {
        if (error.response) {
          if (error.response.status == 401) {
            axios
              .get(
                serverUrl +
                  `api/user/${myCookie.user_id}/list/${this.state.whichList}/`
              )
              .then((res) => {
                this.setState({ productList: res.data });
              });
          }
          console.log(error.response.status);
        }
      });
      if (this.state.productLists.length > 0) {
        this.setState({whichList: 2})
      }
  }

  componentDidUpdate(prevProps, prevState) {
    let myCookie = read_cookie("user");

    if (prevState.whichList !== this.state.whichList) {
      if (this.state.isAuthorizedUser) {
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
      } else {
        axios
        .get(
          serverUrl +
            `api/user/${myCookie.user_id}/list/${this.state.whichList}/`
        )
        .then((res) => {
          this.setState({ productList: res.data });
        });
      }
    }
  }

  renderList() {

    console.log("whichlist: ", this.state.whichList)
    let productCards = this.state.productList.products?.map((product) => {
      return (
        <Col sm="3">
          <button
            className="listProductRemoveButton"
            onClick={(event) => this.onDeleteListProductButton(event, product)}
          >
            <img src={removeListIcon} hidden={!this.state.isAuthorizedUser}/>
          </button>
          <ProductCard product={product}></ProductCard>
        </Col>
      );
    });

    return <Row>{productCards}</Row>;
  }

  onDeleteListProductButton(event, product) {
    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    const data = {
      product_id: product.id,
    };

    console.log(data);

    axios
      .delete(
        serverUrl +
          `api/user/${myCookie.user_id}/list/${this.state.whichList}/edit/`,
        { headers: headers, data: data }
      )
      .then((res) => {
        axios
          .get(
            serverUrl +
              `api/user/${myCookie.user_id}/list/${this.state.whichList}/`,
            {
              headers: headers,
            }
          )
          .then((res) => {
            this.setState({ productList: res.data });
          });
      });
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

  onDeleteListButton = (event, list) => {
    let myCookie = read_cookie("user");

    const headers = {
      Authorization: `Token ${myCookie.token}`,
    };

    axios
      .delete(serverUrl + `api/user/${myCookie.user_id}/list/${list.id}/`, {
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
            onClick={(event) => this.onDeleteListButton(event, list)}
          >
            <img src={removeListIcon} hidden={!this.state.isAuthorizedUser}/>
          </button>
        </Row>
      );
    });

    return (
      <div className="background">
        <Row className={"listWrapper"}>
          <Col xs={3} className={"lists"}>
            <Row>
              <h2>My Lists</h2>
            </Row>
            <ListGroup variant="flush">{listNames}</ListGroup>
            <Row className="addListRow" hidden={!this.state.isAuthorizedUser}>
              <Form.Group>
                <Form.Control
                  size="sm"
                  type="text"
                  placeholder="Write new list name"
                  onChange={this.onListNameChange}
                />

                <div className="isFormPrivate" >
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
