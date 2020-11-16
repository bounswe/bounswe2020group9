import React from 'react';
import { Link } from "react-router-dom";


const Home = () => {
  return (
    <div>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/components/Header">Header</Link>
            </li>
            <li>
              <Link to="/signIn">Sign In</Link>
            </li>
            <li>
              <Link to="/signUp">Sign Up</Link>
            </li>
          </ul>
        </nav>
    </div>
  );
}

export default Home;
