import React from 'react';

import ProfilePageComponent from "../../components/Profile-Page"
import Header from "../../components/Header"
import Footer from "../../components/Footer"

const ProfilePage = () => {
  return (
    <div>
      <Header/>
      <ProfilePageComponent/>
      <Footer/>
    </div>
  );
}

export default ProfilePage;
