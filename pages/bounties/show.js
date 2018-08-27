import React, { Component } from "react";
import m8Bounty from "../../ethereum/m8Bounty.js";
import { Card } from "semantic-ui-react";
import { getStackExchangeQuestion } from "../../actions";
import { Link } from "../../routes";
import { Button } from "semantic-ui-react";
import Layout from "../../components/Layout";
import web3 from "../../ethereum/web3";

export default class Show extends Component {
  state = { loading: false };
  static async getInitialProps(props) {
    const bountyContract = m8Bounty(props.query.address);

    const summary = await bountyContract.methods.getBounty().call();
    const questionId = summary[0];
    const site = summary[1];
    const question = await getStackExchangeQuestion(questionId, site);
    return {
      question,
      questionId,
      site,
      m8TokenBalance: summary[2],
      address: props.query.address
    };
  }

  claimBounty = async () => {
    const accounts = await web3.eth.getAccounts();
    const bountyContract = m8Bounty(this.props.address);
    try {
      this.setState({ loading: true });
      const acceptedAnswerId = await bountyContract.methods
        .getAcceptedAnswerId()
        .send({ from: accounts[0], value: web3.utils.toWei("0.02", "ether") });

      const winnerId = await bountyContract.methods
        .getWinnerId()
        .send({ from: accounts[0], value: web3.utils.toWei("0.02", "ether") });

      const claimedBounty = await bountyContract.methods
        .claimBounty()
        .send({ from: accounts[0], value: web3.utils.toWei("0.02", "ether") });

      console.log("CLAIMEDBOUNTY", claimedBounty);
      this.setState({ loading: false });
    } catch (e) {
      console.log("error", e);
    }
  };

  render() {
    const items = [
      {
        header: (
          <Link href={this.props.question.link}>
            {this.props.question.title}
          </Link>
        ),
        description: `Bounty: ${this.props.m8TokenBalance} M8B`
      }
    ];
    return (
      <Layout>
        <h1>Bounty Details</h1>
        <Card.Group items={items} />

        <h3>
          To claim this bounty you must have an approved answer for this
          stackoverflow question and you must have your ethereum address posted
          in the location section of your stackexchange profile. The bounty will
          be sent to the address in your profile location. You must be signed
          into metamask to claim the bounty. You will have to spend your
          hard-earned Rinkeby eth on 3 transactions which use Oraclize. Then you
          will receive the bounty.
        </h3>
        <Button onClick={this.claimBounty} loading={this.state.loading}>
          Claim Bounty
        </Button>
      </Layout>
    );
  }
}
