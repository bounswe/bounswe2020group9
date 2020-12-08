import React, { Component } from 'react'
import "./mylist.scss"

import Accordion from 'react-bootstrap/Accordion'
import Card from 'react-bootstrap/Card'
import Button from 'react-bootstrap/Button'

import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import ListGroup from 'react-bootstrap/ListGroup'

export default class MyList extends Component {
    
    renderList = (whichList) => {
        return(
            <div>
                DENEMEEEE LISTEEEEE
            </div>
        )
    }


    render() {

        return (
            <div>
                <Row>
                    <Col xs={3}>
                    <ListGroup variant="flush">
                    <ListGroup.Item>MyList 1</ListGroup.Item>
                    <ListGroup.Item>MyList 2</ListGroup.Item>
                    <ListGroup.Item>MyList 3</ListGroup.Item>
                    <ListGroup.Item>MyList 4</ListGroup.Item>
                    </ListGroup>
                    </Col>
                    <Col xs={9}>
                        {this.renderList("random string")}
                    </Col>
                </Row>
            </div>
        )
    }
}
