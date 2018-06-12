$(document).on("turbolinks:load", function() {
  $('.btn-cadastrar, .btn-signup').click(function(){
    $('#form-login').fadeOut();
    $('#form-signup').delay(800).fadeIn();
    $('.btn-login').removeClass('active');
    $('.btn-signup').addClass('active');

  })
  $('.btn-cadastrado, .btn-login').click(function(){
    $('#form-signup').fadeOut();
    $('#form-login').delay(800).fadeIn();
    $('.btn-signup').removeClass('active');
    $('.btn-login').addClass('active');
  })
});  
