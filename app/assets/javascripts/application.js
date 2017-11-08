//= require jquery3
//= require jquery_ujs
//= require underscore
//= require jquery_ujs_extensions
//= require jquery-ui
//= require tether
//= require popper
//= require bootstrap
//= require moment
//= require fullcalendar
//= require metisMenu
//= require select2
//= require microplugin
//= require sifter
//= require selectize
//= require icheck

//= require tools
//= require evman
//= require_tree ./evman
//= require turbolinks

$.fn.select2.defaults.set("width", "100%");

var evman;
evman = $.evman = new EvMan.App();
evman.init();

function resizeBroadcast() {
  var timesRun = 0;
  var interval = setInterval(function(){
    timesRun += 1;
    if(timesRun === 5){
      clearInterval(interval);
    }
    window.dispatchEvent(new Event('resize'));
  }, 62.5);
}

$(document).on('turbolinks:load', function(){
    $('.nav-dropdown-toggle').click(function(e){
        $('.nav-dropdown').removeClass('open');
        $(this).parent().addClass('open');
        e.preventDefault();
    });

    $('.navbar-toggler').click(function(e){
      $('body').toggleClass('sidebar-mobile-show');
      resizeBroadcast()
    });

    $('[data-toggle="tooltip"]').tooltip();
});