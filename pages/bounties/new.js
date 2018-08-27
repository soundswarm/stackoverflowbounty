import React, { Component } from "react";
import m8Bounty from "../../ethereum/m8Bounty.js";
import { Link } from "../../routes";
import { Button, Input, Card } from "semantic-ui-react";
import Layout from "../../components/Layout";
import m8BountyFactory from "../../ethereum/m8Factory.js";
import web3 from "../../ethereum/web3";

export default class Show extends Component {
  state = { questionId: "", loading: false };
  static async getInitialProps(props) {
    return {};
  }

  createBounty = async () => {
    if (this.state.questionId) {
      const accounts = await web3.eth.getAccounts();
      try {
        this.setState({ loading: true });
        const transaction = await m8BountyFactory.methods
          .createBounty(parseInt(this.state.questionId), "stackoverflow")
          .send({ from: accounts[0] });
        this.setState({ loading: false });
      } catch (e) {
        console.log("error", e);
      }
      console.log("TRANSACTION", transaction);
    }
  };
  async componentDidMount() {}
  render() {
    return (
      <Layout>
        <h1>Bounty Details</h1>

        <h3>
          You must be signed into metamask to create a 10 M8B token bounty. Enter the stackoverflow question ID below.
        </h3>
        <Input
          placeholder="stackoverflow question ID"
          onChange={e => this.setState({ questionId: e.target.value })}
          value={this.state.questionId}
        />
        <Button onClick={this.createBounty} loading={this.state.loading}>Create Bounty</Button>
      </Layout>
    );
  }
}
