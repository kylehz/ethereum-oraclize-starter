<template>
  <div class="container">
    <h1>score : {{currentValue}}</h1>
    <h1>{{loading}}</h1>
    <button class="button is-primary" @click="setValue">Update</button>
  </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from "vue-property-decorator";
import Web3 from "web3";
const MyContract = require("../../build/contracts/EthPrice.json");

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:9545"));

let myContract = new web3.eth.Contract(
  MyContract.abi,
  "0x322E8b8625633bD6E55a0A498391C7CF4259D1D5"
);

@Component
export default class HelloWorld extends Vue {
  contractValue: string = "";
  currentValue: string = "";
  isValueUpdated: boolean = false;
  loading: string = "";
  accountAddress: string = ""

  async setValue() {
    let setValue = await myContract.methods.update().send({
      from: this.accountAddress,
      gas: "900000",
      value: "500000000000000000"
    });
    if (setValue) {
      this.isValueUpdated = true;
    }
  }
  async getCurrentValue() {
    let getValue = await myContract.methods
      .ethPriceUsd()
      .call()
      .then(result => {
        this.currentValue = parseFloat(result).toFixed(2);
      });

    let accounts = await web3.eth.getAccounts().then(result => {
        this.accountAddress = result[0]
    });
    
  }
  @Watch("isValueUpdated")
  onPropertyChanged(newValue: boolean, oldValue: boolean) {
    if (newValue == true) {
      this.loading = "Price is getting updated....";
      setTimeout(function() {
        window.location.reload(true);
      }, 15000);
    }
  }
  mounted() {
    this.getCurrentValue();
  }
}
</script>

<style scoped lang="scss">
</style>