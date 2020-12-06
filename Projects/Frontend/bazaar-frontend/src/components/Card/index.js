import React, { Component } from "react";
import Card from 'react-bootstrap/Card'
import myImage from '../../assets/productFiller.svg'
import image3 from '../../assets/images/3.jfif'
import image4 from '../../assets/images/4.jfif'
import image5 from '../../assets/images/5.jpg'
import image6 from '../../assets/images/6.png'
import image7 from '../../assets/images/7.jpg'
import image8 from '../../assets/images/8.png'
import image9 from '../../assets/images/9.png'
import image10 from '../../assets/images/10.png'
import image11 from '../../assets/images/11.png'
import image12 from '../../assets/images/12.png'
import image13 from '../../assets/images/13.png'
import image14 from '../../assets/images/14.png'
import image15 from '../../assets/images/15.jpg'
import image16 from '../../assets/images/16.png'
import image17 from '../../assets/images/17.png'
import image18 from '../../assets/images/18.jpg'
import image19 from '../../assets/images/19.png'
import image20 from '../../assets/images/20.png'



import "./card.css";

export default class CardComponent extends Component {

render(){

    let num = this.props.product.id;
    let image = this.props.myImage
    console.log(image);

    let categories = this.props.product.categories.map(category => {
        return (
          <span>'{category}' </span>
        )
      })

    return(
        <div>
            <Card style={{height: '26rem' }}>
            <Card.Img variant="top" src={image} />
            <Card.Body>
                <Card.Title>{this.props.product.name}</Card.Title>
                <Card.Text>
                {categories}
                </Card.Text>
            </Card.Body>
            <Card.Footer>
                <small className="text-muted">{this.props.product.brand}, ${this.props.product.price}</small>
            </Card.Footer>
            </Card>
        </div>
    )
}

}
