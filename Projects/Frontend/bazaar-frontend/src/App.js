import React from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import "./App.css";

//screens
import ProfilePage from "./screens/Profile-page/profile-page";
import UserPage from "./screens/Profile-page/user-page";

import SignIn from "./screens/Sign-In/sign-in";
import SignUp from "./screens/Sign-Up/sign-up";
import Activate from "./screens/Sign-Up/activate";
import SignUpVendor from "./screens/Sign-Up/sign-up-vendor";
import Home from "./screens/Home/home";
import ResetPassword from "./screens/Sign-In/reset-pw";
import ForgotPassword from "./screens/Sign-In/forgot-password";
import MyList from "./screens/MyList/MyList";
import MyOrders from "./screens/MyOrders/my-orders";
import AddProduct from "./screens/Add-Product/addproduct";
import Inventory from "./screens/Inventory/inventory";
import ProductPage from "./screens/ProductPage/ProductPage";
import ViewCategory from "./screens/ViewCategory/view-category";
import Cart from "./screens/Cart/Cart";
import SearchResults from "./screens/SearchResults/search-results";
import Checkout from "./screens/Cart/Checkout/checkout";
import Messages from "./screens/Messages/messages";

import MyCredictCards from "./screens/MyCredictCards/MyCredictCards"


import MyAddresses from "./screens/MyAdresses/MyAddresses";
import MyOrdersVendor from "./screens/MyOrders/my-orders-vendor";
import MyComments from "./screens/MyComments/MyComments";
import ShowList from "./screens/ShowList/ShowList";
import AdminHome from "./screens/Admin/admin-home";
import UserList from "./screens/Admin/user-list";
import CommentList from "./screens/Admin/comment-list";


//components
import Header from "./components/Header/Header";
import Footer from "./components/Footer/Footer";

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/">
          <Header />
          <Home />
        </Route>
        <Route path="/signUp">
          <Header />
          <SignUp />
        </Route>
        <Route path="/signUp-vendor">
          <Header />
          <SignUpVendor />
        </Route>
        <Route path="/signIn">
          <Header />
          <SignIn />
        </Route>
        <Route path="/checkout">
          <Header />
          <Checkout />
        </Route>

        <Route path="/my-orders-vendor">
          <Header />
          <MyOrdersVendor />
        </Route>
        <Route
          path="/resetpw=:id"
          render={(props) => (
            <div>
              <Header />
              <ResetPassword {...props} />
            </div>
          )}
        />
        <Route
          path="/activate=:id"
          render={(props) => (
            <div>
              <Header />
              <Activate {...props} />
            </div>
          )}
        />
        <Route
          path="/showlist"
          render={(props) => (
            <div>
              <Header />
              <ShowList {...props} />
            </div>
          )}
        />
        <Route path="/forgot-password">
          <Header />
          <ForgotPassword />
        </Route>
        <Route path="/admin-home">
          <Header />
          <AdminHome />
        </Route>
        <Route path="/admin-user-list">
          <Header />
          <UserList />
        </Route>
        <Route path="/admin-comment-list">
          <Header />
          <CommentList />
        </Route>
        <Route path="/profile-page">
          <Header />
          <ProfilePage />
        </Route>
        <Route
          path="/user/:user_id"
          render={(props) => (
            <div>
              <Header />
              <UserPage {...props} />
            </div>
          )}
        />
        <Route path="/messages">
          <Header />
          <Messages />
        </Route>
        <Route path="/my-list">
          <Header />
          <MyList />
        </Route>
        <Route path="/my-comments">
          <Header />
          <MyComments />
        </Route>
        <Route path="/my-orders">
          <Header />
          <MyOrders />
        </Route>
        <Route path="/MyAddresses">
          <Header />
          <MyAddresses />
        </Route>
        <Route path="/MyCredictCards">
          <Header />
          <MyCredictCards />
        </Route>
        <Route path="/add-product">
          <Header />
          <AddProduct />
        </Route>
        <Route path="/inventory">
          <Header />
          <Inventory />
        </Route>
        <Route
          path="/product/:id"
          render={(props) => (
            <div>
              <Header />
              <ProductPage {...props} />
            </div>
          )}
        />
        <Route
          path="/search=:keywords"
          render={(props) => (
            <div>
              <Header />
              <SearchResults {...props} />
            </div>
          )}
        />
        <Route
          path="/category/:id"
          render={(props) => (
            <div>
              <Header />
              <ViewCategory {...props} />
            </div>
          )}
        />
        <Route
          path="/cart"
          render={(props) => (
            <div>
              <Header />
              <Cart {...props} />
            </div>
          )}
        />
      </Switch>

      <Footer />
    </Router>
  );
}

export default App;
