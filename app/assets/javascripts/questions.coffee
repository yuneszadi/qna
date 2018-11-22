# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $('.edit-question-link').click (e) ->
    console.log('event')
    e.preventDefault();
    $('.edit_question').show();
    $(this).hide();


  $('.vote_link').on 'ajax:success', (e) ->
    response = e.detail[0];
    rating = $('.answer_' + response.id).find('.answer_rating').find('.rating');
    rating.html(response.rating);
    location.reload()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('.questions').append data
  })


$(document).on('turbolinks:load', ready);
