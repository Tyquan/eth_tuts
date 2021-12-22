App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    $.getJSON('../pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers (more recent version of metamask)
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.request({method: "eth_requestAccounts"});
      } catch(error) {
        // User denied account access
        console.error("User denied account access");
      }
    }
    // legacy browsers (mist or older versions of metamask)
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider
    }
    else {
      // if no injected web3 instance is detected, fallback to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }

    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Adoption.json', (data) => {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      App.contracts.Adoption = TruffleContract(data);

      // Set the provider for our contract
      App.contracts.Adoption.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.markAdopted()
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function() {
    let adoptionInstance;
    // access the deployed Adoption smart contract
    App.contracts.Adoption.deployed()
    .then((instance) => {
      // store the contract instance in a variable
      adoptionInstance = instance;
      // use call() to read data without having to send a full transaction,
      // we wont have to spend any ether
      return adoptionInstance.getAdopters.call();
    }).then((adopters) => {
      // loop through all adopters checking yo see if an address us stored for each pet
      for(let i = 0; i < adopters.length; i++){
        // if the adopter slot is not empty nor available
        if(adopters[i] !== '0x0000000000000000000000000000000000000000'){
          // disable that pets adopt button and change the button text to "Success"
          $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
        }
      }
    }).catch((err) => {
      console.error(err.message);
    });
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    let adoptionInstance;

    // get the users account
    web3.eth.getAccounts((error, accounts) => {
      if (err) console.error(error);

      let account = accounts[0];

      // access the deployed Adoption smart contract
      App.contracts.Adoption.deployed()
        .then((instance) => {
          // store the contract instance in a variable
          adoptionInstance = instance;

          // Execute adopt as a transaction by sending account
          return adoptionInstance.adopt(petId, {from: account});
        })
        .then((result) => {
          // the result of sending a transaction is the transaction object
          // if no errors call markAdopted() to sync the UI winth the newly stored data
          return App.markAdopted();
        })
        .catch((err) => {
          console.error(err.message);
        });

    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
