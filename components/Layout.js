import React, { Component } from 'react';
import { Container } from 'semantic-ui-react';
import Head from 'next/head';

export default class Layout extends Component {
  render() {
    return (
      <Container style={{ marginTop: '30px' }}>
        <Head>
          <link
            rel="stylesheet"
            href="//cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.12/semantic.min.css"
          />
          <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"
          />
        </Head>
        {this.props.children}
      </Container>
    );
  }
}
