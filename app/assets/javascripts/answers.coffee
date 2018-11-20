# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.vote_link').on 'ajax:success', (e) ->
    response = e.detail[0];
    rating = $('.question_rating').find('.rating');
    rating.html(response.rating);
    location.reload()

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,
    received: (data) ->
      if data.answer.user_id != gon.user_id
        $('.answers').append(JST['templates/answer'](
          answer: data.answer,
          attachments: data.attachments,
          rating: data.rating
        ));
  });

$(document).on('turbolinks:load', ready);
