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
  import MyAddresses from "./screens/MyAdresses/MyAddresses";
  import MyOrdersVendor from "./screens/MyOrders/my-orders-vendor";
  import MyComments from "./screens/MyComments/MyComments";
  import ShowList from "./screens/ShowList/ShowList";

  //components
  import Header from "./components/Header/Header";
  import Footer from "./components/Footer/Footer";

  function App() {
    return (
      <Router>
        <Header/>
        
        <Switch>

          <Route exact path="/">
            <Home />
          </Route>

          <Route path="/signUp"> 
            <SignUp />
          </Route>

          <Route path="/signUp-vendor">     
            <SignUpVendor />
          </Route>

          <Route path="/signIn">
            <SignIn />
          </Route>

          <Route path="/checkout">
            <Checkout />
          </Route>

          <Route path="/my-orders-vendor">  
            <MyOrdersVendor />
          </Route>

          <Route
            path="/resetpw=:id"
            render={(props) => (
              <div>   
                <ResetPassword {...props} />
              </div>
            )}
          />

          <Route
            path="/activate=:id"
            render={(props) => (
              <div> 
                <Activate {...props} />
              </div>
            )}
          />

          <Route
            path="/showlist"
            render={(props) => (
              <div>
                <ShowList {...props} />
              </div>
            )}
          />

          <Route path="/forgot-password">
            <ForgotPassword />
          </Route>

          <Route path="/profile-page"> 
            <ProfilePage />
          </Route>

          <Route
            path="/user/:user_id"
            render={(props) => (
              <div>
                <UserPage {...props} />
              </div>
            )}
          />

          <Route path="/messages"> 
            <Messages />
          </Route>

          <Route path="/my-list"> 
            <MyList />
          </Route>

          <Route path="/my-comments">
            <MyComments />
          </Route>

          <Route path="/my-orders">
            <MyOrders />
          </Route>

          <Route path="/MyAddresses">
            <MyAddresses />
          </Route>

          <Route path="/add-product">
            <AddProduct />
          </Route>

          <Route path="/inventory">
            <Inventory />
          </Route>

          <Route
            path="/product/:id"
            render={(props) => (
              <div>
                <ProductPage {...props} />
              </div>
            )}
          />

          <Route
            path="/search=:keywords"
            render={(props) => (
              <div>
                <SearchResults {...props} />
              </div>
            )}
          />

          <Route
            path="/category/:id"
            render={(props) => (
              <div>
                <ViewCategory {...props} />
              </div>
            )}
          />

          <Route
            path="/cart"
            render={(props) => (
              <div>
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
