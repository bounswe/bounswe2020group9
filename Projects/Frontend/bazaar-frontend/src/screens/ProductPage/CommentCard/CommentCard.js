import React, { Component } from 'react'
import "./commentCard.scss"

//components
import Row from 'react-bootstrap/Row'
import StarRatings from '../../../../node_modules/react-star-ratings';

export default class CommentCard extends Component {


  render() {
    return (
      <div className={'commentWrapper'}>
        <Row className={'commentName'}>
          {this.props.comment.name}
        </Row>

        <Row className={'commentRate'}>
        <StarRatings
                    rating={this.props.comment.rate}
                    starDimension="40px"
                    starSpacing="10px"
                    starRatedColor="#FFA41B"
                    starDimension="20px"
                    starSpacing="1px"
                  />
        </Row>

        <Row className={'commentDate'}>
          {this.props.comment.date}
        </Row>

        <Row className={'commentContent'}>
          {this.props.comment.content}
        </Row>

      </div>
    )
  }
}
