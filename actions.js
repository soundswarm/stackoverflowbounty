import axios from "axios";
const url = "https://api.stackexchange.com/2.2";

export function getStackExchangeQuestion(id, site) {
  return axios
    .get(`${url}/questions/${id}`, { params: { site } })
    .then(res => res.data.items[0]);
}
