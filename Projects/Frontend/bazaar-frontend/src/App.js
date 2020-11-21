import React, { Fragment } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import './App.css';

//screens
import ProfilePage from "./screens/Profile-page";
import SignIn from "./screens/Sign-In"
import SignUp from "./screens/Sign-Up"
import Home from "./screens/Home"

//components
import Header from "./components/Header"
import Footer from "./components/Footer"


function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/">
          <Header />
          <Home />
          <Footer />
        </Route>
        <Route path="/signUp">
          <Header />
          <SignUp />
          <Footer />
        </Route>
        <Route path="/signIn">
          <Header />  
          <SignIn />
          <Footer />
        </Route>
        <Route path="/profile-page">
          <ProfilePage />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
