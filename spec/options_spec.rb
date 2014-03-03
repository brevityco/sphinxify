# encoding: utf-8
require 'spec_helper'

describe Sphinxify::Options do

  let :options do
    Sphinxify::Options.new
  end

  it 'should set select option' do
    options.select('*')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:select]
    options.to_search_options[:select].should be == '*'
  end

  it 'should replace the select option' do
    options.select('*')
    options.select('count(*)')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:select]
    options.to_search_options[:select].should be == 'count(*)'
  end

  it 'should add a condition' do
    options.conditions(email: 'test@example.com')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:conditions]
    options.to_search_options[:conditions].should be == { email: 'test@example.com' }
  end

  it 'should add multiple conditions' do
    options.conditions(email: 'test@example.com')
    options.conditions(name: 'User A')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:conditions]
    options.to_search_options[:conditions].size.should be == 2
    options.to_search_options[:conditions].keys.should be == [:email, :name]
    options.to_search_options[:conditions].should be == { email: 'test@example.com', name: 'User A'}
  end

  it 'should add a with' do
    options.with(email: 'test@example.com')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:with]
    options.to_search_options[:with].should be == { email: 'test@example.com' }
  end

  it 'should add multiple conditions' do
    options.with(email: 'test@example.com')
    options.with(name: 'User A')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:with]
    options.to_search_options[:with].size.should be == 2
    options.to_search_options[:with].keys.should be == [:email, :name]
    options.to_search_options[:with].should be == { email: 'test@example.com', name: 'User A'}
  end

  it 'should set order option' do
    options.order('name')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:order]
    options.to_search_options[:order].should be == 'name'
  end

  it 'should replace the order option' do
    options.order('name')
    options.order('email')

    options.to_search_options.size.should be == 1
    options.to_search_options.keys.should be == [:order]
    options.to_search_options[:order].should be == 'email'
  end
end