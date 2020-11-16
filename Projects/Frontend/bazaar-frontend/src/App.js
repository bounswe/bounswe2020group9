import React, { Fragment } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import './App.css';

//screens
import SignIn from "./screens/Sign-In"
import SignUp from "./screens/Sign-Up"
import Home from "./screens/Home"

//components
import Header from "./components/Header"


function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/">
          <Header/>
          <Home />
        </Route>
        <Route path="/signUp">
          <SignUp />
        </Route>
        <Route path="/signIn">
          <SignIn />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
