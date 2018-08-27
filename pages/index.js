import React, { Component } from "react";
import m8BountyFactory from "../ethereum/m8Factory.js";
import { Link } from "../routes";
import Layout from "../components/Layout";
import { Button } from "semantic-ui-react";

class Index extends Component {
  static async getInitialProps() {
    const bounties = await m8BountyFactory.methods.getDeployedBounties().call();
    return { bounties };
  }
  render() {
    return (
      <Layout>
        <Link route={`/bounties/new`}>
          <Button floated="right">Create A Bounty</Button>
        </Link>

        <h3>Open Bounties</h3>
        {this.props.bounties.map(bounty => {
          return <Link route={`/bounties/${bounty}`}>{bounty}</Link>;
        })}
      </Layout>
    );
  }
}

export default Index;
