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
      
      <Header />

      <Switch>
        <Route exact path="/">
          <Home />
        </Route>
        <Route path="/signUp">
          <SignUp />
        </Route>
        <Route path="/signIn">
          <SignIn />
        </Route>
        <Route path="/profile-page">
          <ProfilePage />
        </Route>
      </Switch>

      <Footer />

    </Router>
  );
}

export default App;
