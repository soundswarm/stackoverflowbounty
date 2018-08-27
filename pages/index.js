import React, { Component } from "react";
import m8BountyFactory from "../ethereum/m8Factory.js";
import { Link } from "../routes";
import Layout from "../components/Layout";
import { Button, Card } from "semantic-ui-react";

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

        <h3>Bounties on Stack Overflow Questions</h3>
        {this.props.bounties.map((bounty, i) => {
          return (
            <Card fluid key={i}>
              <Link route={`/bounties/${bounty}`}>{bounty}</Link>
            </Card>
          );
        })}
      </Layout>
    );
  }
}

export default Index;
