import React, { Component } from "react";
import "./category-bar.scss";
import axios from 'axios'
import { serverUrl } from "../../utils/get-url";
import Pagination from "react-bootstrap/Pagination";


export default class CategoryBar extends Component {

  constructor() {
    super();
    this.state = {
      categoryList: [],
      categoryDict: {},
      categoryStructure: { "": [] },
    };
  }

  componentDidMount(){
    axios.get(serverUrl + "api/product/categories/").then((res) => {
      let resp = res.data;
      let categoryStructureTemp = {};
      let keys = [];
      let categoryDictTemp = {};
      for (let i = 0; i < resp.length; i++) {
        if (resp[i]["parent"] === "Categories") {
          keys.push(resp[i]["name"]);
          categoryDictTemp[resp[i]["id"]] = resp[i]["name"];
        }
      }
      this.setState({ categoryList: keys });
      this.setState({ categoryDict: categoryDictTemp });
      for (let i = 0; i < keys.length; i++) {
        let sublist = [];
        for (let j = 0; j < resp.length; j++) {
          if (resp[j]["parent"] === keys[i]) {
            sublist.push(resp[j]["name"]);
          }
        }
        categoryStructureTemp[keys[i]] = sublist;
      }
      categoryStructureTemp[""] = [];

      this.setState({ categoryStructure: categoryStructureTemp });
    });
  }

  render() {
    //console.log(this.props)
    let categoryList = this.state.categoryList;
    let categoryStructure = this.state.categoryStructure;
    let categories = [];
    //console.log("category bar here")

    for (let number = 0; number < categoryList.length; number++) {
      let subs = [];
      let subList = categoryStructure[categoryList[number]];
      if (subList) {
        for (let subnumber = 0; subnumber < subList.length; subnumber++) {
          subs.push(
            <a
              className="dropdown-item item-custom"
              href={"/category/" + subList[subnumber]}
            >
              {subList[subnumber]}
            </a>
          );
        }
      }

      if (subs.length === 0){
        categories.push(
          <Pagination.Item
            key={number}
            className="myPaginationItem dropdown"
            href={"/category/" + categoryList[number]}
          >
            <a className="nav-link dropdown-head">
              <span className="mr-1"></span> {categoryList[number]}
            </a>
          </Pagination.Item>
        );  
      } else {
        categories.push(
          <Pagination.Item
            key={number}
            className="myPaginationItem dropdown"
            href={"/category/" + categoryList[number]}
          >
            <a className="nav-link dropdown-toggle dropdown-head">
              <span className="mr-1"></span> {categoryList[number]}
            </a>
            <div className="dropdown-menu dropdown-list">{subs}</div>
          </Pagination.Item>
        );
      }

    }
 
    return (
      <div className="myPagination">
        <Pagination size="lg">{categories}</Pagination>
      </div>
    )
  }

}
