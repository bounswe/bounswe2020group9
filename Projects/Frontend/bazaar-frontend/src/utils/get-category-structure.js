import axios from 'axios'
import {serverUrl} from './get-url'


export default function CategoryStructure () {
  var categoryList = {}
  axios.get(serverUrl+'api/product/categories/')
  .then(res => {
    let resp = res.data;
    let keys = [];
    for (let i=0;i<resp.length;i++) {
      if (resp[i]["parent"] === "Categories") {
        keys.push(resp[i]["name"])
      }
    }
    for (let i=0;i<keys.length;i++) {
      let sublist = []
      for (let j=0;j<resp.length;j++) {
        if (resp[j]["parent"] === keys[i]) {
          sublist.push(resp[j]["name"]);
        }
      }
      categoryList[keys[i]] = sublist;
    }
  })
  console.log(JSON.stringify(categoryList))
  return categoryList;
}