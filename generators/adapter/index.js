'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var yosay = require('yosay');
var chalk = require('chalk');
var sys = require('sys')
var fs = require('fs')

var HttpRubyGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../../package.json');
  },

  askFor: function() {
    var done = this.async();

    // have Yeoman greet the user
    console.log(this.yeoman);

    var prompts = [{
        name: 'adapterType',
        message: 'What is your adapter\'s Type?'
    },
    {
        name: 'adapterName',
        message: 'What is your adapter\'s name?'
    }];

    this.prompt(prompts, function (props) {
        this.adapterName = props.adapterName;
        this.AdapterName = props.adapterName.charAt(0).toUpperCase() + props.adapterName.slice(1);
        this.adapterType = props.adapterType;

        done();
    }.bind(this));
  },

  createFiles: function () {
    var done = this.async();

    var context = {
      service: this.adapterName,
      Service: this.AdapterName
    }

    //adapter
    this.template(
      '_service.rb',
      'adapters/http/'+context.service+'.rb',
      context
    );
    //spec
    this.template(
      '_service_spec.rb',
      'spec/adapters/http/'+context.service+'.rb',
      context
    );
  }


});

module.exports = HttpRubyGenerator;
