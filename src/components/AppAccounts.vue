<template>
    <div class="jumbotron vertical-center">
      <div class="container">
        <div class="row">
          <div class="col-sm-12">
            <h1>Accounts</h1>
            <hr />
            <br />
            <b-alert v-if=showMessage variant="success" show>{{ message }}</b-alert>
            <button type="button" class="btn btn-success btn-sm" v-b-modal.account-modal>
              Add Account
            </button>
            <br /><br />
            <table class="table table-hover">
              <thead>
                <tr>
                  <th scope="col">Account Name</th>
                  <th scope="col">Account Number</th>
                  <th scope="col">Account Balance</th>
                  <th scope="col">Account Currency</th>
                  <th scope="col">Account Status</th>
                  <th scope="col">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="account in accounts" :key="account.id">
                  <td>{{account.name}}</td>
                  <td>{{account.number}}</td>
                  <td>{{account.balance}}</td>
                  <td>{{account.currency}}</td>
                  <td>
                  <span
                    v-if="account.status == 'Active'"
                    class="badge badge-success"
                    >{{ account.status }}</span
                  >
                  <span v-else class="badge badge-danger">{{
                    account.status
                  }}</span>
                </td>
                  <td>
                    <div class="btn-group" role="group">
                      <button type="button" class="btn btn-info btn-sm" v-b-modal.edit-account-modal @click="updateAccount(account)">
                        Edit
                      </button >
                      <button type="button" class="btn btn-danger btn-sm" @click="deleteAccount(account)">
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!-- Start of Modal for Create Account-->
    <b-modal
        ref="addAccountModal"
        id="account-modal"
        title="Create a new account"
        hide-backdrop
        hide-footer
      >
        <b-form @submit="onSubmit" class="w-100">
          <b-form-group
            id="form-name-group"
            label="Account Name:"
            label-for="form-name-input"
          >
            <b-form-input
              id="form-name-input"
              type="text"
              v-model="createAccountForm.name"
              placeholder="Account Name"
              required
            >
            </b-form-input>
          </b-form-group>
          <b-form-group
            id="form-currency-group"
            label="Currency:"
            label-for="form-currency-input"
          >
            <b-form-input
              id="form-currency-input"
              type="text"
              v-model="createAccountForm.currency"
              placeholder="$ or €"
              required
            >
            </b-form-input>
          </b-form-group>

          <b-button type="submit" variant="outline-info">Submit</b-button>
        </b-form>
      </b-modal>
      <!-- End of Modal for Create Account-->
      <!-- Start of Modal for Edit Account-->
      <b-modal
        ref="editAccountModal"
        id="edit-account-modal"
        title="Edit the account"
        hide-backdrop
        hide-footer
      >
        <b-form @submit="onSubmitUpdate" class="w-100">
          <b-form-group
            id="form-edit-name-group"
            label="Account Name:"
            label-for="form-edit-name-input"
          >
            <b-form-input
              id="form-edit-name-input"
              type="text"
              v-model="createAccountForm.name"
              placeholder="Account Name"
              required
            >
            </b-form-input>
          </b-form-group>
          <b-button type="submit" variant="outline-info">Submit</b-button>
        </b-form>
      </b-modal>
      <!-- End of Modal for Edit Account-->

      </div>
    </div>
  </template>

<script>
import axios from "axios";
export default {
  name: "AppAccounts",
  data() {
    return {
      accounts: [],
      createAccountForm: {
        name: "",
        currency: "",
      },
      editAccountForm: {
        id: "",
        name: "",
      },
      showMessage: false,

    };
  },
  methods: {
    // GET accounts
    getAccounts() {
      const path = "http://localhost:5000/accounts";
      axios
        .get(path)
        .then((response) => {
          this.accounts = response.data.accounts;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    // POST function
    createAccount(payload) {
      const path = "http://localhost:5000/accounts";
      axios
        .post(path, payload)
        .then((response) => {
          this.getAccounts();
          // For message alert
          this.message = "Account Created succesfully!";
          // To actually show the message
          this.showMessage = true;
          // To hide the message after 3 seconds
          setTimeout(() => {
            this.showMessage = false;
          }, 3000);

        })
        .catch((error) => {
          console.error(error);
          this.getAccounts();
        });
    },
    // Update function
    updateAccount(payload, accountId) {
      const path = `http://localhost:5000/accounts/${accountId}`;
      axios
        .put(path, payload)
        .then((response) => {
          this.getAccounts();
          // For message alert
          this.message = "Account Updated succesfully!";
          // To actually show the message
          this.showMessage = true;
          // To hide the message after 3 seconds
          setTimeout(() => {
            this.showMessage = false;
          }, 3000);
        })
        .catch((error) => {
          console.error(error);
          this.getAccounts();
        });
    },
    // Delete account
    RESTdeleteAccount(accountId) {
      const path = `http://localhost:5000/accounts/${accountId}`;
      axios
        .delete(path)
        .then((response) => {
          this.getAccounts();
          // For message alert
          this.message = "Account Deleted succesfully!";
          // To actually show the message
          this.showMessage = true;
          // To hide the message after 3 seconds
          setTimeout(() => {
            this.showMessage = false;
          }, 3000);
        })
        .catch((error) => {
          console.error(error);
          this.getAccounts();
        });
    },
    // Handle Delete button
    deleteAccount(account) {
      this.RESTdeleteAccount(account.id);
    },

    initForm() {
      this.createAccountForm.name = "";
      this.createAccountForm.currency = "";
      this.editAccountForm.id = "";
      this.editAccountForm.name = "";
    },
    onSubmit(e) {
      e.preventDefault(); //prevent default form submit form the browser
      this.$refs.addAccountModal.hide(); //hide the modal when submitted
      const payload = {
        name: this.createAccountForm.name,
        currency: this.createAccountForm.currency,
      };
      this.createAccount(payload);
      this.initForm;
    },
    // Handle submit event for edit account
    onSubmitUpdate(e) {
      e.preventDefault(); //prevent default form submit form the browser
      this.$refs.editAccountModal.hide(); //hide the modal when submitted
      const payload = {
        name: this.editAccountForm.name,
      };
      this.updateAccount(payload, this.editAccountForm.id);
    },
    //Prepare edit account form with the name of the account
    editAccount(account) {
      this.editAccountForm.name = account.name;
      this.editAccountForm.id = account.id;
    },


  },
  created() {
    this.getAccounts();
  },
};
</script>
