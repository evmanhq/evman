//= require vue
//= require vue-multiselect

//= require jquery.js
//= require jquery_ujs
//= require underscore
//= require turbolinks
//= require jquery_ujs_extensions
//= require jquery-ui
//= require tether
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
//= require extracts

Vue.component('Multiselect', VueMultiselect.default);

$.fn.select2.defaults.set("width", "100%");

var evman;

$(function(){
    evman = $.evman = new EvMan.App();
    evman.init();
});

$(document).on('turbolinks:load', function(){
    $('.nav-dropdown-toggle').click(function(e){
        $('.nav-dropdown').removeClass('open');
        $(this).parent().addClass('open');
        e.preventDefault();
    });

    $('.navbar-toggler').click(function(e){
        var bodyClass = localStorage.getItem('body-class');
        var body = $('body');

        if ($(this).hasClass('layout-toggler') && body.hasClass('sidebar-off-canvas')) {
            body.toggleClass('sidebar-opened').parent().toggleClass('sidebar-opened');
            resizeBroadcast();
        } else if ($(this).hasClass('layout-toggler') && (body.hasClass('sidebar-nav') || bodyClass == 'sidebar-nav')) {
            body.toggleClass('sidebar-nav');
            localStorage.setItem('body-class', 'sidebar-nav');
            if (bodyClass == 'sidebar-nav') {
                localStorage.clear();
            }
            resizeBroadcast();
        } else {
            body.toggleClass('mobile-open');
        }
    });
});