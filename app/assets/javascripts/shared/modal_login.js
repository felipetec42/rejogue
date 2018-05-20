$(document).on("turbolinks:load", function() {
  $('.btn-cadastrar').click(function(){
    $('#form-login').fadeOut();
    $('#form-signup').delay(800).fadeIn();
    $('.btn-login').removeClass('active');
    $('.btn-signup').addClass('active');

  })
  $('.btn-cadastrado').click(function(){
    $('#form-signup').fadeOut();
    $('#form-login').delay(800).fadeIn();
    $('.btn-signup').removeClass('active');
    $('.btn-login').addClass('active');
  })
});  
